module fifo_sva (
    fifo_if.DUT fif
);
  property p_write_pointer_inc;
    @(posedge fif.clk) disable iff (!fif.rst_n) fif.wr_en && !fif.rd_en && !fif.full || fif.wr_en && fif.rd_en && fif.empty |=> fif.wr_ptr == $past(
        fif.wr_ptr
    ) + 1'b1;
  endproperty

  property p_read_pointer_inc;
    @(posedge fif.clk) disable iff (!fif.rst_n) !fif.wr_en && fif.rd_en && !fif.empty || fif.wr_en && fif.rd_en && fif.full |=> fif.rd_ptr == $past(
        fif.rd_ptr
    ) + 1'b1;
  endproperty

  property p_write_pointer_const;
    @(posedge fif.clk) disable iff (!fif.rst_n) fif.wr_en && fif.rd_en && fif.full |=> fif.wr_ptr == $past(
        fif.wr_ptr
    );
  endproperty

  property p_read_pointer_const;
    @(posedge fif.clk) disable iff (!fif.rst_n) fif.wr_en && fif.rd_en && fif.empty |=> fif.rd_ptr == $past(
        fif.rd_ptr
    );
  endproperty

  property p_counter_inc;
    @(posedge fif.clk) disable iff (!fif.rst_n) fif.wr_en && !fif.rd_en && !fif.full || fif.wr_en && fif.rd_en && fif.empty  |=> fif.count == $past(
        fif.count
    ) + 1'b1;
  endproperty

  property p_counter_dec;
    @(posedge fif.clk) disable iff (!fif.rst_n) !fif.wr_en && fif.rd_en && !fif.empty || fif.wr_en && fif.rd_en && fif.full |=> fif.count == $past(
        fif.count
    ) - 1'b1;
  endproperty

  property p_counter_const;
    @(posedge fif.clk) disable iff (!fif.rst_n) fif.wr_en && fif.rd_en && !fif.empty && !fif.full |=> fif.count == $past(
        fif.count
    );
  endproperty

  property p_wr_ack;
    @(posedge fif.clk) disable iff (!fif.rst_n) fif.wr_en && !fif.full |=> fif.wr_ack;
  endproperty

  property p_overflow;
    @(posedge fif.clk) disable iff (!fif.rst_n) fif.full && fif.wr_en |=> fif.overflow;
  endproperty

  property p_underflow;
    @(posedge fif.clk) disable iff (!fif.rst_n) fif.empty && fif.rd_en |=> fif.underflow;
  endproperty

  // FIFO_10
  wr_ptr_inc_assertion :
  assert property (p_write_pointer_inc);
  cover property (p_write_pointer_inc);

  // FIFO_11
  rd_ptr_inc_assertion :
  assert property (p_read_pointer_inc);
  cover property (p_read_pointer_inc);

  // FIFO_15
  wr_ptr_const_assertion :
  assert property (p_write_pointer_const);
  cover property (p_write_pointer_const);

  // FIFO_16
  rd_ptr_const_assertion :
  assert property (p_read_pointer_const);
  cover property (p_read_pointer_const);

  // FIFO_13
  counter_dec_assertion :
  assert property (p_counter_dec);
  cover property (p_counter_dec);

  // FIFO_12  
  counter_inc_assertion :
  assert property (p_counter_inc);
  cover property (p_counter_inc);

  // FIFO_2
  wr_ack_assertion :
  assert property (p_wr_ack);
  cover property (p_wr_ack);

  // FIFO_3
  overflow_assertion :
  assert property (p_overflow);
  cover property (p_overflow);

  // FIFO_6
  underflow_assertion :
  assert property (p_underflow);
  cover property (p_underflow);

  // FIFO_14
  counter_const_assertion :
  assert property (p_counter_const);
  cover property (p_counter_const);


  always_comb begin : immediate_assertions
    // FIFO_9
    if (fif.count == fif.FIFO_DEPTH) begin
      full_assertion : assert final (fif.full);
    end
    // FIFO_8
    if (fif.count == 0) begin
      empty_assertion : assert final (fif.empty);
    end
    // FIFO_4
    if (fif.count == fif.FIFO_DEPTH - 1) begin
      almostfull_assertion : assert final (fif.almostfull);
    end
    // FIFO_7
    if (fif.count == 1) begin
      almostempty_assertion : assert final (fif.almostempty);
    end
    // FIFO_1
    if (!fif.rst_n) begin
      reset_assertion :
      assert final (fif.count == 0 && fif.wr_ptr == 0 && fif.rd_ptr == 0 && !fif.overflow && !fif.underflow && 
                    fif.empty && !fif.full && !fif.almostempty && !fif.almostfull && !fif.wr_ack);
    end
  end
endmodule
