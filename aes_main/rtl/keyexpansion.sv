module keyexpansion (
    input logic [127:0] key,
    input logic [31:0] rcon,
    output logic [127:0] key_o);

    logic [31:0]  w0, w1, w2, w3, w4, w5, w6, w7; //word
    logic [31:0]  rw; //rotation word res
    logic [31:0]  sw; //subword res
    logic [31:0]  z; //addRcon res

    //divide each word
    assign {w0, w1, w2, w3} = key;
    //rotation word
    rotationword rot (w3,rw);
    //subword
    subword sub (rw,sw);
    //addrcon
    assign z = sw ^ rcon;
    assign w4 = w0 ^ z;
    assign w5 = w4 ^ w1;
    assign w6 = w5 ^ w2;
    assign w7 = w6 ^ w3;

    //result
    assign key_o = {w4,w5,w6,w7};
endmodule
