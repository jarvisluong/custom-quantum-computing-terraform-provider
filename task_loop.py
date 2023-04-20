import json
import time
from python_terraform import Terraform
import pydash as _

t = Terraform(working_dir='./loop_quantum_task')

circuit = """
// ghz.qasm
// Prepare a GHZ state
OPENQASM 3;

qubit[3] q;
bit[3] c;

h q[0];
cnot q[0], q[1];
cnot q[1], q[2];

c = measure q;
"""

def run_loop_circuit(device_arn, number_of_runs):
    # Implement your long operation here
    print(f"Execute circuit in device: {device_arn}")
    while True:
        print("Apply latest terraform state")
        (return_code, stdout, stderr) = t.apply_cmd(
            auto_approve=True,
            capture_output=True, 
            var={
                'quantum_device_arn': device_arn,
                'qasm_circuit': circuit,
                'output_key_prefix': f"loop_run/{number_of_runs}"
            }
        )
        print(stdout)

        print("Get terraform state output")
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

def main(param_queue):
    number_of_runs = 0
    while True:
        if not param_queue.empty():
            device_arn = param_queue.get()
            run_loop_circuit(device_arn, number_of_runs)
            number_of_runs += 1
        else:
            time.sleep(1)  # Sleep to avoid busy waiting
