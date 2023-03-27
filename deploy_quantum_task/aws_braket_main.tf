provider "quantumrunners" {
}

variable "output_key_prefix" {
  type = string
  default = "test"
}

data "quantumrunners_devices" "devices" {
}

resource "quantumrunners_quantum_circuit" "ghz_circuit" {
  qasm_content = data.local_file.ghz.content
}

resource "quantumrunners_quantum_circuit" "graph_state_circuit" {
  qasm_content = data.local_file.graph_state.content
}

resource "quantumrunners_task" "ghz_task" {
  circuit = quantumrunners_quantum_circuit.ghz_circuit.action
  # device_id = "arn:aws:braket:us-west-1::device/qpu/rigetti/Aspen-M-3"
  device_id = "arn:aws:braket:::device/quantum-simulator/amazon/dm1"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 1000
}

resource "quantumrunners_task" "graph_state_task" {
  circuit = quantumrunners_quantum_circuit.graph_state_circuit.action
  # device_id = "arn:aws:braket:us-west-1::device/qpu/rigetti/Aspen-M-3"
  device_id = "arn:aws:braket:::device/quantum-simulator/amazon/dm1"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 1000
}

output "task_metadata" {
  value = {
    ghz_task = {
      arn = quantumrunners_task.ghz_task.task_id,
      status = quantumrunners_task.ghz_task.task_status
    },
    graph_state_task = {
      arn = quantumrunners_task.graph_state_task.task_id,
      status = quantumrunners_task.graph_state_task.task_status
    }
  }
}
