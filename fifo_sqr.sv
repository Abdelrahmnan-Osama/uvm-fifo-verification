package fifo_sqr_pkg;
  import uvm_pkg::*;
  import fifo_seq_item_pkg::*;
  `include "uvm_macros.svh"

  class fifo_sqr extends uvm_sequencer #(fifo_seq_item);
    `uvm_component_utils(fifo_sqr)

    function new(string name = "fifo_sqr", uvm_component parent = null);
      super.new(name, parent);
    endfunction  //new()
  endclass  //fifo_sqr extends uvm_sequencer #()
endpackage
