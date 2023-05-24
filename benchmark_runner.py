import time
from python_terraform import Terraform
import json
import numpy as np
import pydash as _
import boto3
from botocore.config import Config
from arn import Arn
import itertools

FIDELITY_FORMULA = 'total_variation_distance'

def total_variation_distance(P, Q):
    return 0.5 * np.sum(np.abs(P - Q))

def hellinger_fidelity(P, Q):
    return np.sum(np.sqrt(P * Q))

FIDELITY_IMPL = {
    'hellinger': hellinger_fidelity,
    'total_variation_distance': total_variation_distance
}

s3 = boto3.resource('s3')

t = Terraform(working_dir='./evaluate_quantum_devices')

def step_print(msg):
    print("\n")
    print(f"===== {msg} =====")

def get_quantum_task_measurement_probabilities(name, arn):
    arn_obj = Arn(input_arn=arn)
    braket_config = Config(
        region_name = arn_obj.region
    )
    braket = boto3.client('braket', config=braket_config)
    target_download_file_path = f"/tmp/{name}.json"
    response = braket.get_quantum_task(
        quantumTaskArn=arn
    )
    s3.meta.client.download_file(
        response['outputS3Bucket'],
        f"{response['outputS3Directory']}/results.json",
        target_download_file_path
    )
    with open(target_download_file_path) as result_file:
        content = json.load(result_file)
        output = None
        # We are assuming the measurementProbabilities is arranged in alphabetical order
        if 'measurementProbabilities' in content:
            permutations = list(itertools.product(range(2), repeat=len(content['measuredQubits'])))
            all_possible_states = [''.join([str(num) for num in permutation]) for permutation in permutations]
            all_states_count = [_.get(content['measurementProbabilities'], state, 0) for state in all_possible_states]
            output = np.array(all_states_count)
        else:
            permutations = list(itertools.product(range(2), repeat=len(content['measuredQubits'])))
            all_possible_states = [''.join([str(num) for num in permutation]) for permutation in permutations]
            measurements = content['measurements']
            joined_measurement = map(lambda measurement: ''.join(map(lambda x: str(x), measurement)), measurements)
            counted_measurement = _.count_by(joined_measurement)
            all_states_count = [_.get(counted_measurement, state, 0) for state in all_possible_states]
            output = np.array([count / len(measurements) for count in all_states_count])
        print(f"Measurement probability for {name}: {str(output)}")
        return output

def fidelity(P, Q):
    return FIDELITY_IMPL[FIDELITY_FORMULA](P, Q)

def benchmark_for_task(all_task_names, task_name, task_metadata):
    step_print(f"Benchmark for task ${task_name}")
    task_names = _.filter_(
        all_task_names,
        lambda name: _.starts_with(name, task_name)
    )
    print("Graph state tasks:", ", ".join(task_names))

    task_simulator_name = f"{task_name}_simulator"
    task_simulator_arn = task_metadata[task_simulator_name]['arn']
    task_simulator_measurement = get_quantum_task_measurement_probabilities(
        task_simulator_name,
        task_simulator_arn)

    task_qpu_names = _.filter_(
        task_names,
        lambda name: name != task_simulator_name
    )
    print("Benchmarking tasks: " + ", ".join(task_qpu_names))

    task_qpu_task_measurements = [
        get_quantum_task_measurement_probabilities(
            task_name,
            task_metadata[task_name]['arn']
        ) 
        for task_name in task_qpu_names
    ]
    # Calculate the fidelity using TVD
    fidelities = [
        fidelity(task_simulator_measurement, measurement_matrix) 
        for measurement_matrix in task_qpu_task_measurements
    ]
    print("Fidelty for each task: " + ", ".join([str(value) for value in fidelities]))

    # Find the index of the measurement matrix with the smallest Frobenius norm
    closest_index = np.argmax(fidelities)

    print("Closest measurement matrix:", task_qpu_names[closest_index])
    return task_qpu_names[closest_index]


def poll_task_status():
    while True:
        step_print("Apply latest terraform state")
        (return_code, stdout, stderr) = t.apply_cmd(auto_approve=True, capture_output=True)
        print(stdout)

        step_print("Get terraform state output")
        (_1, stdout, _2) = t.output_cmd(json=True)
        json_out = json.loads(str(stdout))

        task_metadata = _.get(json_out, "task_metadata.value")

        any_pending_tasks = _.filter_(
            list(task_metadata.keys()),
            lambda name: task_metadata[name]['status'] == 'CREATED' or task_metadata[name]['status'] == 'QUEUED'
        )

        if len(any_pending_tasks) == 0:
            return task_metadata
        print(f"Tasks {', '.join(any_pending_tasks)} are still pending, re-running in 5 seconds")
        time.sleep(5.0)

# Find most frequent element in a list
def most_frequent(List):
    return max(set(List), key = List.count)
 

def main(param_queue = None):
    while True:
        task_metadata = poll_task_status()
        all_task_names = _.filter_(
            list(task_metadata.keys()),
            lambda name: task_metadata[name]['status'] == 'COMPLETED'
        )
        step_print(f"Using ${FIDELITY_FORMULA} for benchmarking")

        results = [
            benchmark_for_task(all_task_names, "ghz2_task", task_metadata),
            benchmark_for_task(all_task_names, "ghz3_task", task_metadata),
            benchmark_for_task(all_task_names, "ghz4_task", task_metadata),
            benchmark_for_task(all_task_names, "ghz5_task", task_metadata),
        ]

        best_device_arn = task_metadata[most_frequent(results)]['device']
        if param_queue != None:
            param_queue.put(best_device_arn)
        time.sleep(3600)  # Sleep for an hour

if (__name__ == '__main__'):
    main()