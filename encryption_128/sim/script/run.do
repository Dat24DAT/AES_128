vlib work
vlog ../../rtl/cipher_round.sv
vlog ../../rtl/keyexpansion.sv
vlog ../../rtl/encryption_128.sv


vlog ../../tb/encryption_128_tb.sv
vsim -t 1ps -voptargs="+acc" work.encryption_128_tb -wlf encryption_128.wlf 
log -r *
run -all