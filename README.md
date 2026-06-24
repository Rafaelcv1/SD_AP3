# Group: 05235A-Grupo-E

## Member List

* Frederico Pickler da Silva (18103914)
* Alanis Ferreira Magalhaes (24200518)
* Rafael Costa Vieira (25200391)
* Icaro Lucio de Aquino (26150428)
* Guilherme Candido Barreiros (24100580)


## Description

This Arithmetic Logic Unit (ALU) is designed to process N-bit (32 as generic) data inputs and output the result along with standard status flags.

The multiplication operation is implemented using **Vedic Mathematics**, specifically the **Urdhva Tiryagabhyam** sutra (vertically and crosswise). This method allows for high-speed parallel generation of partial products.

To prevent critical path inflation and maintain a high clock frequency (reducing the clock cycle time), a pipelined stage was introduced using 4 intermediate registers: `RC161`, `RC162`, `RC163`, and `RC164`.


## 📐 Vedic Multiplication Algorithm (2x2 Block Basis)

The cross-multiplication pattern follows this structure:
```text
|  A1  |  A0  |
    \    /
     \  /
      /\
     /  \
|  B1  |  B0  |
```
* Step 1: A0B0;
* Step 2: A1B0;
* Step 3: A0B1;
* Step 4: A1B1.

* P0 = A0B0;
* P1 = A1B0 + A0B1
* P2 = A1B1 + A0B1
* P3 = A1B1 x AOB1 x A1B0

*(Note: These partial products are synchronized through the `RC16x` pipeline registers before final accumulation).*


## 🛠️ Architecture & Datapaths

The hardware architecture is documented inside the `diagrams/` folder, which illustrates the iterative design process:
* **`datapath1.png`**: Main ALU Datapath (Top-Level integration).
* **`datapath2.png` & `datapath3.png`**: Intermediate evolutionary steps of the multiplier logic.
* **`datapath4.png`**: Detailed internal structure of the Vedic Multiplier block with pipeline registers.

### I/O Ports:

* **Data Inputs:** 2 (N-bit)
* **Control Input:** 1 Opcode (3-bit)
* **Data Output:** 1 Result (N-bit)
* **Control Outputs (Flags):** Zero, Overflow

## Operations

| Opcode | Operation |
| :--- | :--- |
| `000` | Bitwise OR |
| `001` | Bitwise AND |
| `010` | Bitwise NOR |
| `011` | Bitwise XOR |
| `100` | Sum |
| `101` | Subtraction |
| `110` | Multiplication |
| `111` | Set on Less Than (SLT) |
