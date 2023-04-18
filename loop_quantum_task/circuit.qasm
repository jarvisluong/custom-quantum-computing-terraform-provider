# A toy circuit to denote that the task will run this circuit in a loop

OPENQASM 3.0;
bit[3] b;
qubit[3] q;
h q[0];
cnot q[0], q[1];
h q[1];
cnot q[0], q[2];
h q[0];
cnot q[1], q[2];
h q[1];
b[0] = measure q[0];
b[1] = measure q[1];
b[2] = measure q[2];
