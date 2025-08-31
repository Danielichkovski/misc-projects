# README – UVM 8-Bit Adder Testbench

## Project Overview
This repository contains a **SystemVerilog implementation** of a simple 8-bit adder DUT with a full **UVM 1.2 testbench**.  
The testbench drives randomized input pairs to the DUT, monitors outputs, and verifies correctness using a scoreboard.

The project includes:

- Design module (`design.sv`) – contains both the adder DUT and its interface  
- UVM testbench components:
  - `my_transaction.svh` – sequence item class  
  - `my_sequence.svh` – generates randomized inputs  
  - `my_driver.svh` – applies inputs to DUT  
  - `my_monitor.svh` – observes DUT inputs/outputs  
  - `my_scoreboard.svh` – compares DUT output to expected sum  
  - `my_agent.svh` – bundles sequencer, driver, and monitor  
  - `my_env.svh` – environment that instantiates agent and scoreboard  
  - `my_test.svh` – top-level test class  
  - `my_testbench_pkg.svh` – package containing all UVM components  
- Top-level module (`top.sv`) connecting DUT, interface, and UVM testbench

---

## Folder Structure

**src/** – Design Sources  
- `design.sv` – 8-bit adder logic and interface  

**sim/** – Simulation/Testbench Sources  
- `top.sv` – Top module instantiating DUT, interface, and starting UVM test  
- `my_transaction.svh` – Transaction definition  
- `my_sequence.svh` – Generates randomized inputs  
- `my_driver.svh` – Drives inputs to DUT  
- `my_monitor.svh` – Samples DUT inputs/outputs  
- `my_scoreboard.svh` – Compares DUT output to expected sum  
- `my_agent.svh` – Bundles sequencer, driver, and monitor  
- `my_env.svh` – Testbench environment  
- `my_test.svh` – Test that runs the sequence  
- `my_testbench_pkg.svh` – Package containing all UVM classes  

---

## How It Works

1. **Initialization:**  
   The top module instantiates the interface and DUT, sets up the virtual interface in the UVM configuration database, and starts the test.  

2. **Sequence Generation:**  
   `my_sequence` generates 8 randomized input transactions per run.  

3. **Driver:**  
   `my_driver` applies inputs to the DUT.  

4. **Monitoring:**  
   `my_monitor` samples DUT inputs and outputs (with a one-cycle delay to match synchronous behavior) and sends transactions to the scoreboard.  

5. **Scoreboarding:**  
   `my_scoreboard` compares DUT output against the expected sum (`first_num + second_num`) and reports errors via UVM messaging.

---

## Requirements

- **Vivado** (tested with version 2023.1 or newer)  
- **SystemVerilog support**  

---

## How to Run Simulations

1. Open Vivado.  
2. Create a new project and add `design.sv` to **Design Sources**.  
3. Add all files from `sim/` to **Simulation Sources**.  
4. Set `top.sv` as the **Top Module**.  
5. Run **Behavioral Simulation**.  
6. Observe UVM log messages for stimulus, monitoring, and scoreboard checks.  
7. Modify `my_sequence.svh` to test different input patterns if needed.

---

## Notes

- The monitor samples DUT outputs **one cycle after inputs** to match registered behavior.  
- The scoreboard compares the DUT output directly against the sum of inputs.  
- The testbench is primarily for **simulation**; no FPGA constraints are provided.  
- All UVM messages (INFO, WARNING, ERROR) are printed in the simulation transcript.

---

## Author

**Daniel Ichkovski**
