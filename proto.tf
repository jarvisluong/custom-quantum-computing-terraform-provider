# This is the custom provider that we will be running
provider "custom_quantum_runner" {
}

data "local_file" "qasm" {
  filename = "example.qasm"
}

data "local_file" "parameter" {
  filename = "parameters.json"
}

resource "quantum_device" "quantum_runner" {
  id = "arn:aws:braket:::device/quantum-simulator/amazon/sv1"
}

resource "quantum_circuit" "circuit" {
  circuit = data.local_file.qasm.content
  device = quantum_device.quantum_runner.id
  parameter = data.local_file.parameter.content
}

data "quantum_result" "circuit_result" {
    task = quantum_circuit.circuit.task_id
}
