import qiskit_braket_provider.providers.adapter as adapter
from braket.circuits.serialization import IRType
from qiskit import QuantumCircuit
from qiskit.compiler import transpile

from qiskit.circuit.library import GraphState
import rustworkx as rx

G = rx.generators.cycle_graph(5)

qc = transpile(GraphState(rx.adjacency_matrix(G)), basis_gates=['cz', 'xy', 'ccnot', 'cnot', 'cphaseshift', 'cphaseshift00', 'cphaseshift01', 'cphaseshift10', 'cswap', 'h', 'i', 'iswap', 'phaseshift', 'pswap', 'rx', 'ry', 'rz', 's', 'si', 'swap', 't', 'ti', 'x', 'y', 'z'
])

converted_to_aws_qc = adapter.convert_qiskit_to_braket_circuit(qc)
print(converted_to_aws_qc.to_ir(ir_type = IRType.OPENQASM).source)
