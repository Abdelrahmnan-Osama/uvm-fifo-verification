package fifo_scoreboard_pkg;
  import uvm_pkg::*;
  import fifo_seq_item_pkg::*;
  `include "uvm_macros.svh"

  class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;

    uvm_analysis_export #(fifo_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(fifo_seq_item) sb_fifo;
    fifo_seq_item sb_seq_item;

    logic [FIFO_WIDTH-1:0] data_out_ref;
    logic [FIFO_WIDTH-1:0] FIFO[$];

    int correct_count, error_count;

    function new(string name = "fifo_scoreboard", uvm_component parent = null);
      super.new(name, parent);
    endfunction  //new()


    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sb_export = new("sb_export", this);
      sb_fifo   = new("sb_fifo", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      sb_export.connect(sb_fifo.analysis_export);
    endfunction

    virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        sb_fifo.get(sb_seq_item);
        ref_model(sb_seq_item);
        if (sb_seq_item.data_out !== data_out_ref) begin
          `uvm_error("run_phase", $sformatf("Comparison failed: %s, data_out_ref = %0d",
                                            sb_seq_item.convert2string(), data_out_ref))
          error_count++;
        end else begin
          `uvm_info("run_phase", $sformatf("Comparison succeeded: %s", sb_seq_item.convert2string()
                    ), UVM_HIGH)
          correct_count++;
        end
      end
    endtask  //

    virtual task ref_model(fifo_seq_item seq_item_chk);
      if (!seq_item_chk.rst_n) begin
        FIFO.delete();
      end else begin
        if (seq_item_chk.rd_en && seq_item_chk.wr_en && FIFO.size() == 0) begin
          FIFO.push_back(seq_item_chk.data_in);
        end else if (seq_item_chk.rd_en && seq_item_chk.wr_en && FIFO.size() == FIFO_DEPTH) begin
          data_out_ref = FIFO.pop_front();
        end else if (seq_item_chk.rd_en && seq_item_chk.wr_en && FIFO.size() < FIFO_DEPTH && FIFO.size() != 0) begin
          FIFO.push_back(seq_item_chk.data_in);
          data_out_ref = FIFO.pop_front();
        end else if (seq_item_chk.wr_en && !seq_item_chk.rd_en && FIFO.size() < FIFO_DEPTH) begin
          FIFO.push_back(seq_item_chk.data_in);
        end else if (seq_item_chk.rd_en && !seq_item_chk.wr_en && FIFO.size() != 0) begin
          data_out_ref = FIFO.pop_front();
        end
      end
    endtask  //

    virtual function void report_phase(uvm_phase phase);
      super.report_phase(phase);
      `uvm_info("report phase", $sformatf("Total successful transactions: %0d", correct_count),
                UVM_MEDIUM)
      `uvm_info("report phase", $sformatf("Total failed transactions: %0d", error_count),
                UVM_MEDIUM)
    endfunction
  endclass  //fifo_scoreboard extends uvm_scoreboard
endpackage
