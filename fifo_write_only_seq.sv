package fifo_write_only_seq_pkg;
  import uvm_pkg::*;
  import fifo_seq_item_pkg::*;
  `include "uvm_macros.svh"

  class fifo_write_only_seq extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_write_only_seq)

    fifo_seq_item seq_item;

    function new(string name = "fifo_write_only_seq");
      super.new(name);
    endfunction  //new()

    virtual task body();
      repeat (10000) begin
        seq_item = fifo_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        wr_seq_rand : assert (seq_item.randomize() with {rd_en == 0;});
        finish_item(seq_item);
      end
    endtask  //
  endclass  //fifo_write_only_seq extends uvm_sequence #(fifo_seq_item)
endpackage