module encryption_128 (
    input logic clk,
    input logic rst_n,
    input logic [127:0] plaintext,
    input logic [127:0] key,
    output logic [127:0] encrypt_text
);
    logic [127:0] before_cipher;
    logic [127:0] k1o,k2o,k3o,k4o,k5o,k6o,k7o,k8o,k9o,k10o; //keyex output
    logic [127:0] txt1o,txt2o,txt3o,txt4o,txt5o,
                  txt6o,txt7o,txt8o,txt9o;
    logic [127:0] sb_o,sr_o;
    //Before cipher
    addroundkey add_first_time(plaintext,key,before_cipher); 
    //Cipher
    cipher_round r1 (before_cipher,k1o,txt1o);
    cipher_round r2 (txt1o,k2o,txt2o);
    cipher_round r3 (txt2o,k3o,txt3o);
    cipher_round r4 (txt3o,k4o,txt4o);
    cipher_round r5 (txt4o,k5o,txt5o);
    cipher_round r6 (txt5o,k6o,txt6o);
    cipher_round r7 (txt6o,k7o,txt7o);
    cipher_round r8 (txt7o,k8o,txt8o);
    cipher_round r9 (txt8o,k9o,txt9o);
    //last cipher
    subbytes sb (txt9o,sb_o);
    shiftrows sr (sb_o,sr_o);
    addroundkey lastround(sr_o,k10o,encrypt_text);
    //keyexpansion
    keyexpansion k1(key,32'h01_00_00_00,k1o);
    keyexpansion k2(k1o,32'h02_00_00_00,k2o);
    keyexpansion k3(k2o,32'h04_00_00_00,k3o);
    keyexpansion k4(k3o,32'h08_00_00_00,k4o);
    keyexpansion k5(k4o,32'h10_00_00_00,k5o);
    keyexpansion k6(k5o,32'h20_00_00_00,k6o);
    keyexpansion k7(k6o,32'h40_00_00_00,k7o);
    keyexpansion k8(k7o,32'h80_00_00_00,k8o);
    keyexpansion k9(k8o,32'h1b_00_00_00,k9o);
    keyexpansion k10(k9o,32'h36_00_00_00,k10o);


endmodule
