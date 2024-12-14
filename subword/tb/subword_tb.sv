
module subword_tb;

//Declare Ports
logic [31:0] word_in;
logic [31:0] word_out;

//instantiate DUT here
subword  subword_inst (
    .word_in(word_in),
    .word_out(word_out)
);

initial begin 
  word_in = 0;
end
initial begin  
  #10;
  word_in = 32'h7f_67_98_af;
  #20;
  $finish();
end
endmodule
