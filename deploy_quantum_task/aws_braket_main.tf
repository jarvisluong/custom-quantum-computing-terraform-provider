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

resource "quantumrunners_quantum_circuit" "ghz_circuit" {
  qasm_content = data.local_file.ghz.content
}

resource "quantumrunners_quantum_circuit" "graph_state_circuit" {
  qasm_content = data.local_file.graph_state.content
}

resource "quantumrunners_quantum_circuit" "hidden_linear_function" {
  qasm_content = data.local_file.hidden_linear_function.content
}

#### GHZ tasks ####

resource "quantumrunners_task" "ghz_task_simulator" {
  circuit = quantumrunners_quantum_circuit.ghz_circuit.action
  device_id = "arn:aws:braket:::device/quantum-simulator/amazon/sv1"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 100
}

resource "quantumrunners_task" "ghz_task_ionq" {
  circuit = quantumrunners_quantum_circuit.ghz_circuit.action
  device_id = "arn:aws:braket:::device/qpu/ionq/ionQdevice"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 100
}

resource "quantumrunners_task" "ghz_task_rigetti" {
  provider = quantumrunners.uswest1
  circuit = quantumrunners_quantum_circuit.ghz_circuit.action
  device_id = "arn:aws:braket:us-west-1::device/qpu/rigetti/Aspen-M-3"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 100
}

resource "quantumrunners_task" "ghz_task_lucy" {
  provider = quantumrunners.euwest2
  circuit = quantumrunners_quantum_circuit.ghz_circuit.action
  device_id = "arn:aws:braket:eu-west-2::device/qpu/oqc/Lucy"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 100
}

#### Graph State tasks ####

resource "quantumrunners_task" "graph_state_task_simulator" {
  circuit = quantumrunners_quantum_circuit.graph_state_circuit.action
  device_id = "arn:aws:braket:::device/quantum-simulator/amazon/dm1"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 1000
}

resource "quantumrunners_task" "graph_state_task_ionq" {
  circuit = quantumrunners_quantum_circuit.graph_state_circuit.action
  device_id = "arn:aws:braket:::device/qpu/ionq/ionQdevice"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 1000
}

resource "quantumrunners_task" "graph_state_task_rigetti" {
  provider = quantumrunners.uswest1
  circuit = quantumrunners_quantum_circuit.graph_state_circuit.action
  device_id = "arn:aws:braket:us-west-1::device/qpu/rigetti/Aspen-M-3"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 1000
}

resource "quantumrunners_task" "graph_state_task_lucy" {
  provider = quantumrunners.euwest2
  circuit = quantumrunners_quantum_circuit.graph_state_circuit.action
  device_id = "arn:aws:braket:eu-west-2::device/qpu/oqc/Lucy"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 1000
}

#### hidden_linear_function tasks ####

resource "quantumrunners_task" "hidden_linear_function_simulator" {
  circuit = quantumrunners_quantum_circuit.hidden_linear_function.action
  device_id = "arn:aws:braket:::device/quantum-simulator/amazon/dm1"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 1000
}

resource "quantumrunners_task" "hidden_linear_function_ionq" {
  circuit = quantumrunners_quantum_circuit.hidden_linear_function.action
  device_id = "arn:aws:braket:::device/qpu/ionq/ionQdevice"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 1000
}

resource "quantumrunners_task" "hidden_linear_function_rigetti" {
  provider = quantumrunners.uswest1
  circuit = quantumrunners_quantum_circuit.hidden_linear_function.action
  device_id = "arn:aws:braket:us-west-1::device/qpu/rigetti/Aspen-M-3"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 1000
}

resource "quantumrunners_task" "hidden_linear_function_lucy" {
  provider = quantumrunners.euwest2
  circuit = quantumrunners_quantum_circuit.hidden_linear_function.action
  device_id = "arn:aws:braket:eu-west-2::device/qpu/oqc/Lucy"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 1000
}

output "task_metadata" {
  value = {
    ghz_task_simulator = {
      arn = quantumrunners_task.ghz_task_simulator.task_id,
      status = quantumrunners_task.ghz_task_simulator.task_status,
      is_simulator = true
    },
    ghz_task_ionq = {
      arn = quantumrunners_task.ghz_task_ionq.task_id,
      status = quantumrunners_task.ghz_task_ionq.task_status
    },
    ghz_task_rigetti = {
      arn = quantumrunners_task.ghz_task_rigetti.task_id,
      status = quantumrunners_task.ghz_task_rigetti.task_status
    },
    ghz_task_lucy = {
      arn = quantumrunners_task.ghz_task_lucy.task_id,
      status = quantumrunners_task.ghz_task_lucy.task_status
    },
    graph_state_task_simulator = {
      arn = quantumrunners_task.graph_state_task_simulator.task_id,
      status = quantumrunners_task.graph_state_task_simulator.task_status,
      is_simulator = true
    },
    graph_state_task_ionq = {
      arn = quantumrunners_task.graph_state_task_ionq.task_id,
      status = quantumrunners_task.graph_state_task_ionq.task_status
    },
    graph_state_task_rigetti = {
      arn = quantumrunners_task.graph_state_task_rigetti.task_id,
      status = quantumrunners_task.graph_state_task_rigetti.task_status
    },
    graph_state_task_lucy = {
      arn = quantumrunners_task.graph_state_task_lucy.task_id,
      status = quantumrunners_task.graph_state_task_lucy.task_status
    },
    hidden_linear_function_simulator = {
      arn = quantumrunners_task.hidden_linear_function_simulator.task_id,
      status = quantumrunners_task.hidden_linear_function_simulator.task_status,
      is_simulator = true
    },
    hidden_linear_function_ionq = {
      arn = quantumrunners_task.hidden_linear_function_ionq.task_id,
      status = quantumrunners_task.hidden_linear_function_ionq.task_status
    },
    hidden_linear_function_rigetti = {
      arn = quantumrunners_task.hidden_linear_function_rigetti.task_id,
      status = quantumrunners_task.hidden_linear_function_rigetti.task_status
    },
    hidden_linear_function_lucy = {
      arn = quantumrunners_task.hidden_linear_function_lucy.task_id,
      status = quantumrunners_task.hidden_linear_function_lucy.task_status
    }
  }
}
