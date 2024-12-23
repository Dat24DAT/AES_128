
module keyexpansion_tb;

//parameter
localparam integer CLK_PERIOD = 10000,
                   R = 10,
                   N = 128;

//Declare Ports
logic clk;
logic rst_n;
logic [N-1:0] key_i;
logic [N-1:0] key_o;
logic [$clog2(R)-1:0] roundnum;
                 

//instantiate DUT here
keyexpansion # (
    .R(R),
    .N(N)
  )
  keyexpansion_inst (
    .clk(clk),
    .rst_n(rst_n),
    .key_i(key_i),
    .key_o(key_o),
    .roundnum(roundnum)
  );

  always #(CLK_PERIOD / 2) clk = !clk;

  task intialize_input_values();
  clk = 0;
  // all inputs to zero here
  key_i = 0;
  endtask

  initial begin
    intialize_input_values();
    reset();
    //give inputs at the negedge of the clock here
    @(negedge clk);
    key_i = 128'h0f_15_71_c9_47_d9_e8_59_0c_b7_ad_d6_af_7f_67_98;
    wait_clocks(12);
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
