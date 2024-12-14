vlib work
vlog ../../rtl/keyexpansion.sv
vlog ../../rtl/subword.sv
vlog ../../rtl/rotationword.sv
vlog ../../tb/keyexpansion_tb.sv
vsim -t 1ps -voptargs="+acc" work.keyexpansion_tb -wlf keyexpansion.wlf 
log -r *
run -all