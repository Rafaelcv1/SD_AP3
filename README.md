# Group: 05235A-Grupo-E

## Member List

* Frederico Pickler da Silva (18103914)
* Alanis Ferreira Magalhaes (24200518)
* Rafael Costa Vieira (25200391)
* Icaro Lucio de Aquino (26150428)

## Description

This Arithmetic Logic Unit (ALU) is designed to process N-bit (32 as generic) data inputs and output the result along with standard status flags.

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
