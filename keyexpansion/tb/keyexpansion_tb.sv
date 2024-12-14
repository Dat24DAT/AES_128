
module keyexpansion_tb;

//Declare Ports
logic [127:0] key;
logic [31:0] rcon;
logic [127:0] key_o;

//instantiate DUT here
keyexpansion  keyexpansion_inst (
    .key(key),
    .rcon(rcon),
    .key_o(key_o)
);
initial begin 
  key = 0;
  rcon = 0;
end
initial begin  
  #10;
  key = 128'h0f_15_71_c9_47_d9_e8_59_0c_b7_ad_d6_af_7f_67_98;
  rcon = 32'h01_00_00_00;
  #10;
  key = 128'h54_68_61_74_73_20_6D_79_20_4B_75_6E_67_20_46_75;
  rcon = 32'h01_00_00_00;
  #10;
  key= 128'h54_73_20_67_68_20_4B_20_61_6D_75_46_74_79_6E_75;
  rcon = 32'h01_00_00_00;
  #20;
  $finish();
end
endmodule
