provider "quantumrunners" {
}

data "quantumrunners_devices" "devices" {
}

data "local_file" "qasm" {
  filename = "example.qasm"
}

output "devices" {
  value = data.quantumrunners_devices.devices
}

output "file" {
  value = data.local_file.qasm
}
