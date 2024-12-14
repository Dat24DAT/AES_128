
module subbytes_tb;

//Declare Ports
logic [127:0] state_in;
logic [127:0] state_out;

//instantiate DUT here
subbytes  subbytes_inst (
    .state_in(state_in),
    .state_out(state_out)
);

initial begin 
  state_in = 0;
end
initial begin  
  #10;
  state_in = 128'h0e_36_34_ae_ce_72_25_b6_f2_6b_17_4e_d9_2b_55_88;
  #20;
  $finish();
end
endmodule
