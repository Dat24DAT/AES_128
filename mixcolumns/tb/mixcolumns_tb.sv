
module mixcolumns_tb;

//Declare Ports
logic [127:0] state_in;
logic [127:0] state_out;

//instantiate DUT here
mixcolumns  mixcolumns_inst (
  .state_in(state_in),
  .state_out(state_out)
);
initial begin 
  state_in = 0;
end
initial begin  
  #10;
  state_in = 128'hab_40_f0_c4_8b_7f_fc_e4_89_f1_18_4e_35_05_3f_2f;
  #20;
  $finish();
end
endmodule
