import qiskit_braket_provider.providers.adapter as adapter
from braket.circuits.serialization import IRType
from qiskit import QuantumCircuit
from qiskit.compiler import transpile

from qiskit.circuit.library import GraphState
import rustworkx as rx

G = rx.generators.cycle_graph(4)

qc = transpile(GraphState(rx.adjacency_matrix(G)), basis_gates=['x', 'y', 'z', 'h', 'cnot', 'rx', 'ry', 'rz', 'cx'])

converted_to_aws_qc = adapter.convert_qiskit_to_braket_circuit(qc)
print(converted_to_aws_qc.to_ir(ir_type = IRType.OPENQASM).source)
