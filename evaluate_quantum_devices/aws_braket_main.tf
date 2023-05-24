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

resource "quantumrunners_quantum_circuit" "graph_state3" {
  qasm_content = data.local_file.graph_state3.content
}

resource "quantumrunners_quantum_circuit" "graph_state4" {
  qasm_content = data.local_file.graph_state4.content
}

resource "quantumrunners_quantum_circuit" "graph_state5" {
  qasm_content = data.local_file.graph_state5.content
}

resource "quantumrunners_quantum_circuit" "graph_state2" {
  qasm_content = data.local_file.graph_state2.content
}

#### graph_state2 tasks ####

resource "quantumrunners_task" "graph_state2_task_simulator" {
  circuit = quantumrunners_quantum_circuit.graph_state2.action
  device_id = "arn:aws:braket:::device/quantum-simulator/amazon/sv1"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 10
}

resource "quantumrunners_task" "graph_state2_task_rigetti" {
  provider = quantumrunners.uswest1
  circuit = quantumrunners_quantum_circuit.graph_state2.action
  device_id = "arn:aws:braket:us-west-1::device/qpu/rigetti/Aspen-M-3"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 10
}

# resource "quantumrunners_task" "graph_state2_task_lucy" {
#   provider = quantumrunners.euwest2
#   circuit = quantumrunners_quantum_circuit.graph_state2.action
#   device_id = "arn:aws:braket:eu-west-2::device/qpu/oqc/Lucy"
#   output_destination = resource.aws_s3_bucket.braket_result.bucket
#   output_key_prefix = var.output_key_prefix
#   shots = 10
# }

#### graph_state3 tasks ####

resource "quantumrunners_task" "graph_state3_task_simulator" {
  circuit = quantumrunners_quantum_circuit.graph_state3.action
  device_id = "arn:aws:braket:::device/quantum-simulator/amazon/sv1"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 100
}

resource "quantumrunners_task" "graph_state3_task_rigetti" {
  provider = quantumrunners.uswest1
  circuit = quantumrunners_quantum_circuit.graph_state3.action
  device_id = "arn:aws:braket:us-west-1::device/qpu/rigetti/Aspen-M-3"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 100
}

# resource "quantumrunners_task" "graph_state3_task_lucy" {
#   provider = quantumrunners.euwest2
#   circuit = quantumrunners_quantum_circuit.graph_state3.action
#   device_id = "arn:aws:braket:eu-west-2::device/qpu/oqc/Lucy"
#   output_destination = resource.aws_s3_bucket.braket_result.bucket
#   output_key_prefix = var.output_key_prefix
#   shots = 100
# }

#### graph_state4 tasks ####

resource "quantumrunners_task" "graph_state4_task_simulator" {
  circuit = quantumrunners_quantum_circuit.graph_state4.action
  device_id = "arn:aws:braket:::device/quantum-simulator/amazon/sv1"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 1000
}

resource "quantumrunners_task" "graph_state4_task_rigetti" {
  provider = quantumrunners.uswest1
  circuit = quantumrunners_quantum_circuit.graph_state4.action
  device_id = "arn:aws:braket:us-west-1::device/qpu/rigetti/Aspen-M-3"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 1000
}

# resource "quantumrunners_task" "graph_state4_task_lucy" {
#   provider = quantumrunners.euwest2
#   circuit = quantumrunners_quantum_circuit.graph_state4.action
#   device_id = "arn:aws:braket:eu-west-2::device/qpu/oqc/Lucy"
#   output_destination = resource.aws_s3_bucket.braket_result.bucket
#   output_key_prefix = var.output_key_prefix
#   shots = 1000
# }

#### graph_state5 tasks ####

resource "quantumrunners_task" "graph_state5_task_simulator" {
  circuit = quantumrunners_quantum_circuit.graph_state5.action
  device_id = "arn:aws:braket:::device/quantum-simulator/amazon/sv1"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 10000
}

