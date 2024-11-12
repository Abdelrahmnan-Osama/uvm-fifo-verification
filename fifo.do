vlib work
vlog -f src_files.list +cover -covercells
vsim +UVM_VERBOSITY=UVM_MEDIUM +UVM_NO_RELNOTES -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover

run 0

add wave -position insertpoint  \
sim:/top/fif/clk \
sim:/top/fif/rst_n \
sim:/top/fif/wr_en \
sim:/top/fif/rd_en \
sim:/top/fif/data_in \
sim:/top/fif/data_out \
{sim:/uvm_root/uvm_test_top/\env.agt /sb/data_out_ref} \
sim:/top/fif/wr_ack \
sim:/top/fif/empty \
sim:/top/fif/full \
sim:/top/fif/almostempty \
sim:/top/fif/almostfull \
sim:/top/fif/overflow \
sim:/top/fif/underflow 

add wave -position insertpoint  \
sim:/top/fif/count \
sim:/top/fif/rd_ptr \
sim:/top/fif/wr_ptr

add wave -position insertpoint  \
sim:/top/DUT/mem

add wave /top/DUT/fifo_sva_inst/wr_ptr_inc_assertion \
/top/DUT/fifo_sva_inst/rd_ptr_inc_assertion \
/top/DUT/fifo_sva_inst/wr_ptr_const_assertion \
/top/DUT/fifo_sva_inst/rd_ptr_const_assertion \
/top/DUT/fifo_sva_inst/counter_dec_assertion \
/top/DUT/fifo_sva_inst/counter_inc_assertion \
/top/DUT/fifo_sva_inst/wr_ack_assertion \
/top/DUT/fifo_sva_inst/overflow_assertion \
/top/DUT/fifo_sva_inst/underflow_assertion \
/top/DUT/fifo_sva_inst/counter_const_assertion \
/top/DUT/fifo_sva_inst/immediate_assertions/full_assertion \
/top/DUT/fifo_sva_inst/immediate_assertions/empty_assertion \
/top/DUT/fifo_sva_inst/immediate_assertions/almostfull_assertion \
/top/DUT/fifo_sva_inst/immediate_assertions/almostempty_assertion \
/top/DUT/fifo_sva_inst/immediate_assertions/reset_assertion

coverage exclude -src FIFO.sv -line 25 -code c

coverage save fifo.ucdb -onexit
run -all
vcover report fifo.ucdb -details -annotate -all -output coverage_rpt.txt