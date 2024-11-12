////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO (
    fifo_if.DUT fif
);

  reg [fif.FIFO_WIDTH-1:0] mem[fif.FIFO_DEPTH-1:0];

  always @(posedge fif.clk or negedge fif.rst_n) begin
    if (!fif.rst_n) begin
      fif.wr_ptr   <= 0;
      fif.wr_ack   <= 0;
      fif.overflow <= 0;
    end else if (fif.wr_en && fif.count < fif.FIFO_DEPTH) begin
      mem[fif.wr_ptr] <= fif.data_in;
      fif.wr_ack <= 1;
      fif.wr_ptr <= fif.wr_ptr + 1;
    end else begin
      fif.wr_ack <= 0;
      if (fif.full & fif.wr_en) fif.overflow <= 1;
      else fif.overflow <= 0;
    end
  end

  always @(posedge fif.clk or negedge fif.rst_n) begin
    if (!fif.rst_n) begin
      fif.rd_ptr <= 0;
    end else if (fif.rd_en && fif.count != 0) begin
      fif.data_out <= mem[fif.rd_ptr];
      fif.rd_ptr   <= fif.rd_ptr + 1;
    end
  end

  always @(posedge fif.clk or negedge fif.rst_n) begin
    if (!fif.rst_n) begin
      fif.underflow <= 0;
    end else if (fif.empty && fif.rd_en) begin
      fif.underflow <= 1;
    end else begin
      fif.underflow <= 0;
    end
  end

  always @(posedge fif.clk or negedge fif.rst_n) begin
    if (!fif.rst_n) begin
      fif.count <= 0;
    end else begin
      if (fif.wr_en && fif.rd_en && fif.empty) fif.count <= fif.count + 1;
      else if (fif.wr_en && fif.rd_en && fif.full) fif.count <= fif.count - 1;
      else if (fif.wr_en && !fif.rd_en && !fif.full) fif.count <= fif.count + 1;
      else if (fif.rd_en && !fif.wr_en && !fif.empty) fif.count <= fif.count - 1;
    end
  end

  assign fif.full = (fif.count == fif.FIFO_DEPTH) ? 1 : 0;
  assign fif.empty = (fif.count == 0) ? 1 : 0;
  assign fif.almostfull = (fif.count == fif.FIFO_DEPTH - 1) ? 1 : 0;
  assign fif.almostempty = (fif.count == 1) ? 1 : 0;

endmodule
