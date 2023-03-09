import qiskit_braket_provider.providers.adapter as adapter
from braket.circuits.serialization import IRType
from qiskit import QuantumCircuit

qc = QuantumCircuit(1,1)
qc.h(0)
qc.measure(0,0)

converted_to_aws_qc = adapter.convert_qiskit_to_braket_circuit(qc)
print(converted_to_aws_qc.to_ir(ir_type = IRType.OPENQASM).source)
