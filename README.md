README - AXI4-Lite Master/Slave & Top-Level Simulation Project
==============================================================

Project Overview
----------------
This repository contains a SystemVerilog implementation of an AXI4-Lite Master, Slave, and Top-Level module.  
The project includes simulation testbenches, waveform analysis, and documentation to illustrate the operation of the design.  

Folder Structure
----------------
1. src/
   - Contains the source SystemVerilog files:
     * axi_lite_master.sv  – AXI4-Lite Master module
     * axi_lite_slave.sv   – AXI4-Lite Slave module
     * top_axi_lite.sv     – Top-level integration of Master and Slave

2. testbench/
   - Contains the simulation files:
     *-master_slave_tb Testbench for Master + Slave
     * tb_top_axi_lite-Testbench for Top-level module

3. documentation/
   - Contains a Word file with waveform captures and explanations of the simulation results.

Requirements
------------
- Vivado (tested with 2023.1 Vivado version)
- SystemVerilog support

How to Run Simulations
----------------------
1. Open Vivado.
2. Create a new project and add the contents of `src/` and the desired testbench from `testbench/`.
3. Run simulation and view waveforms in Vivado’s simulator.
4. Refer to the `documentation/` folder for waveform explanations.

Notes
-----
- No XDC file is provided, as this project is intended for simulation only.
- Without an XDC file, bitstream generation is not possible.

Author
------
Daniel Ichkovski
