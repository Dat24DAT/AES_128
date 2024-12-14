
module cipher_round_tb;

//Declare Ports
logic [127:0] cipher_text;
logic [127:0] cipher_key;
logic [127:0] round_out;

//instantiate DUT here
cipher_round  cipher_round_inst (
    .cipher_text(cipher_text),
    .cipher_key(cipher_key),
    .round_out(round_out)
);

initial begin 
  cipher_text = 0;
  cipher_key = 0;
end
initial begin  
  #10;
  // cipher_text = 128'h00_3C_6E_47_1F_4E_22_74_0E_08_1B_31_54_59_0B_1A;
  // cipher_key = 128'hE2_91_B1_D6_32_12_59_79_FC_91_E4_A2_F1_88_E6_93;
  // #10;
  // cipher_text = 128'h581559CD47B6D439081CE2DF8BBAE8CE;
  // cipher_key = 128'h271f6d77150d340ee99cd0ac1814363f;
  #10;
  cipher_text = 128'h0e_36_34_ae_ce_72_25_b6_f2_6b_17_4e_d9_2b_55_88;
  cipher_key = 128'hdc_90_37_b0_9b_49_df_e9_97_fe_72_3f_38_81_15_a7;
  #20;
  $finish();
end
endmodule
