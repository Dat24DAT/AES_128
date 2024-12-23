vlib work
vlog ../../rtl/cipher_round.sv

vlog ../../tb/cipher_round_tb.sv
vsim -t 1ps -voptargs="+acc" work.cipher_round_tb -wlf cipher_round.wlf 
log -r *
run -all