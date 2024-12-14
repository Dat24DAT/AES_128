
module shiftrows_tb;

//Declare Ports
logic [127:0] state_in;
logic [127:0] state_out;

//instantiate DUT here
shiftrows  shiftrows_inst (
  .state_in(state_in),
  .state_out(state_out)
);
initial begin 
  state_in = 0;
end
initial begin  
  #10;
  state_in = 128'hab_05_18_e4_8b_40_3f_4e_89_7f_f0_2f_35_f1_fc_c4;
  #20;
  $finish();
end
endmodule
