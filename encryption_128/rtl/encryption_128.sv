module encryption_128 #(
    parameter N = 128, //bit length
              R = 10   //round number
)(
    input logic clk,
    input logic rst_n,
    input logic [N-1:0] plain_text,
    input logic [N-1:0] key,
    output logic [N-1:0] encrypt_text,
    output logic [$clog2(R)-1:0] round
);
    logic [N-1:0] keyexpansion;
keyexpansion # (
    .R(R),
    .N(N)
)
keyexpansion_inst (
  .clk(clk),
  .rst_n(rst_n),
  .key_i(key),
  .key_o(keyexpansion),
  .roundnum()
);

cipher_round # (
  .N(N),
  .R(R)
)
cipher_round_inst (
  .clk(clk),
  .rst_n(rst_n),
  .plain_text(plain_text),
  .cipher_key(keyexpansion),
  .cipher_text(encrypt_text),
  .roundnum(round)
);

endmodule
