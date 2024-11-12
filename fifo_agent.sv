package fifo_agent_pkg;
  import uvm_pkg::*;
  import fifo_sqr_pkg::*;
  import fifo_config_pkg::*;
  import fifo_driver_pkg::*;
  import fifo_monitor_pkg::*;
  import fifo_seq_item_pkg::*;
  `include "uvm_macros.svh"

  class fifo_agent extends uvm_agent;
    `uvm_component_utils(fifo_agent)

    fifo_sqr sqr;
    fifo_driver drv;
    fifo_monitor mon;
    fifo_config cfg;
    uvm_analysis_port #(fifo_seq_item) agt_ap;

    function new(string name = "fifo_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(fifo_config)::get(this, "", "CFG", cfg)) begin
        `uvm_fatal("build_phase",
                   "Agent - Unable to retreive configuration object of the fifo from uvm_config_db")
      end
      sqr = fifo_sqr::type_id::create("sqr", this);
      drv = fifo_driver::type_id::create("drv", this);
      mon = fifo_monitor::type_id::create("mon", this);
      agt_ap = new("agt_ap", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      drv.fifo_vif = cfg.fifo_vif;
      mon.fifo_vif = cfg.fifo_vif;
      drv.seq_item_port.connect(sqr.seq_item_export);
      mon.mon_ap.connect(agt_ap);
    endfunction
  endclass  //fifo_agent extends uvm_agent
endpackage
