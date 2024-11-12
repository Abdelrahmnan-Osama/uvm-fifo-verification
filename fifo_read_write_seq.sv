package fifo_read_write_seq_pkg;
  import uvm_pkg::*;
  import fifo_seq_item_pkg::*;
  `include "uvm_macros.svh"

  class fifo_read_write_seq extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_read_write_seq)

    fifo_seq_item seq_item;

    function new(string name = "fifo_read_write_seq");
      super.new(name);
    endfunction  //new()

    virtual task body();
      repeat (10000) begin
        seq_item = fifo_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        rd_wr_seq_rand : assert (seq_item.randomize());
        finish_item(seq_item);
      end
    endtask  //
  endclass  //fifo_read_write_seq extends uvm_sequence #(fifo_seq_item)
endpackage
