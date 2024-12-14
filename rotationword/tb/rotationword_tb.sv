
module rotationword_tb;

//Declare Ports
logic [31:0] word_in;
logic [31:0] word_out;
//instantiate DUT here
rotationword  rotationword_inst (
    .word_in(word_in),
    .word_out(word_out)
);
initial begin 
  word_in = 0;
end
initial begin  
  #10;
  word_in = 32'haf_7f_67_98;
  #20;
  $finish();
end
endmodule
