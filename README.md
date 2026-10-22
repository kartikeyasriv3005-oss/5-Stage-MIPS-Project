# 5-Stage-MIPS-Project

5-Stage Pipelined MIPS Processor in Verilog
A modular implementation of a 32-bit, 5-stage pipelined MIPS-style processor using Verilog HDL. The project is organized into separate RTL modules for the processor datapath, pipeline registers, control logic, forwarding, and hazard handling, making the design easier to understand, simulate, and extend.
Overview
The processor follows the classic five-stage pipeline:
Stage |	Name |	Main responsibility
IF	Instruction Fetch	Fetch the instruction using the program counter (PC)
ID	Instruction Decode	Decode the instruction and read source registers
EX	Execute	Perform ALU operations and calculate effective addresses
MEM	Memory Access	Read from or write to data memory
WB	Write Back	Write the result back to the register file


Pipeline registers separate adjacent stages so multiple instructions can be in flight simultaneously.
Architecture
                 ┌──────────────┐
                 │ Program      │
                 │ Counter (PC) │
                 └──────┬───────┘
                        ▼
              ┌──────────────────┐
              │ IF: Instruction   │
              │ Fetch + Instr Mem │
              └────────┬─────────┘
                       ▼
                 ┌───────────┐
                 │  IF/ID    │
                 └─────┬─────┘
                       ▼
              ┌──────────────────┐
              │ ID: Decode +     │
              │ Register File    │
              └────────┬─────────┘
                       ▼
                 ┌───────────┐
                 │  ID/EX    │
                 └─────┬─────┘
                       ▼
              ┌──────────────────┐
              │ EX: ALU +        │
              │ Forwarding Muxes │
              └────────┬─────────┘
                       ▼
                 ┌───────────┐
                 │  EX/MEM   │
                 └─────┬─────┘
                       ▼
              ┌──────────────────┐
              │ MEM: Data Memory  │
              └────────┬─────────┘
                       ▼
                 ┌───────────┐
                 │  MEM/WB   │
                 └─────┬─────┘
                       ▼
              ┌──────────────────┐
              │ WB: Register File │
              │ Write Back        │
              └──────────────────┘
Features and design goals
- 32-bit datapath.
- Classic IF, ID, EX, MEM, and WB pipeline stages.
- Modular RTL design with separate datapath and control modules.
- ALU and adder modules.
- Register file, instruction memory, and data memory.
- Pipeline registers between stages.
- Forwarding logic to handle supported data dependencies.
- Hazard detection logic intended to manage pipeline stalls and bubbles.
- Multiplexer modules for datapath selection.
- Designed for simulation and synthesis exploration in Xilinx Vivado.
Implementation note: Confirm the supported instruction subset, branch/jump behavior, reset semantics, forwarding cases, and load-use stall behavior against the current RTL and testbenches before describing them as fully verified.

Repository structure
MIPS Project/
├── adder.v
├── ALU.v
├── control_unit.v
├── data_memory.v
├── ex_mem.v
├── forwarding.v
├── hazard_unit.v
├── id_ex.v
├── if_id.v
├── instr_mem.v
├── mem_wb.v
├── PC.v
├── reg_file.v
├── three_ip_mux_32_bit.v
├── top.v
└── two_ip_mux.v
Module responsibilities
File	Purpose
top.v	Top-level integration of processor components
PC.v	Program counter / instruction address state
instr_mem.v	Instruction storage and fetch interface
reg_file.v	Register-file read and write operations
control_unit.v	Instruction decoding and control-signal generation
ALU.v	Arithmetic and logical operations
adder.v	Addition logic used by the datapath
data_memory.v	Data-memory read and write interface
if_id.v	IF/ID pipeline register
id_ex.v	ID/EX pipeline register
ex_mem.v	EX/MEM pipeline register
mem_wb.v	MEM/WB pipeline register
forwarding.v	Forwarding control for dependent instructions
hazard_unit.v	Hazard detection and pipeline stall/bubble control
two_ip_mux.v	2-to-1, 32-bit datapath multiplexer
three_ip_mux_32_bit.v	3-to-1, 32-bit datapath multiplexer


Check the module declarations and signal connections in the source files for the exact interfaces and behavior.
Pipeline hazards
Data hazards and forwarding
A data hazard occurs when an instruction needs a value produced by an earlier instruction that has not yet been written back to the register file. Forwarding can route a result from a later pipeline stage directly to an ALU input, avoiding some stalls.

Example dependency:
add $t0, $t1, $t2
sub $t3, $t0, $t4
The sub instruction depends on the result of add. With a suitable forwarding path, the result can be supplied without waiting for register write-back.
Load-use hazards
A load instruction obtains its data during the MEM stage, later than an arithmetic instruction obtains its ALU result. A directly dependent instruction may therefore require a stall even when forwarding is implemented.

Example:
lw  $t0, 0($t1)
add $t2, $t0, $t3
The hazard unit should detect the dependency, hold the appropriate front-end pipeline state, and insert a bubble when required. Verify the exact behavior in simulation.
Tools
- HDL: Verilog
- Design and simulation: Xilinx Vivado
- Version control: Git and GitHub
Optional command-line simulation may be performed with Icarus Verilog if the source files use compatible Verilog constructs.
Running the project in Vivado
1. Open Xilinx Vivado and create or open an RTL project.
2. Add the processor .v files as Design Sources.
3. Set top.v as the top module, assuming it contains the top-level processor module.
4. Add your testbench files as Simulation Sources.
5. Run Behavioral Simulation.
6. Inspect the waveform for the PC, fetched instruction, pipeline registers, ALU result, memory controls, forwarding selections, stall signals, and register-file write-back.
7. Run Synthesis after simulation, then review warnings and utilization reports.
8. If targeting an FPGA board, add the appropriate constraints and verify the design's clocking and I/O before implementation.
Suggested verification checklist
- [ ] Reset initializes the processor to the expected state.
- [ ] PC advances correctly when the pipeline is not stalled.
- [ ] Instructions are fetched from the expected addresses.
- [ ] ALU operations produce the expected results.
- [ ] Register-file reads and writes behave correctly; register zero remains zero if required by the ISA subset.
- [ ] Load and store instructions access the correct addresses.
- [ ] Back-to-back dependent arithmetic instructions are tested.
- [ ] EX/MEM and MEM/WB forwarding cases are tested.
- [ ] Load-use dependencies produce the expected stall and bubble.
- [ ] Branches and jumps are tested, including flushing if implemented.
- [ ] Testbenches check expected results automatically.
- [ ] Synthesis completes without unexplained warnings.
Future improvements
- Add more instructions and document the exact supported ISA subset.
- Expand directed and randomized self-checking testbenches.
- Add branch prediction or other control-hazard improvements.
- Measure timing and resource utilization in Vivado.
- Add a program-loading mechanism and a documented example program.
