module encryption_128_tb;

// Parameters
localparam integer CLK_PERIOD = 10000, //10ks * 1ps = 10ns
                            N = 128,
                            R = 10; 
//Declare Ports
logic clk;
logic rst_n;
logic [127:0] plain_text;
logic [127:0] key;
logic [127:0] encrypt_text;
logic [$clog2(R)-1:0] round;


//instantiate DUT here
encryption_128 # (
    .N(N),
    .R(R)
  )
  encryption_128_inst (
    .clk(clk),
    .rst_n(rst_n),
    .plain_text(plain_text),
    .key(key),
    .encrypt_text(encrypt_text),
    .round(round)
  );


task intialize_input_values();
  clk = 0;
  // all inputs to zero here
  plain_text = 0;
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
  //give inputs at the negedge of the clock here
  @(negedge clk);
  plain_text = 128'h01_23_45_67_89_ab_cd_ef_fe_dc_ba_98_76_54_32_10;
  key = 128'h0f_15_71_c9_47_d9_e8_59_0c_b7_ad_d6_af_7f_67_98;
  wait_clocks(15);
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
