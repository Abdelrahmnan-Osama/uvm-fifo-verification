package fifo_test_pkg;
  import uvm_pkg::*;
  import fifo_env_pkg::*;
  import fifo_config_pkg::*;
  import fifo_reset_seq_pkg::*;
  import fifo_read_only_seq_pkg::*;
  import fifo_write_only_seq_pkg::*;
  import fifo_read_write_seq_pkg::*;
  `include "uvm_macros.svh"

  class fifo_test extends uvm_test;
    `uvm_component_utils(fifo_test)

    fifo_env env;
    fifo_config fifo_cfg;
    fifo_reset_seq rst_seq;
    fifo_read_only_seq rd_seq;
    fifo_write_only_seq wr_seq;
    fifo_read_write_seq rd_wr_seq;

    function new(string name = "fifo_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction  //new()
    
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      // Disable transaction recording
      uvm_config_db#(int)::set(null, "", "recording_detail", 0);
      uvm_config_db#(uvm_bitstream_t)::set(null, "", "recording_detail", 0);

      env = fifo_env::type_id::create("env.agt", this);
      fifo_cfg = fifo_config::type_id::create("fifo_cfg");
      rst_seq = fifo_reset_seq::type_id::create("rst_seq", this);
      rd_seq = fifo_read_only_seq::type_id::create("rd_seq", this);
      wr_seq = fifo_write_only_seq::type_id::create("wr_seq", this);
      rd_wr_seq = fifo_read_write_seq::type_id::create("rd_wr_seq", this);

      if (!uvm_config_db#(virtual fifo_if)::get(this, "", "FIFO_IF", fifo_cfg.fifo_vif)) begin
        `uvm_fatal("build_phase",
                   "Test - Unable to retreive interface of the fifo from uvm_config_db")
      end
      uvm_config_db#(fifo_config)::set(this, "*", "CFG", fifo_cfg);
    endfunction

    virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);

      phase.raise_objection(this);
      `uvm_info("run_phase", "Reset Asserted", UVM_LOW)
      rst_seq.start(env.agt.sqr);
      `uvm_info("run_phase", "Reset Deasserted", UVM_LOW)

      `uvm_info("run_phase", "Write Only Sequence Started", UVM_LOW)
      wr_seq.start(env.agt.sqr);
      `uvm_info("run_phase", "Write Only Sequence Ended", UVM_LOW)

      `uvm_info("run_phase", "Read Only Sequence started", UVM_LOW)
      rd_seq.start(env.agt.sqr);
      `uvm_info("run_phase", "Read Only Sequence Ended", UVM_LOW)

      `uvm_info("run_phase", "Read Write Sequence Started", UVM_LOW)
      rd_wr_seq.start(env.agt.sqr);
      `uvm_info("run_phase", "Read Write Sequence Ended", UVM_LOW)
      phase.drop_objection(this);

    endtask

  endclass  //fifo_test extends uvm_test
endpackage
