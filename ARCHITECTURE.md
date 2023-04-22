````mermaid
graph TD
  X --> A1
  X --> B1
  subgraph A
    A1[Process A]
    R1[Wait for result]
    A1 --> R1
    R1 --> A1
  end
  subgraph B
    B1[Process B]
    R2[Wait for result]
    B1 --> R2
    R2 --> B1
  end
  A1 -->|uses| C
  B1 -->|uses| D
  C -->|implements| E
  D -->|implements| E
  B1 --> |signals value| A1
  subgraph E
    F --> H
  end
```