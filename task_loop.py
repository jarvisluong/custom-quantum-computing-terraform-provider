import time
from python_terraform import Terraform

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

def run_loop_circuit(device_arn):
    # Implement your long operation here
    print(f"Execute circuit in device: {device_arn}")
    (return_code, stdout, stderr) = t.apply_cmd(
        auto_approve=True,
        capture_output=True, 
        var={
            'quantum_device_arn': device_arn,
            'qasm_circuit': circuit
        }
    )

def main(param_queue):
    while True:
        if not param_queue.empty():
            device_arn = param_queue.get()
            run_loop_circuit(device_arn)
        else:
            time.sleep(1)  # Sleep to avoid busy waiting
