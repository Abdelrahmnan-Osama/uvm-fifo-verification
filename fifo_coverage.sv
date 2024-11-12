package fifo_coverage_pkg;
  import uvm_pkg::*;
  import fifo_seq_item_pkg::*;
  `include "uvm_macros.svh"

  class fifo_coverage extends uvm_component;
    `uvm_component_utils(fifo_coverage)

    uvm_analysis_export #(fifo_seq_item) cov_export;
    uvm_tlm_analysis_fifo #(fifo_seq_item) cov_fifo;
    fifo_seq_item cov_seq_item;

    covergroup CovCode;
      option.per_instance = 1;
      rd_en: coverpoint cov_seq_item.rd_en {option.weight = 0;}
      wr_en: coverpoint cov_seq_item.wr_en {option.weight = 0;}
      full: coverpoint cov_seq_item.full {option.weight = 0;}
      overflow: coverpoint cov_seq_item.overflow {option.weight = 0;}
      underflow: coverpoint cov_seq_item.underflow {option.weight = 0;}
      wr_ack: coverpoint cov_seq_item.wr_ack {option.weight = 0;}

      // FIFO_9
      rd_wr_full: cross rd_en, wr_en, full{
        ignore_bins rd1wr1full1 = binsof(rd_en) intersect {1} &&
                                  binsof(wr_en) intersect {1} &&
                                  binsof(full) intersect {
          1
        };
        ignore_bins rd1wr0full1 = binsof(rd_en) intersect {1} &&
                                  binsof(wr_en) intersect {0} &&
                                  binsof(full) intersect {
          1
        };
      }
      // FIFO_4
      rd_wr_almostfull: cross rd_en, wr_en, cov_seq_item.almostfull;
      // FIFO_8
      rd_wr_empty: cross rd_en, wr_en, cov_seq_item.empty;
      // FIFO_7
      rd_wr_almostempty: cross rd_en, wr_en, cov_seq_item.almostempty;
      // FIFO_3
      rd_wr_overflow: cross rd_en, wr_en, overflow{
        ignore_bins rd1wr0over1 = binsof(rd_en) intersect {1} &&
                                  binsof(wr_en) intersect {0} &&
                                  binsof(overflow) intersect {
          1
        };
        ignore_bins rd0wr0over1 = binsof(rd_en) intersect {0} &&
                                  binsof(wr_en) intersect {0} &&
                                  binsof(overflow) intersect {
          1
        };
      }
      // FIFO_6
      rd_wr_underflow: cross rd_en, wr_en, underflow{
        ignore_bins rd0wr1under1 = binsof(rd_en) intersect {0} &&
                                  binsof(wr_en) intersect {1} &&
                                  binsof(underflow) intersect {
          1
        };
        ignore_bins rd0wr0under1 = binsof(rd_en) intersect {0} &&
                                  binsof(wr_en) intersect {0} &&
                                  binsof(underflow) intersect {
          1
        };
      }
      // FIFO_2
      rd_wr_wr_ack: cross rd_en, wr_en, wr_ack{
        ignore_bins rd1wr0ack1 = binsof(rd_en) intersect {1} &&
                                  binsof(wr_en) intersect {0} &&
                                  binsof(wr_ack) intersect {
          1
        };
        ignore_bins rd0wr0ack1 = binsof(rd_en) intersect {0} &&
                                  binsof(wr_en) intersect {0} &&
                                  binsof(wr_ack) intersect {
          1
        };
      }
    endgroup

    function new(string name = "fifo_coverage", uvm_component parent = null);
      super.new(name, parent);
      CovCode = new();
    endfunction  //new()

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      cov_export = new("cov_export", this);
      cov_fifo   = new("cov_fifo", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      cov_export.connect(cov_fifo.analysis_export);
    endfunction

    virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        cov_fifo.get(cov_seq_item);
        CovCode.sample();
      end
    endtask  //
  endclass  //fifo_coverage extends uvm_component
endpackage
