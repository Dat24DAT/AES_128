module keyexpansion #(
    parameter R = 10, //round number
              N = 128 //bit length
)(
    input logic clk, rst_n,
    
    input logic [N-1:0] key_i,
    output logic [N-1:0] key_o,
    output logic [$clog2(R)-1:0] roundnum
);

    //declare state
    typedef enum logic [1:0] {idle, before_round, in_round, last_round} statetypte;

    statetypte state_next, state_reg; //4 state ~ 2^2

    //declare reg_signal
    logic [$clog2(R)-1:0] round_next, round_reg;
    logic [N-1:0] keyexpand_next, keyexpand_reg;
    logic [(N/4)-1:0] rot_i, rot_o, sub_o, addr_o;
    logic [(N/4)-1:0] wtemp_1, wtemp_2, wtemp_3, wtemp_4;
    logic [31:0] rcon [0:9] = {
        32'h01_00_00_00,
        32'h02_00_00_00,
        32'h04_00_00_00,
        32'h08_00_00_00,
        32'h10_00_00_00,
        32'h20_00_00_00,
        32'h40_00_00_00,
        32'h80_00_00_00,
        32'h1b_00_00_00,
        32'h36_00_00_00
    };
    //body
    //1. register

    always_ff @(posedge clk) begin 
        if (~rst_n) begin 
            state_reg <= idle;
            round_reg <= 0;
            keyexpand_reg <= 0;
        end else begin 
            state_reg <= state_next;
            round_reg <= round_next;
            keyexpand_reg <= keyexpand_next;
        end   
    end

    //2. nextstate logic
   
    always_comb begin 
        state_next = state_reg;
        round_next = round_reg;
        keyexpand_next = keyexpand_reg;
        rot_i = (round_reg==0)?key_i[31:0]:keyexpand_next[31:0];
        case (state_reg) 
            idle: begin 
                state_next = before_round;
            end
            before_round: begin 
                keyexpand_next = key_i;
                state_next = in_round; 
            end
            in_round: begin 
                round_next = round_reg + 1'b1;
                if (round_reg<4'd10) begin
                    rot_o = rotationword(rot_i);
                    sub_o = subword(rot_o);
                    addr_o = sub_o ^ rcon[round_reg];
                    wtemp_1 = keyexpand_reg[127:96] ^ addr_o;
                    wtemp_2 = wtemp_1 ^ keyexpand_reg[95:64];
                    wtemp_3 = wtemp_2 ^ keyexpand_reg[63:32];
                    wtemp_4 = wtemp_3 ^ keyexpand_reg[31:0];
                    keyexpand_next = {wtemp_1, wtemp_2, wtemp_3, wtemp_4};
                end else begin 
                    round_next = 0; 
                    state_next = last_round;
                end
            end
            last_round: begin 
                state_next = idle;
            end
        endcase
    end

    //3. output logic
    assign roundnum = round_reg;
    assign key_o = keyexpand_reg;

function logic [31:0] rotationword; 
    input [31:0] word_in;
    rotationword = {word_in[23:0],
                           word_in[31:24]};
 endfunction
function logic [31:0] subword; 
    input [31:0] word_in; 
    subword ={Sbox(word_in[31:24]), 
              Sbox(word_in[23:16]), 
              Sbox(word_in[15:8]), 
              Sbox(word_in[7:0])};
endfunction
//S_BOX function
function logic [7:0] Sbox;
input [7:0] in_Val;
case (in_Val[7:0])
    8'h00:	Sbox[7:0] = 8'h63;
    8'h01:	Sbox[7:0] = 8'h7c;
    8'h02:	Sbox[7:0] = 8'h77;
    8'h03:	Sbox[7:0] = 8'h7b;
    8'h04:	Sbox[7:0] = 8'hf2;
    8'h05:	Sbox[7:0] = 8'h6b;
    8'h06:	Sbox[7:0] = 8'h6f;
    8'h07:	Sbox[7:0] = 8'hc5;
    8'h08:	Sbox[7:0] = 8'h30;
    8'h09:	Sbox[7:0] = 8'h01;
    8'h0a:	Sbox[7:0] = 8'h67;
    8'h0b:	Sbox[7:0] = 8'h2b;
    8'h0c:	Sbox[7:0] = 8'hfe;
    8'h0d:	Sbox[7:0] = 8'hd7;
    8'h0e:	Sbox[7:0] = 8'hab;
    8'h0f:	Sbox[7:0] = 8'h76;
    //+++++++++++++++++Row0+++++++++++++++++
    8'h10:	Sbox[7:0] = 8'hca;
    8'h11:	Sbox[7:0] = 8'h82;
    8'h12:	Sbox[7:0] = 8'hc9;
    8'h13:	Sbox[7:0] = 8'h7d;
    8'h14:	Sbox[7:0] = 8'hfa;
    8'h15:	Sbox[7:0] = 8'h59;
    8'h16:	Sbox[7:0] = 8'h47;
    8'h17:	Sbox[7:0] = 8'hf0;
    8'h18:	Sbox[7:0] = 8'had;
    8'h19:	Sbox[7:0] = 8'hd4;
    8'h1a:	Sbox[7:0] = 8'ha2;
    8'h1b:	Sbox[7:0] = 8'haf;
    8'h1c:	Sbox[7:0] = 8'h9c;
    8'h1d:	Sbox[7:0] = 8'ha4;
    8'h1e:	Sbox[7:0] = 8'h72;
    8'h1f:	Sbox[7:0] = 8'hc0;
    //+++++++++++++++++Row1++++++++++++++++
    8'h20:	Sbox[7:0] = 8'hb7;
    8'h21:	Sbox[7:0] = 8'hfd;
    8'h22:	Sbox[7:0] = 8'h93;
    8'h23:	Sbox[7:0] = 8'h26;
    8'h24:	Sbox[7:0] = 8'h36;
    8'h25:	Sbox[7:0] = 8'h3f;
    8'h26:	Sbox[7:0] = 8'hf7;
    8'h27:	Sbox[7:0] = 8'hcc;
    8'h28:	Sbox[7:0] = 8'h34;
    8'h29:	Sbox[7:0] = 8'ha5;
    8'h2a:	Sbox[7:0] = 8'he5;
    8'h2b:	Sbox[7:0] = 8'hf1;
    8'h2c:	Sbox[7:0] = 8'h71;
    8'h2d:	Sbox[7:0] = 8'hd8;
    8'h2e:	Sbox[7:0] = 8'h31;
    8'h2f:	Sbox[7:0] = 8'h15;
    //++++++++++++++++Row2++++++++++++++++
    8'h30:	Sbox[7:0] = 8'h04;
    8'h31:	Sbox[7:0] = 8'hc7;
    8'h32:	Sbox[7:0] = 8'h23;
    8'h33:	Sbox[7:0] = 8'hc3;
    8'h34:	Sbox[7:0] = 8'h18;
    8'h35:	Sbox[7:0] = 8'h96;
    8'h36:	Sbox[7:0] = 8'h05;
    8'h37:	Sbox[7:0] = 8'h9a;
    8'h38:	Sbox[7:0] = 8'h07;
    8'h39:	Sbox[7:0] = 8'h12;
    8'h3a:	Sbox[7:0] = 8'h80;
    8'h3b:	Sbox[7:0] = 8'he2;
    8'h3c:	Sbox[7:0] = 8'heb;
    8'h3d:	Sbox[7:0] = 8'h27;
    8'h3e:	Sbox[7:0] = 8'hb2;
    8'h3f:	Sbox[7:0] = 8'h75;
    //+++++++++++++++Row3++++++++++++++++
    8'h40:	Sbox[7:0] = 8'h09;
    8'h41:	Sbox[7:0] = 8'h83;
    8'h42:	Sbox[7:0] = 8'h2c;
    8'h43:	Sbox[7:0] = 8'h1a;
    8'h44:	Sbox[7:0] = 8'h1b;
    8'h45:	Sbox[7:0] = 8'h6e;
    8'h46:	Sbox[7:0] = 8'h5a;
    8'h47:	Sbox[7:0] = 8'ha0;
    8'h48:	Sbox[7:0] = 8'h52;
    8'h49:	Sbox[7:0] = 8'h3b;
    8'h4a:	Sbox[7:0] = 8'hd6;
    8'h4b:	Sbox[7:0] = 8'hb3;
    8'h4c:	Sbox[7:0] = 8'h29;
    8'h4d:	Sbox[7:0] = 8'he3;
    8'h4e:	Sbox[7:0] = 8'h2f;
    8'h4f:	Sbox[7:0] = 8'h84;
    //+++++++++++++++Row4++++++++++++++++
    8'h50:	Sbox[7:0] = 8'h53;
    8'h51:	Sbox[7:0] = 8'hd1;
    8'h52:	Sbox[7:0] = 8'h00;
    8'h53:	Sbox[7:0] = 8'hed;
    8'h54:	Sbox[7:0] = 8'h20;
    8'h55:	Sbox[7:0] = 8'hfc;
    8'h56:	Sbox[7:0] = 8'hb1;
    8'h57:	Sbox[7:0] = 8'h5b;
    8'h58:	Sbox[7:0] = 8'h6a;
    8'h59:	Sbox[7:0] = 8'hcb;
    8'h5a:	Sbox[7:0] = 8'hbe;
    8'h5b:	Sbox[7:0] = 8'h39;
    8'h5c:	Sbox[7:0] = 8'h4a;
    8'h5d:	Sbox[7:0] = 8'h4c;
    8'h5e:	Sbox[7:0] = 8'h58;
    8'h5f:	Sbox[7:0] = 8'hcf;
    //+++++++++++++++Row5++++++++++++++++
    8'h60:	Sbox[7:0] = 8'hd0;
    8'h61:	Sbox[7:0] = 8'hef;
    8'h62:	Sbox[7:0] = 8'haa;
    8'h63:	Sbox[7:0] = 8'hfb;
    8'h64:	Sbox[7:0] = 8'h43;
    8'h65:	Sbox[7:0] = 8'h4d;
    8'h66:	Sbox[7:0] = 8'h33;
    8'h67:	Sbox[7:0] = 8'h85;
    8'h68:	Sbox[7:0] = 8'h45;
    8'h69:	Sbox[7:0] = 8'hf9;
    8'h6a:	Sbox[7:0] = 8'h02;
    8'h6b:	Sbox[7:0] = 8'h7f;
    8'h6c:	Sbox[7:0] = 8'h50;
    8'h6d:	Sbox[7:0] = 8'h3c;
    8'h6e:	Sbox[7:0] = 8'h9f;
    8'h6f:	Sbox[7:0] = 8'ha8;
    //+++++++++++++++Row6+++++++++++++++
    8'h70:	Sbox[7:0] = 8'h51;
    8'h71:	Sbox[7:0] = 8'ha3;
    8'h72:	Sbox[7:0] = 8'h40;
    8'h73:	Sbox[7:0] = 8'h8f;
    8'h74:	Sbox[7:0] = 8'h92;
    8'h75:	Sbox[7:0] = 8'h9d;
    8'h76:	Sbox[7:0] = 8'h38;
    8'h77:	Sbox[7:0] = 8'hf5;
    8'h78:	Sbox[7:0] = 8'hbc;
    8'h79:	Sbox[7:0] = 8'hb6;
    8'h7a:	Sbox[7:0] = 8'hda;
    8'h7b:	Sbox[7:0] = 8'h21;
    8'h7c:	Sbox[7:0] = 8'h10;
    8'h7d:	Sbox[7:0] = 8'hff;
    8'h7e:	Sbox[7:0] = 8'hf3;
    8'h7f:	Sbox[7:0] = 8'hd2;
    //++++++++++++++Row7++++++++++++++++
    8'h80:	Sbox[7:0] = 8'hcd;
    8'h81:	Sbox[7:0] = 8'h0c;
    8'h82:	Sbox[7:0] = 8'h13;
    8'h83:	Sbox[7:0] = 8'hec;
    8'h84:	Sbox[7:0] = 8'h5f;
    8'h85:	Sbox[7:0] = 8'h97;
    8'h86:	Sbox[7:0] = 8'h44;
    8'h87:	Sbox[7:0] = 8'h17;
    8'h88:	Sbox[7:0] = 8'hc4;
    8'h89:	Sbox[7:0] = 8'ha7;
    8'h8a:	Sbox[7:0] = 8'h7e;
    8'h8b:	Sbox[7:0] = 8'h3d;
    8'h8c:	Sbox[7:0] = 8'h64;
    8'h8d:	Sbox[7:0] = 8'h5d;
    8'h8e:	Sbox[7:0] = 8'h19;
    8'h8f:	Sbox[7:0] = 8'h73;
    //+++++++++++++++Row8+++++++++++++++
    8'h90:	Sbox[7:0] = 8'h60;
    8'h91:	Sbox[7:0] = 8'h81;
    8'h92:	Sbox[7:0] = 8'h4f;
    8'h93:	Sbox[7:0] = 8'hdc;
    8'h94:	Sbox[7:0] = 8'h22;
    8'h95:	Sbox[7:0] = 8'h2a;
    8'h96:	Sbox[7:0] = 8'h90;
    8'h97:	Sbox[7:0] = 8'h88;
    8'h98:	Sbox[7:0] = 8'h46;
    8'h99:	Sbox[7:0] = 8'hee;
    8'h9a:	Sbox[7:0] = 8'hb8;
    8'h9b:	Sbox[7:0] = 8'h14;
    8'h9c:	Sbox[7:0] = 8'hde;
    8'h9d:	Sbox[7:0] = 8'h5e;
    8'h9e:	Sbox[7:0] = 8'h0b;
    8'h9f:	Sbox[7:0] = 8'hdb;
    //+++++++++++++++Row9+++++++++++++++
    8'ha0:	Sbox[7:0] = 8'he0;
    8'ha1:	Sbox[7:0] = 8'h32;
    8'ha2:	Sbox[7:0] = 8'h3a;
    8'ha3:	Sbox[7:0] = 8'h0a;
    8'ha4:	Sbox[7:0] = 8'h49;
    8'ha5:	Sbox[7:0] = 8'h06;
    8'ha6:	Sbox[7:0] = 8'h24;
    8'ha7:	Sbox[7:0] = 8'h5c;
    8'ha8:	Sbox[7:0] = 8'hc2;
    8'ha9:	Sbox[7:0] = 8'hd3;
    8'haa:	Sbox[7:0] = 8'hac;
    8'hab:	Sbox[7:0] = 8'h62;
    8'hac:	Sbox[7:0] = 8'h91;
    8'had:	Sbox[7:0] = 8'h95;
    8'hae:	Sbox[7:0] = 8'he4;
    8'haf:	Sbox[7:0] = 8'h79;
    //++++++++++++++++Row10++++++++++++++
    8'hb0:	Sbox[7:0] = 8'he7;
    8'hb1:	Sbox[7:0] = 8'hc8;
    8'hb2:	Sbox[7:0] = 8'h37;
    8'hb3:	Sbox[7:0] = 8'h6d;
    8'hb4:	Sbox[7:0] = 8'h8d;
    8'hb5:	Sbox[7:0] = 8'hd5;
    8'hb6:	Sbox[7:0] = 8'h4e;
    8'hb7:	Sbox[7:0] = 8'ha9;
    8'hb8:	Sbox[7:0] = 8'h6c;
    8'hb9:	Sbox[7:0] = 8'h56;
    8'hba:	Sbox[7:0] = 8'hf4;
    8'hbb:	Sbox[7:0] = 8'hea;
    8'hbc:	Sbox[7:0] = 8'h65;
    8'hbd:	Sbox[7:0] = 8'h7a;
    8'hbe:	Sbox[7:0] = 8'hae;
    8'hbf:	Sbox[7:0] = 8'h08;
    //+++++++++++++++Row11+++++++++++++++
    8'hc0:	Sbox[7:0] = 8'hba;
    8'hc1:	Sbox[7:0] = 8'h78;
    8'hc2:	Sbox[7:0] = 8'h25;
    8'hc3:	Sbox[7:0] = 8'h2e;
    8'hc4:	Sbox[7:0] = 8'h1c;
    8'hc5:	Sbox[7:0] = 8'ha6;
    8'hc6:	Sbox[7:0] = 8'hb4;
    8'hc7:	Sbox[7:0] = 8'hc6;
    8'hc8:	Sbox[7:0] = 8'he8;
    8'hc9:	Sbox[7:0] = 8'hdd;
    8'hca:	Sbox[7:0] = 8'h74;
    8'hcb:	Sbox[7:0] = 8'h1f;
    8'hcc:	Sbox[7:0] = 8'h4b;
    8'hcd:	Sbox[7:0] = 8'hbd;
    8'hce:	Sbox[7:0] = 8'h8b;
    8'hcf:	Sbox[7:0] = 8'h8a;
    //++++++++++++++Row12++++++++++++++++
    8'hd0:	Sbox[7:0] = 8'h70;
    8'hd1:	Sbox[7:0] = 8'h3e;
    8'hd2:	Sbox[7:0] = 8'hb5;
    8'hd3:	Sbox[7:0] = 8'h66;
    8'hd4:	Sbox[7:0] = 8'h48;
    8'hd5:	Sbox[7:0] = 8'h03;
    8'hd6:	Sbox[7:0] = 8'hf6;
    8'hd7:	Sbox[7:0] = 8'h0e;
    8'hd8:	Sbox[7:0] = 8'h61;
    8'hd9:	Sbox[7:0] = 8'h35;
    8'hda:	Sbox[7:0] = 8'h57;
    8'hdb:	Sbox[7:0] = 8'hb9;
    8'hdc:	Sbox[7:0] = 8'h86;
    8'hdd:	Sbox[7:0] = 8'hc1;
    8'hde:	Sbox[7:0] = 8'h1d;
    8'hdf:	Sbox[7:0] = 8'h9e;
    //++++++++++++++Row13+++++++++++++++
    8'he0:	Sbox[7:0] = 8'he1;
    8'he1:	Sbox[7:0] = 8'hf8;
    8'he2:	Sbox[7:0] = 8'h98;
    8'he3:	Sbox[7:0] = 8'h11;
    8'he4:	Sbox[7:0] = 8'h69;
    8'he5:	Sbox[7:0] = 8'hd9;
    8'he6:	Sbox[7:0] = 8'h8e;
    8'he7:	Sbox[7:0] = 8'h94;
    8'he8:	Sbox[7:0] = 8'h9b;
    8'he9:	Sbox[7:0] = 8'h1e;
    8'hea:	Sbox[7:0] = 8'h87;
    8'heb:	Sbox[7:0] = 8'he9;
    8'hec:	Sbox[7:0] = 8'hce;
    8'hed:	Sbox[7:0] = 8'h55;
    8'hee:	Sbox[7:0] = 8'h28;
    8'hef:	Sbox[7:0] = 8'hdf;
    //+++++++++++++++Row14+++++++++++++++
    8'hf0:	Sbox[7:0] = 8'h8c;
    8'hf1:	Sbox[7:0] = 8'ha1;
    8'hf2:	Sbox[7:0] = 8'h89;
    8'hf3:	Sbox[7:0] = 8'h0d;
    8'hf4:	Sbox[7:0] = 8'hbf;
    8'hf5:	Sbox[7:0] = 8'he6;
    8'hf6:	Sbox[7:0] = 8'h42;
    8'hf7:	Sbox[7:0] = 8'h68;
    8'hf8:	Sbox[7:0] = 8'h41;
    8'hf9:	Sbox[7:0] = 8'h99;
    8'hfa:	Sbox[7:0] = 8'h2d;
    8'hfb:	Sbox[7:0] = 8'h0f;
    8'hfc:	Sbox[7:0] = 8'hb0;
    8'hfd:	Sbox[7:0] = 8'h54;
    8'hfe:	Sbox[7:0] = 8'hbb;
    8'hff:	Sbox[7:0] = 8'h16;
    default: Sbox[7:0] = 8'hXX;
endcase
endfunction 



endmodule
