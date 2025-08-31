`timescale 1ns / 1ps
//============================================================
// my_env: UVM Environment
// This environment instantiates an agent and a scoreboard.
// The monitor inside the agent is connected to the scoreboard
// via an analysis port to check DUT outputs against the expected result.
//============================================================

class my_env extends uvm_env;
  `uvm_component_utils(my_env)

  // Components inside the environment
  my_agent      agent;
  my_scoreboard scoreboard;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  //============================================================
  // Build Phase: Create subcomponents
  //============================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent      = my_agent::type_id::create("agent", this);
    scoreboard = my_scoreboard::type_id::create("scoreboard", this);
  endfunction

  //============================================================
  // Connect Phase: Hook monitor's analysis_port to scoreboard
  //============================================================
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.monitor.ap.connect(scoreboard.analysis_export);
  endfunction

endclass : my_env
