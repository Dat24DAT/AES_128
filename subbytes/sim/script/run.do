vlib work
vlog ../../rtl/subbytes.sv
vlog ../../tb/subbytes_tb.sv
vsim -t 1ps -voptargs="+acc" work.subbytes_tb -wlf subbytes.wlf 
log -r *
run -all