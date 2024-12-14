vlib work
vlog ../../rtl/subword.sv
vlog ../../tb/subword_tb.sv
vsim -t 1ps -voptargs="+acc" work.subword_tb -wlf subword.wlf 
log -r *
run -all