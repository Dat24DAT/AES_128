vlib work
vlog ../../rtl/addroundkey.sv
vlog ../../tb/addroundkey_tb.sv
vsim -t 1ns -voptargs="+acc" work.addroundkey_tb -wlf addroundkey.wlf 
log -r *
run -all