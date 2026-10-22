# 5-Stage-MIPS-Project

# Asynchronous FIFO with Clock Domain Crossing (CDC)

## Overview

Designed and verified a parameterized-concept, 16-entry × 8-bit asynchronous FIFO using Verilog HDL. The design enables data transfer between independent write and read clock domains using Gray-coded pointers, two-stage synchronizers, and full/empty detection logic.

The project focuses on RTL design fundamentals, clock domain crossing (CDC), FIFO pointer management, and functional verification.

## Features

- 16-entry FIFO with 8-bit data width
- Independent write and read clocks
- Binary read/write pointers with an extra wraparound bit
- Gray-code pointer conversion for CDC
- Two-stage synchronizers for cross-domain pointer transfer
- Full and empty flag generation
- Protection against writes when full and reads when empty
- Verilog testbench with directed and randomized testing
- Waveform generation for debugging using GTKWave

## Architecture

The FIFO consists of a dual-clock storage array, independent read and write control logic, pointer-generation logic, and synchronizer chains.

*Conceptual overview; the actual RTL contains separate write- and read-domain synchronizer chains.*

## Design Details

### 1. FIFO Storage

- Depth: 16 entries
- Data width: 8 bits
- Memory declaration: `reg [7:0] mem [0:15];`
- The write pointer selects the memory location for incoming data.
- The read pointer selects the memory location for outgoing data.

### 2. Binary and Gray-Code Pointers

The design uses 5-bit binary pointers: four address bits and one additional wraparound bit.

Binary-to-Gray conversion:

```verilog
assign wgray = wbin ^ (wbin >> 1);
assign rgray = rbin ^ (rbin >> 1);
```

Gray code is used for pointer synchronization because only one bit changes during a single-step pointer increment.

### 3. Clock Domain Crossing

The write pointer is synchronized into the read-clock domain, while the read pointer is synchronized into the write-clock domain.

Each crossing uses a two-stage register synchronizer:

```verilog
always @(posedge rd_clk or negedge rst_n) begin
    if (!rst_n) begin
        wgray_r1 <= 5'b00000;
        wgray_r2 <= 5'b00000;
    end else begin
        wgray_r1 <= wgray;
        wgray_r2 <= wgray_r1;
    end
end
```

A corresponding synchronizer transfers the read pointer into the write-clock domain.

Two-stage synchronizers reduce the probability of metastability propagating into downstream logic. Physical CDC implementation and reset-release behavior require additional validation.

### 4. Empty Detection

The FIFO is empty when the next read pointer matches the synchronized write pointer.

```verilog
assign empty_next = (rgray_next == wgray_r2);
```

### 5. Full Detection

For a power-of-two FIFO, the full condition is detected by comparing the next write Gray pointer against the synchronized read Gray pointer with its two most significant bits inverted.

```verilog
assign full_next =
    (wgray_next == {~rgray_w2[4:3], rgray_w2[2:0]});
```

The extra pointer bit distinguishes the wraparound state, allowing the design to distinguish a full FIFO from an empty FIFO even when both pointers address the same memory location.

## Verification

The design is exercised using a Verilog testbench with directed and randomized transactions.

| Test | Purpose |
|---|---|
| Reset | Verify the initial empty state and deasserted full flag |
| Read while empty | Verify that invalid reads are rejected |
| Fill FIFO | Verify that the FIFO reaches full capacity |
| Write while full | Verify that overflow is prevented |
| Ordered readback | Verify data integrity and FIFO ordering |
| Pointer wraparound | Verify correct pointer behavior across multiple wraps |
| Simultaneous read/write | Exercise concurrent operations in independent clock domains |
| Randomized stress | Exercise varying read/write requests and occupancy levels |

The testbench uses a scoreboard to compare accepted reads against previously accepted writes.

## Tools and Technologies

- **Language:** Verilog HDL
- **Simulation:** Icarus Verilog
- **Waveform Analysis:** GTKWave
- **Synthesis and Timing Analysis:** Xilinx Vivado (planned or to be reported after running the relevant flows)

## Running the Simulation

Place `design.v` and `testbench.v` in the same directory.

### Compile

```bash
iverilog -g2012 -Wall -o fifo_sim design.v testbench.v
```

### Run

```bash
vvp fifo_sim
```

### View waveforms

```bash
gtkwave tb_async_fifo.vcd
```

The testbench should report pass/fail results for the directed and randomized tests. Record the final simulation result after running the current versions of both files.

## Key Learning Outcomes

- Implementing FIFO pointer and storage logic in RTL
- Understanding binary-to-Gray conversion
- Designing two-stage synchronizers for asynchronous clock domains
- Deriving full and empty detection conditions
- Handling independent read and write operations
- Building self-checking testbenches and scoreboards
- Debugging RTL using simulation waveforms

## Future Improvements

- Synthesize the design in Vivado and inspect resource utilization.
- Run static timing analysis with appropriate clock constraints.
- Review CDC reports and synchronizer implementation.
- Verify reset assertion and deassertion across both clock domains.
- Evaluate memory inference and target-specific implementation.
- Expand randomized testing and test additional clock-frequency ratios.

## Project Status

RTL implementation and functional verification are the primary focus. Synthesis, timing, and CDC results should be added once they have been measured and reviewed in the target tool flow.
