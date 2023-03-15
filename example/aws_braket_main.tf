provider "quantumrunners" {
}

variable "output_key_prefix" {
  type = string
  default = "test"
}

data "quantumrunners_devices" "devices" {
}

resource "quantumrunners_quantum_circuit" "circuit" {
  qasm_content = data.local_file.qasm.content
}

resource "quantumrunners_task" "task" {
  circuit = quantumrunners_quantum_circuit.circuit.action
  # device_id = "arn:aws:braket:us-west-1::device/qpu/rigetti/Aspen-M-3"
  device_id = "arn:aws:braket:::device/quantum-simulator/amazon/sv1"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 10
}

output "task_id" {
  value = split("/", quantumrunners_task.task.task_id)[1]
}

output "task_arn" {
  value = quantumrunners_task.task.task_id
}

output "task_status" {
  value = quantumrunners_task.task.task_status
}
