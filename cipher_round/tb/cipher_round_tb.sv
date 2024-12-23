
module cipher_round_tb;

localparam integer CLK_PERIOD = 10000,
                   N = 128,
                   R = 10;
//Declare Ports
logic clk, rst_n;
logic [N-1:0] plain_text;
logic [N-1:0] cipher_key;
logic [N-1:0] cipher_text;
logic [$clog2(R)-1:0] roundnum;


//instantiate DUT here
cipher_round # (
    .N(N),
    .R(R)
  )
  cipher_round_inst (
    .clk(clk),
    .rst_n(rst_n),
    .plain_text(plain_text),
    .cipher_key(cipher_key),
    .cipher_text(cipher_text),
    .roundnum(roundnum)
  );

  always #(CLK_PERIOD / 2) clk = !clk;

  task intialize_input_values();
  clk = 0;
  // all inputs to zero here
  plain_text = 0;
  cipher_key = 0;
  endtask

  initial begin
    intialize_input_values();
    reset();
    //give inputs at the negedge of the clock here
    @(negedge clk);
    plain_text = 128'h01_23_45_67_89_ab_cd_ef_fe_dc_ba_98_76_54_32_10;
    @(posedge clk);
    cipher_key = 128'h0f_15_71_c9_47_d9_e8_59_0c_b7_ad_d6_af_7f_67_98;//round_0
    @(posedge clk);
    cipher_key = 128'hdc_90_37_b0_9b_49_df_e9_97_fe_72_3f_38_81_15_a7;//round_1
    @(posedge clk);
    cipher_key = 128'hd2_c9_6b_b7_49_80_b4_5e_de_7e_c6_61_e6_ff_d3_c6;//round_2
    @(posedge clk);
    cipher_key = 128'hc0_af_df_39_89_2f_6b_67_57_51_ad_06_b1_ae_7e_c0;//round_3
    @(posedge clk);
    cipher_key = 128'h2c_5c_65_f1_a5_73_0e_96_f2_22_a3_90_43_8c_dd_50;//round_4
    @(posedge clk);
    cipher_key = 128'h58_9d_36_eb_fd_ee_38_7d_0f_cc_9b_ed_4c_40_46_bd;//round_5
    @(posedge clk);
    cipher_key = 128'h71_c7_4c_c2_8c_29_74_bf_83_e5_ef_52_cf_a5_a9_ef;//round_6
    @(posedge clk);
    cipher_key = 128'h37_14_93_48_bb_3d_e7_f7_38_d8_08_a5_f7_7d_a1_4a;//round_7
    @(posedge clk);
    cipher_key = 128'h48_26_45_20_f3_1b_a2_d7_cb_c3_aa_72_3c_be_0b_38;//round_8
    @(posedge clk);
    cipher_key = 128'hfd_0d_42_cb_0e_16_e0_1c_c5_d5_4a_6e_f9_6b_41_56;//round_9
    @(posedge clk);
    cipher_key = 128'hb4_8e_f3_52_ba_98_13_4e_7f_4d_59_20_86_26_18_76;//round_10
    wait_clocks(20);
    $finish();
  end
  ////utility tasks
  task reset();
    rst_n = 0;
    #(3 * CLK_PERIOD);
    rst_n = 1;
    @(negedge clk);
  endtask
  
  task check_outputs(input logic [0:2] outputs, input logic [0:2] expected_outputs);
    @(negedge clk);
    assert (outputs === expected_outputs) begin
      $display("Passed the test case");
    end else $error("Failed. Outputs: %3d Expected Outputs: %3d", outputs, expected_outputs);
  
  endtask
  
  task wait_clocks(input integer num_clocks);
    #(num_clocks * CLK_PERIOD);
  endtask
endmodule
