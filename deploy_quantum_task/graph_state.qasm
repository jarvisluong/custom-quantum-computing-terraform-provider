OPENQASM 3.0;
bit[5] b;
qubit[5] q;
h q[0];
h q[1];
cz q[0], q[1];
h q[2];
cz q[1], q[2];
h q[3];
cz q[2], q[3];
h q[4];
cz q[0], q[4];
cz q[3], q[4];
b[0] = measure q[0];
b[1] = measure q[1];
b[2] = measure q[2];
b[3] = measure q[3];
b[4] = measure q[4];
