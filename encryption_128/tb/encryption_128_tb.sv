module encryption_128_tb;

// Parameters
localparam integer CLK_PERIOD = 10000; //10ks * 1ps = 10ns
//Declare Ports
logic [127:0] plaintext;
logic [127:0] key;
logic clk;
logic rst_n;
logic [127:0] encrypt_text;

//instantiate DUT here
encryption_128  encryption_128_inst (
  .plaintext(plaintext),
  .key(key),
  .clk(clk),
  .rst_n(rst_n),
  .encrypt_text(encrypt_text)
);


task intialize_input_values();
  clk = 0;
  // all inputs to zero here
  plaintext = 0;
  key = 0;
endtask

//utility tasks
task reset();
  rst_n = 0;
  #(3 * CLK_PERIOD);
  rst_n = 1;
  @(negedge clk);
endtask

always #(CLK_PERIOD / 2) clk = !clk;
  
initial begin
  intialize_input_values();
  reset();
  wait_clocks(1);
  @(negedge clk);
  plaintext = 128'h01_23_45_67_89_ab_cd_ef_fe_dc_ba_98_76_54_32_10;
  key = 128'h0f_15_71_c9_47_d9_e8_59_0c_b7_ad_d6_af_7f_67_98;
  wait_clocks(2);
  @(negedge clk);
  plaintext=128'h32_43_f6_a8_88_5a_30_8d_31_31_98_a2_e0_37_07_34;
  key=128'h2b_7e_15_16_28_ae_d2_a6_ab_f7_15_88_09_cf_4f_3c;
  wait_clocks(2);
  wait_clocks(10);
  $finish();
end

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
