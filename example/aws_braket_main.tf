provider "quantumrunners" {
}

variable "output_key_prefix" {
  type = string
  default = "test"
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
  # device_id = "arn:aws:braket:us-west-1::device/qpu/rigetti/Aspen-M-3"
  device_id = "arn:aws:braket:::device/quantum-simulator/amazon/sv1"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 10
}

data "aws_s3_object" "run_result" {
  count = quantumrunners_task.task.task_status == "COMPLETED" ? 1 : 0
  bucket = resource.aws_s3_bucket.braket_result.bucket
  key    = "${var.output_key_prefix}/${split("/", quantumrunners_task.task.task_id)[1]}/results.json"
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

output "task_result" {
  value = data.aws_s3_object.run_result[0].body
}
