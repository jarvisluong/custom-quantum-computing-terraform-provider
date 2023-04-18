provider "quantumrunners" {
}

provider "quantumrunners" {
  alias = "uswest1"
  region = "us-west-1"
}

provider "quantumrunners" {
  alias = "euwest2"
  region = "eu-west-2"
}

variable "output_key_prefix" {
  type = string
  default = "test"
}

variable "qasm_circuit" {
  type = string
  required = true
}

variable "quantum_device_arn" {
  type = string
  required = true
}

resource "quantumrunners_quantum_circuit" "circuit" {
  qasm_content = variable.qasm_circuit
}

resource "quantumrunners_task" "ghz_task_simulator" {
  circuit = quantumrunners_quantum_circuit.circuit.action
  device_id = var.quantum_device_arn
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 100
}

output "task_metadata" {
  value = {
    ghz_task_simulator = {
      arn = quantumrunners_task.ghz_task_simulator.task_id,
      status = quantumrunners_task.ghz_task_simulator.task_status,
    }
  }
}
