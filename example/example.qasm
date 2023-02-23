OPENQASM 3.0;
qubit[1] q;
h q[0];
#pragma braket result probability q[0]
