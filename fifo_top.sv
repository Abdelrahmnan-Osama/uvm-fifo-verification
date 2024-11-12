import uvm_pkg::*;
import fifo_test_pkg::*;
`include "uvm_macros.svh"

module top ();
  bit clk;

  initial begin
    forever begin
      #20 clk = ~clk;
    end
  end

  fifo_if fif (clk);
  FIFO DUT (fif);
  bind FIFO fifo_sva fifo_sva_inst (fif);

  initial begin
    uvm_config_db#(virtual fifo_if)::set(null, "uvm_test_top", "FIFO_IF", fif);
    run_test("fifo_test");
  end
endmodule
