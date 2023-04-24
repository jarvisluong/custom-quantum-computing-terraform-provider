````mermaid
graph TD
  subgraph X[Circuit Exporter]
   X1[Quantum circuit] --> X2[Qiskit Transpiler] 
    
  end
  X --> A
  X --> B
  subgraph A[ ]
    A1[Main Circuit Execution]
    R1[Circuit Deployer/Executor]
    A1 --> R1
    R1 --> A1
    A1 -->|uses| C[Terraform deployment script]
  end
  subgraph B[ ]
    B1[Benchmark Quantum Device executor]
    R2[Benchmark Result Collection/Comparision]
    B1 --> R2
    R2 --> B1
    B1 -->|uses| D[Terraform deployment script]
  end
  B1 --> |Send best quantum computer info| A1
  C -->|implements| E
  D -->|implements| E
  subgraph E[ ]
    F[Terraform custom provider] -->|depends on| H[Cloud provider APIs]
  end

```