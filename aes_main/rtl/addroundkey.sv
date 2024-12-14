module addroundkey (
   input logic [127:0] state_in,    //state input
   input logic [127:0] key_in,      //key input
   output logic [127:0] state_out   //state output
);
    assign state_out = state_in ^ key_in;
    
endmodule
