package fifo_seq_item_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class fifo_seq_item extends uvm_sequence_item;
    `uvm_object_utils(fifo_seq_item)

    parameter FIFO_WIDTH = 16;

    rand bit [FIFO_WIDTH-1:0] data_in;
    rand bit rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;

    int RD_EN_ON_DIST, WR_EN_ON_DIST;

    function new(string name = "fifo_seq_item", int RD_EN_ON_DIST = 30, int WR_EN_ON_DIST = 70);
      this.RD_EN_ON_DIST = RD_EN_ON_DIST;
      this.WR_EN_ON_DIST = WR_EN_ON_DIST;
    endfunction  //new()

    virtual function string convert2string();
      return $sformatf(
          "%s rst_n = %b, wr_en = %b, rd_en = %b, data_in = %0d, data_out = %0d",
          super.convert2string(),
          rst_n,
          wr_en,
          rd_en,
          data_in,
          data_out
      );

    endfunction

    virtual function string convert2string_stimulus();
      return $sformatf("rst_n = %b, wr_en = %b, rd_en = %b, data_in = %0d", rst_n, wr_en, rd_en,
                       data_in);

    endfunction

    constraint reset_c {
      rst_n dist {
        0 := 2,
        1 := 98
      };
    }

    constraint write_enable_c {
      soft wr_en dist {
        1 := WR_EN_ON_DIST,
        0 := 100 - WR_EN_ON_DIST
      };
    }

    constraint read_enable_c {
      soft rd_en dist {
        1 := RD_EN_ON_DIST,
        0 := 100 - RD_EN_ON_DIST
      };
    }
  endclass  //fifo_seq_item extends uvm_sequence_item
endpackage
