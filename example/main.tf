provider "quantumrunners" {
}

data "quantumrunners_devices" "devices" {
}

data "local_file" "qasm" {
  filename = "example.qasm"
}

resource "quantumrunners_quantum_circuit" "circuit" {
  qasm_content = data.local_file.qasm.content
}

resource "quantumrunners_task" "task" {
  circuit = quantumrunners_quantum_circuit.circuit.action
  device_id = "arn:aws:braket:::device/quantum-simulator/amazon/sv1"
  output_destination = resource.aws_s3_bucket.braket_result.arn
  output_key_prefix = "test"
  shots = 10
}

output "devices" {
  value = data.quantumrunners_devices.devices
}

output "task_id" {
  value = quantumrunners_task.task.task_id
}