resource "quantumrunners_task" "graph_state5_task_rigetti" {
  provider = quantumrunners.uswest1
  circuit = quantumrunners_quantum_circuit.graph_state5.action
  device_id = "arn:aws:braket:us-west-1::device/qpu/rigetti/Aspen-M-3"
  output_destination = resource.aws_s3_bucket.braket_result.bucket
  output_key_prefix = var.output_key_prefix
  shots = 10000
}

# resource "quantumrunners_task" "graph_state5_task_lucy" {
#   provider = quantumrunners.euwest2
#   circuit = quantumrunners_quantum_circuit.graph_state5.action
#   device_id = "arn:aws:braket:eu-west-2::device/qpu/oqc/Lucy"
#   output_destination = resource.aws_s3_bucket.braket_result.bucket
#   output_key_prefix = var.output_key_prefix
#   shots = 10000
# }

output "task_metadata" {
  value = {
    graph_state2_task_simulator = {
      arn = quantumrunners_task.graph_state2_task_simulator.task_id,
      status = quantumrunners_task.graph_state2_task_simulator.task_status,
      device = quantumrunners_task.graph_state2_task_simulator.device_id,
      is_simulator = true
    },
    graph_state2_task_rigetti = {
      arn = quantumrunners_task.graph_state2_task_rigetti.task_id,
      device = quantumrunners_task.graph_state2_task_rigetti.device_id,
      status = quantumrunners_task.graph_state2_task_rigetti.task_status
    },
    # graph_state2_task_lucy = {
    #   arn = quantumrunners_task.graph_state2_task_lucy.task_id,
    #   status = quantumrunners_task.graph_state2_task_lucy.task_status,
    #   device = quantumrunners_task.graph_state2_task_lucy.device_id,
    # },
    graph_state3_task_simulator = {
      arn = quantumrunners_task.graph_state3_task_simulator.task_id,
      status = quantumrunners_task.graph_state3_task_simulator.task_status,
      device = quantumrunners_task.graph_state3_task_simulator.device_id,
      is_simulator = true
    },
    graph_state3_task_rigetti = {
      arn = quantumrunners_task.graph_state3_task_rigetti.task_id,
      device = quantumrunners_task.graph_state3_task_rigetti.device_id,
      status = quantumrunners_task.graph_state3_task_rigetti.task_status
    },
    # graph_state3_task_lucy = {
    #   arn = quantumrunners_task.graph_state3_task_lucy.task_id,
    #   status = quantumrunners_task.graph_state3_task_lucy.task_status,
    #   device = quantumrunners_task.graph_state3_task_lucy.device_id,
    # },
    graph_state4_task_simulator = {
      arn = quantumrunners_task.graph_state4_task_simulator.task_id,
      status = quantumrunners_task.graph_state4_task_simulator.task_status,
      device = quantumrunners_task.graph_state4_task_simulator.device_id,
      is_simulator = true
    },
    graph_state4_task_rigetti = {
      arn = quantumrunners_task.graph_state4_task_rigetti.task_id,
      device = quantumrunners_task.graph_state4_task_rigetti.device_id,
      status = quantumrunners_task.graph_state4_task_rigetti.task_status
    },
    # graph_state4_task_lucy = {
    #   arn = quantumrunners_task.graph_state4_task_lucy.task_id,
    #   status = quantumrunners_task.graph_state4_task_lucy.task_status,
    #   device = quantumrunners_task.graph_state4_task_lucy.device_id,
    # },

    graph_state5_task_simulator = {
      arn = quantumrunners_task.graph_state5_task_simulator.task_id,
      status = quantumrunners_task.graph_state5_task_simulator.task_status,
      device = quantumrunners_task.graph_state5_task_simulator.device_id,
      is_simulator = true
    },
    graph_state5_task_rigetti = {
      arn = quantumrunners_task.graph_state5_task_rigetti.task_id,
      device = quantumrunners_task.graph_state5_task_rigetti.device_id,
      status = quantumrunners_task.graph_state5_task_rigetti.task_status
    },
    # graph_state5_task_lucy = {
    #   arn = quantumrunners_task.graph_state5_task_lucy.task_id,
    #   status = quantumrunners_task.graph_state5_task_lucy.task_status,
    #   device = quantumrunners_task.graph_state5_task_lucy.device_id,
    # },
  }
}
