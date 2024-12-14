vlib work
vlog ../../rtl/shiftrows.sv
vlog ../../tb/shiftrows_tb.sv
vsim -t 1ps -voptargs="+acc" work.shiftrows_tb -wlf shiftrows.wlf 
log -r *
run -all