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

output "devices" {
  value = data.quantumrunners_devices.devices
}

output "file" {
  value = data.local_file.qasm
}
