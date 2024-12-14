module cipher_round (
   input logic [127:0] cipher_text,
   input logic [127:0] cipher_key,
   output logic [127:0] round_out
);
    logic [127:0] sb_o;
    logic [127:0] sr_o;
    logic [127:0] mc_o;
    logic [127:0] ark_o;
    
    subbytes    s_b  (cipher_text,sb_o);
    shiftrows   s_r  (sb_o,sr_o);
    mixcolumns  m_c  (sr_o,mc_o);
    addroundkey ar_k (mc_o,cipher_key,ark_o);

    assign round_out = ark_o;
endmodule
