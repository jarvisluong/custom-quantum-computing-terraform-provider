from python_terraform import Terraform
import json
import numpy as np
import pydash as _
import boto3
from botocore.config import Config
from arn import Arn

s3 = boto3.resource('s3')

t = Terraform(working_dir='./deploy_quantum_task')

def step_print(msg):
    print("\n")
    print(f"===== {msg} =====")

def get_quantum_task_measurements(name, arn):
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
        return np.array(content['measurements'])

def frobenius_norm(A, B):
    return np.linalg.norm(A - B, 'fro')

# step_print("Apply latest terraform state")
# t.apply_cmd(auto_approve=True, capture_output=False)

step_print("Get terraform state output")
(return_code, stdout, stderr) = t.output_cmd(json=True)
json_out = json.loads(str(stdout))

task_metadata = _.get(json_out, "task_metadata.value")

task_names = _.filter_(
    list(task_metadata.keys()),
    lambda name: task_metadata[name]['status'] == 'COMPLETED'
)

# ghz_task_names = _.filter_(task_names, lambda x: _.starts_with(x, 'ghz_task'))
# ghz_completed_task_arns = _.map_(
#     _.filter_(ghz_task_names, lambda name: task_metadata[name]['status'] == 'COMPLETED'),
#     lambda name: task_metadata[name]['arn']
# )

graph_state_task_names = _.filter_(
    task_names,
    lambda name: _.starts_with(name, 'graph_state_task')
)
print("Graph state tasks:", ", ".join(graph_state_task_names))

graph_state_task_simulator_name = "graph_state_task_simulator"
graph_state_task_simulator_arn = task_metadata["graph_state_task_simulator"]['arn']
graph_state_task_simulator_measurement = get_quantum_task_measurements(
    graph_state_task_simulator_name,
    graph_state_task_simulator_arn)

graph_state_task_qpu_names = _.filter_(
    graph_state_task_names,
    lambda name: name != graph_state_task_simulator_name
)
print("Benchmarking tasks: " + ", ".join(graph_state_task_qpu_names))
graph_state_task_qpu_task_arns = [task_metadata[name]['arn'] for name in graph_state_task_qpu_names]

graph_state_task_qpu_task_measurements = [
    get_quantum_task_measurements(
        task_name,
        task_metadata[task_name]['arn']
    ) 
    for task_name in graph_state_task_qpu_names
]
# Calculate the Frobenius norms
frobenius_norms = [
    frobenius_norm(graph_state_task_simulator_measurement, measurement_matrix) 
    for measurement_matrix in graph_state_task_qpu_task_measurements
]
print("Frobenius norm for each task: " + "".join([str(norm) for norm in frobenius_norms]))

# Find the index of the measurement matrix with the smallest Frobenius norm
closest_index = np.argmin(frobenius_norms)

print("Closest measurement matrix:", graph_state_task_qpu_names[closest_index])
