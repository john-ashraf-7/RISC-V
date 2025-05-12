# RISC-V Pipelined Processor Simulator

<img src="Block Diagram/RISC-V-Pipeline-Diagram.jpg" alt="RISC-V Pipeline Diagram">

A Verilog-based 32-bit pipelined RISC-V processor simulator, developed as a team project between March and May 2025. This project implements the **RV32IM** instruction set architecture, supporting 46 RISC-V instructions with accurate pipeline behavior, hazard management, and forwarding.

---

## 🛠️ Features

- **RV32IM Instruction Set Support**  
  - Base **RV32I** instructions  
  - Extended **RV32M** instructions (e.g., `MUL`, `DIV`, etc.)

- **Single-Cycle and Pipelined Implementations**  
  - Began with a working single-cycle processor  
  - Extended to a 5-stage pipelined architecture:
    - IF (Instruction Fetch)
    - ID (Instruction Decode)
    - EX (Execute)
    - MEM (Memory Access)
    - WB (Write Back)

- **Pipeline Enhancements**
  - **Data forwarding unit** to reduce stalls  
  - **Hazard detection unit** to handle load-use and control hazards  
  - Correct instruction flow with **stalling** and **bubbling** logic

- **Verilog Implementation**
  - Modular design  
  - Simulated using testbenches and validated with diverse RISC-V assembly programs

---

## ✅ Validation and Testing

- Verified using custom RISC-V assembly test programs  
- Covered all 46 supported instructions  
- Manually inspected waveform outputs for pipeline stage behavior  
- Rigorous unit and integration testing to ensure correctness and efficiency

---

## 👨‍💻 Team

Developed by a team of three Computer Engineering students as part of a Computer Architecture course project.

---

## 📅 Timeline

- **March 2025**: Single-cycle RV32I completed  
- **April 2025**: Pipeline structure, hazard detection, and forwarding implemented  
- **May 2025**: RV32M extension, debugging, and validation

---

## 📜 License

This project is for educational purposes and is not licensed for commercial use.
