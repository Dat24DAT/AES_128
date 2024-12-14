vlib work
vlog ../../rtl/rotationword.sv
vlog ../../tb/rotationword_tb.sv
vsim -t 1ps -voptargs="+acc" work.rotationword_tb -wlf rotationword.wlf 
log -r *
run -all