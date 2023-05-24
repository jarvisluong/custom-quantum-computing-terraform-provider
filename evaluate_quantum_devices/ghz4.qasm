OPENQASM 3.0;
bit[4] b;
qubit[4] q;
h q[0];
cnot q[0], q[1];
cnot q[1], q[2];
cnot q[2], q[3];
b = measure q;
