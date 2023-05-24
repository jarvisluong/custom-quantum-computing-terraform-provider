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

data "quantumrunners_devices" "devices_us_east_1" {
}

data "quantumrunners_devices" "devices_us_west_1" {
  provider = quantumrunners.uswest1
}

data "quantumrunners_devices" "devices_eu_west_2" {
  provider = quantumrunners.euwest2
}

resource "quantumrunners_quantum_circuit" "ghz3" {
  qasm_content = data.local_file.ghz3.content
}

resource "quantumrunners_quantum_circuit" "ghz4" {
  qasm_content = data.local_file.ghz4.content
}

resource "quantumrunners_quantum_circuit" "ghz5" {
  qasm_content = data.local_file.ghz5.content
}

resource "quantumrunners_quantum_circuit" "ghz2" {
  qasm_content = data.local_file.ghz2.content
}

#### GHZ2 tasks ####

resource "quantumrunners_task" "ghz2_task_simulator" {
  circuit = quantumrunners_quantum_circuit.ghz2.action
  device_id = "arn:aws:braket:::device/quantum-simulator/amazon/sv1"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 10
}

resource "quantumrunners_task" "ghz2_task_rigetti" {
  provider = quantumrunners.uswest1
  circuit = quantumrunners_quantum_circuit.ghz2.action
  device_id = "arn:aws:braket:us-west-1::device/qpu/rigetti/Aspen-M-3"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 10
}

resource "quantumrunners_task" "ghz2_task_lucy" {
  provider = quantumrunners.euwest2
  circuit = quantumrunners_quantum_circuit.ghz2.action
  device_id = "arn:aws:braket:eu-west-2::device/qpu/oqc/Lucy"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 10
}

#### GHZ3 tasks ####

resource "quantumrunners_task" "ghz3_task_simulator" {
  circuit = quantumrunners_quantum_circuit.ghz3.action
  device_id = "arn:aws:braket:::device/quantum-simulator/amazon/sv1"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 100
}

resource "quantumrunners_task" "ghz3_task_rigetti" {
  provider = quantumrunners.uswest1
  circuit = quantumrunners_quantum_circuit.ghz3.action
  device_id = "arn:aws:braket:us-west-1::device/qpu/rigetti/Aspen-M-3"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 100
}

resource "quantumrunners_task" "ghz3_task_lucy" {
  provider = quantumrunners.euwest2
  circuit = quantumrunners_quantum_circuit.ghz3.action
  device_id = "arn:aws:braket:eu-west-2::device/qpu/oqc/Lucy"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 100
}

#### GHZ4 tasks ####

resource "quantumrunners_task" "ghz4_task_simulator" {
  circuit = quantumrunners_quantum_circuit.ghz4.action
  device_id = "arn:aws:braket:::device/quantum-simulator/amazon/sv1"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 1000
}

resource "quantumrunners_task" "ghz4_task_rigetti" {
  provider = quantumrunners.uswest1
  circuit = quantumrunners_quantum_circuit.ghz4.action
  device_id = "arn:aws:braket:us-west-1::device/qpu/rigetti/Aspen-M-3"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 1000
}

resource "quantumrunners_task" "ghz4_task_lucy" {
  provider = quantumrunners.euwest2
  circuit = quantumrunners_quantum_circuit.ghz4.action
  device_id = "arn:aws:braket:eu-west-2::device/qpu/oqc/Lucy"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 1000
}

#### GHZ5 tasks ####

resource "quantumrunners_task" "ghz5_task_simulator" {
  circuit = quantumrunners_quantum_circuit.ghz5.action
  device_id = "arn:aws:braket:::device/quantum-simulator/amazon/sv1"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 10000
}

resource "quantumrunners_task" "ghz5_task_rigetti" {
  provider = quantumrunners.uswest1
  circuit = quantumrunners_quantum_circuit.ghz5.action
  device_id = "arn:aws:braket:us-west-1::device/qpu/rigetti/Aspen-M-3"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 10000
}

resource "quantumrunners_task" "ghz5_task_lucy" {
  provider = quantumrunners.euwest2
  circuit = quantumrunners_quantum_circuit.ghz5.action
  device_id = "arn:aws:braket:eu-west-2::device/qpu/oqc/Lucy"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 10000
}

output "task_metadata" {
  value = {
    ghz2_task_simulator = {
      arn = quantumrunners_task.ghz2_task_simulator.task_id,
      status = quantumrunners_task.ghz2_task_simulator.task_status,
      device = quantumrunners_task.ghz2_task_simulator.device_id,
      is_simulator = true
    },
    ghz2_task_rigetti = {
      arn = quantumrunners_task.ghz2_task_rigetti.task_id,
      device = quantumrunners_task.ghz2_task_rigetti.device_id,
      status = quantumrunners_task.ghz2_task_rigetti.task_status
    },
    ghz2_task_lucy = {
      arn = quantumrunners_task.ghz2_task_lucy.task_id,
      status = quantumrunners_task.ghz2_task_lucy.task_status,
      device = quantumrunners_task.ghz2_task_lucy.device_id,
    },
    ghz3_task_simulator = {
      arn = quantumrunners_task.ghz3_task_simulator.task_id,
      status = quantumrunners_task.ghz3_task_simulator.task_status,
      device = quantumrunners_task.ghz3_task_simulator.device_id,
      is_simulator = true
    },
    ghz3_task_rigetti = {
      arn = quantumrunners_task.ghz3_task_rigetti.task_id,
      device = quantumrunners_task.ghz3_task_rigetti.device_id,
      status = quantumrunners_task.ghz3_task_rigetti.task_status
    },
    ghz3_task_lucy = {
      arn = quantumrunners_task.ghz3_task_lucy.task_id,
      status = quantumrunners_task.ghz3_task_lucy.task_status,
      device = quantumrunners_task.ghz3_task_lucy.device_id,
    },
    ghz4_task_simulator = {
      arn = quantumrunners_task.ghz4_task_simulator.task_id,
      status = quantumrunners_task.ghz4_task_simulator.task_status,
      device = quantumrunners_task.ghz4_task_simulator.device_id,
      is_simulator = true
    },
    ghz4_task_rigetti = {
      arn = quantumrunners_task.ghz4_task_rigetti.task_id,
      device = quantumrunners_task.ghz4_task_rigetti.device_id,
      status = quantumrunners_task.ghz4_task_rigetti.task_status
    },
    ghz4_task_lucy = {
      arn = quantumrunners_task.ghz4_task_lucy.task_id,
      status = quantumrunners_task.ghz4_task_lucy.task_status,
      device = quantumrunners_task.ghz4_task_lucy.device_id,
    },

    ghz5_task_simulator = {
      arn = quantumrunners_task.ghz5_task_simulator.task_id,
      status = quantumrunners_task.ghz5_task_simulator.task_status,
      device = quantumrunners_task.ghz5_task_simulator.device_id,
      is_simulator = true
    },
    ghz5_task_rigetti = {
      arn = quantumrunners_task.ghz5_task_rigetti.task_id,
      device = quantumrunners_task.ghz5_task_rigetti.device_id,
      status = quantumrunners_task.ghz5_task_rigetti.task_status
    },
    ghz5_task_lucy = {
      arn = quantumrunners_task.ghz5_task_lucy.task_id,
      status = quantumrunners_task.ghz5_task_lucy.task_status,
      device = quantumrunners_task.ghz5_task_lucy.device_id,
    },
  }
}
