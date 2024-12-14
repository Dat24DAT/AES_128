vlib work
vlog ../../rtl/cipher_round.sv
vlog ../../rtl/subbytes.sv
vlog ../../rtl/shiftrows.sv
vlog ../../rtl/mixcolumns.sv
vlog ../../rtl/addroundkey.sv
vlog ../../tb/cipher_round_tb.sv
vsim -t 1ps -voptargs="+acc" work.cipher_round_tb -wlf cipher_round.wlf 
log -r *
run -all