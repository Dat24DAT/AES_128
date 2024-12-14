vlib work
vlog ../../rtl/mixcolumns.sv
vlog ../../tb/mixcolumns_tb.sv
vsim -t 1ps -voptargs="+acc" work.mixcolumns_tb -wlf mixcolumns.wlf 
log -r *
run -all