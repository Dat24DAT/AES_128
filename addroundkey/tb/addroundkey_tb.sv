module addroundkey_tb;

//Declare Ports
logic [127:0] state_in;
logic [127:0] key_in;
logic [127:0] state_out;

//instantiate DUT here
addroundkey  addroundkey_inst (
    .state_in(state_in),
    .key_in(key_in),
    .state_out(state_out)
);

initial begin 
  state_in = 0;
  key_in = 0;
end
initial begin  
  #10;
  state_in = 128'hb9_e4_47_c5_94_8e_20_d6_57_16_9a_f5_75_51_3f_3b;
  key_in = 128'hdc_90_37_b0_9b_49_df_e9_97_fe_72_3f_38_81_15_a7;
  #20;
  $finish();
end

endmodule
