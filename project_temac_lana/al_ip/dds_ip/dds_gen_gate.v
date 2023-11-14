// Verilog netlist created by Tang Dynasty v5.6.71036
// Sat Nov  4 16:41:51 2023

`timescale 1ns / 1ps
module dds_gen
  (
  clk,
  rst_n,
  wave_sin
  );

  input clk;
  input rst_n;
  output [7:0] wave_sin;

  parameter FREC_OUT = 1000;
  parameter FREC_SYS = 25000000;
  parameter LENTH_ROM = 64;
  parameter W_DOUT = 8;
  parameter W_PHASE = 32;
  parameter W_PHASE_ANGLE = 8;
  // localparam PHA_INC = 171799;
  // localparam W_JITTER = 2;
  wire [31:0] al_4c12045b;
  wire [31:0] al_7521c31;
  wire [4:0] al_8aaaf100;
  wire [4:0] al_6790cfef;
  wire [4:0] al_8378b540;
  wire [6:0] al_75776e99;
  wire [6:0] al_e1c1520b;
  wire [6:0] al_7c6da17f;
  wire [5:0] al_d0d95c2b;
  wire [31:0] al_2adbf503;
  wire [31:0] al_2b6fc17c;
  wire [7:0] al_20075ca4;
  wire [5:0] al_7f151afd;
  wire [5:0] al_50d27df2;
  wire [7:0] al_3bc6703c;
  wire [5:0] al_bf62f43;
  wire [5:0] al_1db9833e;
  wire [5:0] al_2c65e87;
  wire [5:0] al_ff8d588f;
  wire [5:0] al_e765e4ce;
  wire [1:0] al_1bd38818;
  wire [1:0] al_bb164c48;
  wire [1:0] al_7a1b1ebf;
  wire [1:0] al_78084675;
  wire [1:0] al_9829b3b7;
  wire [1:0] al_4f8d039a;
  wire [1:0] al_2bbe55df;
  wire [7:0] al_bc5c8fc3;
  wire al_39b072a6;
  wire al_6d449e6d;
  wire al_69d0dbb1;
  wire al_25da9a4d;
  wire al_69da8c0d;
  wire al_547a024f;
  wire al_8818a2e6;
  wire al_47ede454;
  wire al_550dcbe7;
  wire al_18e84921;
  wire al_b39cf699;
  wire al_2b66b2f0;
  wire al_1a59fbd;
  wire al_603abf31;
  wire al_96086b48;
  wire al_fdbb05c9;
  wire al_61924bd3;
  wire al_348a672e;
  wire al_cc465230;
  wire al_e0ee3aa7;
  wire al_3ef98529;
  wire al_26c1fb8;
  wire al_98092ecb;
  wire al_4676a91f;
  wire al_f325ef3;
  wire al_dd931218;
  wire al_5f25ed9a;
  wire al_a9c4ae48;
  wire al_be381618;
  wire al_e70d13e6;
  wire al_cc167f6a;
  wire al_796c3851;
  wire al_c4992340;
  wire al_9bc272f8;
  wire al_8d3c91f3;
  wire al_124cb870;
  wire al_d21cd2ba;

  AL_MAP_ADDER #(
    .ALUTYPE("ADD_CARRY"))
    al_8b54afaf (
    .a(1'b0),
    .o({al_39b072a6,open_n2}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_90b1a19d (
    .a(al_4c12045b[0]),
    .b(1'b1),
    .c(al_39b072a6),
    .o({al_6d449e6d,al_7521c31[0]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_e56607bb (
    .a(al_4c12045b[1]),
    .b(1'b1),
    .c(al_6d449e6d),
    .o({al_69d0dbb1,al_7521c31[1]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_4e97fc42 (
    .a(al_4c12045b[2]),
    .b(1'b1),
    .c(al_69d0dbb1),
    .o({al_25da9a4d,al_7521c31[2]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_29d0fe45 (
    .a(al_4c12045b[3]),
    .b(1'b0),
    .c(al_25da9a4d),
    .o({al_69da8c0d,al_7521c31[3]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_f04e2943 (
    .a(al_4c12045b[4]),
    .b(1'b1),
    .c(al_69da8c0d),
    .o({al_547a024f,al_7521c31[4]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_4566af8 (
    .a(al_4c12045b[5]),
    .b(1'b0),
    .c(al_547a024f),
    .o({al_8818a2e6,al_7521c31[5]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_33f9013e (
    .a(al_4c12045b[6]),
    .b(1'b0),
    .c(al_8818a2e6),
    .o({al_47ede454,al_7521c31[6]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_4c65cb8e (
    .a(al_4c12045b[7]),
    .b(1'b0),
    .c(al_47ede454),
    .o({al_550dcbe7,al_7521c31[7]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_da4d991f (
    .a(al_4c12045b[8]),
    .b(1'b1),
    .c(al_550dcbe7),
    .o({al_18e84921,al_7521c31[8]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_2ca84eaf (
    .a(al_4c12045b[9]),
    .b(1'b1),
    .c(al_18e84921),
    .o({al_b39cf699,al_7521c31[9]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_b168a924 (
    .a(al_4c12045b[10]),
    .b(1'b1),
    .c(al_b39cf699),
    .o({al_2b66b2f0,al_7521c31[10]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_bf3dee16 (
    .a(al_4c12045b[11]),
    .b(1'b1),
    .c(al_2b66b2f0),
    .o({al_1a59fbd,al_7521c31[11]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_7d5110c4 (
    .a(al_4c12045b[12]),
    .b(1'b1),
    .c(al_1a59fbd),
    .o({al_603abf31,al_7521c31[12]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_5e4e1242 (
    .a(al_4c12045b[13]),
    .b(1'b0),
    .c(al_603abf31),
    .o({al_96086b48,al_7521c31[13]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_39b541bd (
    .a(al_4c12045b[14]),
    .b(1'b0),
    .c(al_96086b48),
    .o({al_fdbb05c9,al_7521c31[14]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_2a369922 (
    .a(al_4c12045b[15]),
    .b(1'b1),
    .c(al_fdbb05c9),
    .o({al_61924bd3,al_7521c31[15]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_e3fe9e39 (
    .a(al_4c12045b[16]),
    .b(1'b0),
    .c(al_61924bd3),
    .o({al_348a672e,al_7521c31[16]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_87d9fb8e (
    .a(al_4c12045b[17]),
    .b(1'b1),
    .c(al_348a672e),
    .o({al_cc465230,al_7521c31[17]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_f0a7793e (
    .a(al_4c12045b[18]),
    .b(1'b0),
    .c(al_cc465230),
    .o({al_e0ee3aa7,al_7521c31[18]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_ef8ca7a (
    .a(al_4c12045b[19]),
    .b(1'b0),
    .c(al_e0ee3aa7),
    .o({al_3ef98529,al_7521c31[19]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_5e1cc0db (
    .a(al_4c12045b[20]),
    .b(1'b0),
    .c(al_3ef98529),
    .o({al_26c1fb8,al_7521c31[20]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_6480eafb (
    .a(al_4c12045b[21]),
    .b(1'b0),
    .c(al_26c1fb8),
    .o({al_98092ecb,al_7521c31[21]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_9fa29e14 (
    .a(al_4c12045b[22]),
    .b(1'b0),
    .c(al_98092ecb),
    .o({al_4676a91f,al_7521c31[22]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_99027a6d (
    .a(al_4c12045b[23]),
    .b(1'b0),
    .c(al_4676a91f),
    .o({al_f325ef3,al_7521c31[23]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_14fcc43a (
    .a(al_4c12045b[24]),
    .b(1'b0),
    .c(al_f325ef3),
    .o({al_dd931218,al_7521c31[24]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_b8e89d08 (
    .a(al_4c12045b[25]),
    .b(1'b0),
    .c(al_dd931218),
    .o({al_5f25ed9a,al_7521c31[25]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_75e15d70 (
    .a(al_4c12045b[26]),
    .b(1'b0),
    .c(al_5f25ed9a),
    .o({al_a9c4ae48,al_7521c31[26]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_2c75845 (
    .a(al_4c12045b[27]),
    .b(1'b0),
    .c(al_a9c4ae48),
    .o({al_be381618,al_7521c31[27]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_458a0a0f (
    .a(al_4c12045b[28]),
    .b(1'b0),
    .c(al_be381618),
    .o({al_e70d13e6,al_7521c31[28]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_43230675 (
    .a(al_4c12045b[29]),
    .b(1'b0),
    .c(al_e70d13e6),
    .o({al_cc167f6a,al_7521c31[29]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_aad3402e (
    .a(al_4c12045b[30]),
    .b(1'b0),
    .c(al_cc167f6a),
    .o({al_796c3851,al_7521c31[30]}));
  AL_MAP_ADDER #(
    .ALUTYPE("ADD"))
    al_2fc4812b (
    .a(al_4c12045b[31]),
    .b(1'b0),
    .c(al_796c3851),
    .o({open_n3,al_7521c31[31]}));
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    al_e7719e5c (
    .a(al_8d3c91f3),
    .b(al_7c6da17f[0]),
    .o(al_e1c1520b[0]));
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    al_94a75fe2 (
    .a(al_8d3c91f3),
    .b(al_7c6da17f[1]),
    .o(al_e1c1520b[1]));
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    al_b4d9aa1c (
    .a(al_8d3c91f3),
    .b(al_7c6da17f[2]),
    .o(al_e1c1520b[2]));
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    al_9068d8fe (
    .a(al_8d3c91f3),
    .b(al_7c6da17f[3]),
    .o(al_e1c1520b[3]));
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    al_4349e479 (
    .a(al_8d3c91f3),
    .b(al_7c6da17f[4]),
    .o(al_e1c1520b[4]));
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    al_ad9414d2 (
    .a(al_8d3c91f3),
    .b(al_7c6da17f[5]),
    .o(al_e1c1520b[5]));
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    al_7b95c4a (
    .a(al_8d3c91f3),
    .b(al_7c6da17f[6]),
    .o(al_e1c1520b[6]));
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    al_cc82235e (
    .a(al_e765e4ce[0]),
    .b(al_8378b540[1]),
    .o(al_d0d95c2b[0]));
  AL_MAP_LUT4 #(
    .EQN("(D@B@(C*A))"),
    .INIT(16'h936c))
    al_d3f793f (
    .a(al_e765e4ce[0]),
    .b(al_e765e4ce[1]),
    .c(al_8378b540[1]),
    .d(al_8378b540[2]),
    .o(al_d0d95c2b[1]));
  AL_MAP_LUT6 #(
    .EQN("(F@C@(B*(D*A)*~(E)+B*~((D*A))*E+~(B)*(D*A)*E+B*(D*A)*E))"),
    .INIT(64'he1c3870f1e3c78f0))
    al_23cd9701 (
    .a(al_e765e4ce[0]),
    .b(al_e765e4ce[1]),
    .c(al_e765e4ce[2]),
    .d(al_8378b540[1]),
    .e(al_8378b540[2]),
    .f(al_8378b540[3]),
    .o(al_d0d95c2b[2]));
  AL_MAP_LUT3 #(
    .EQN("~(C@B@A)"),
    .INIT(8'h69))
    al_29e82002 (
    .a(al_9bc272f8),
    .b(al_e765e4ce[3]),
    .c(al_8378b540[4]),
    .o(al_d0d95c2b[3]));
  AL_MAP_LUT4 #(
    .EQN("(C@(~(A)*B*~(D)+~(A)*~(B)*D+~(A)*B*D+A*B*D))"),
    .INIT(16'h2db4))
    al_2aa8368e (
    .a(al_9bc272f8),
    .b(al_e765e4ce[3]),
    .c(al_e765e4ce[4]),
    .d(al_8378b540[4]),
    .o(al_d0d95c2b[4]));
  AL_MAP_LUT6 #(
    .EQN("(~(B)*~(C)*~((D*A))*~(E)*~(F)+B*~(C)*~((D*A))*~(E)*~(F)+~(B)*C*~((D*A))*~(E)*~(F)+B*C*~((D*A))*~(E)*~(F)+~(B)*~(C)*(D*A)*~(E)*~(F)+B*~(C)*(D*A)*~(E)*~(F)+~(B)*C*(D*A)*~(E)*~(F)+~(B)*~(C)*~((D*A))*E*~(F)+B*~(C)*~((D*A))*E*~(F)+~(B)*C*~((D*A))*E*~(F)+~(B)*~(C)*(D*A)*E*~(F)+B*~(C)*(D*A)*E*~(F)+~(B)*~(C)*~((D*A))*~(E)*F+B*~(C)*~((D*A))*~(E)*F+~(B)*~(C)*(D*A)*~(E)*F+~(B)*~(C)*~((D*A))*E*F)"),
    .INIT(64'h0103070f1f3f7fff))
    al_3e4e6040 (
    .a(al_e765e4ce[0]),
    .b(al_e765e4ce[1]),
    .c(al_e765e4ce[2]),
    .d(al_8378b540[1]),
    .e(al_8378b540[2]),
    .f(al_8378b540[3]),
    .o(al_9bc272f8));
  AL_MAP_LUT5 #(
    .EQN("(D@(C*(~(A)*B*~(E)+~(A)*~(B)*E+~(A)*B*E+A*B*E)))"),
    .INIT(32'h2fd0bf40))
    al_cea4c426 (
    .a(al_9bc272f8),
    .b(al_e765e4ce[3]),
    .c(al_e765e4ce[4]),
    .d(al_e765e4ce[5]),
    .e(al_8378b540[4]),
    .o(al_d0d95c2b[5]));
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    al_7355522e (
    .a(al_20075ca4[0]),
    .b(al_20075ca4[1]),
    .o(al_3bc6703c[1]));
  AL_MAP_LUT3 #(
    .EQN("~(C@(~B*~A))"),
    .INIT(8'h1e))
    al_551b86c4 (
    .a(al_20075ca4[0]),
    .b(al_20075ca4[1]),
    .c(al_20075ca4[2]),
    .o(al_3bc6703c[2]));
  AL_MAP_LUT4 #(
    .EQN("~(D@(~C*~B*~A))"),
    .INIT(16'h01fe))
    al_1a6fd996 (
    .a(al_20075ca4[0]),
    .b(al_20075ca4[1]),
    .c(al_20075ca4[2]),
    .d(al_20075ca4[3]),
    .o(al_3bc6703c[3]));
  AL_MAP_LUT5 #(
    .EQN("~(E@(~D*~C*~B*~A))"),
    .INIT(32'h0001fffe))
    al_e1323966 (
    .a(al_20075ca4[0]),
    .b(al_20075ca4[1]),
    .c(al_20075ca4[2]),
    .d(al_20075ca4[3]),
    .e(al_20075ca4[4]),
    .o(al_3bc6703c[4]));
  AL_MAP_LUT6 #(
    .EQN("~(F@(~E*~D*~C*~B*~A))"),
    .INIT(64'h00000001fffffffe))
    al_a0e2a4a4 (
    .a(al_20075ca4[0]),
    .b(al_20075ca4[1]),
    .c(al_20075ca4[2]),
    .d(al_20075ca4[3]),
    .e(al_20075ca4[4]),
    .f(al_20075ca4[5]),
    .o(al_3bc6703c[5]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(C)*~(B)+A*C*~(B)+~(A)*C*B+A*C*B)"),
    .INIT(8'he2))
    al_408a3a (
    .a(al_7f151afd[1]),
    .b(al_1bd38818[0]),
    .c(al_50d27df2[1]),
    .o(al_1db9833e[1]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(C)*~(B)+A*C*~(B)+~(A)*C*B+A*C*B)"),
    .INIT(8'he2))
    al_5d459b87 (
    .a(al_7f151afd[2]),
    .b(al_1bd38818[0]),
    .c(al_50d27df2[2]),
    .o(al_1db9833e[2]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(C)*~(B)+A*C*~(B)+~(A)*C*B+A*C*B)"),
    .INIT(8'he2))
    al_ffa9fd0d (
    .a(al_7f151afd[3]),
    .b(al_1bd38818[0]),
    .c(al_50d27df2[3]),
    .o(al_1db9833e[3]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(C)*~(B)+A*C*~(B)+~(A)*C*B+A*C*B)"),
    .INIT(8'he2))
    al_1323da91 (
    .a(al_7f151afd[4]),
    .b(al_1bd38818[0]),
    .c(al_50d27df2[4]),
    .o(al_1db9833e[4]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(C)*~(B)+A*C*~(B)+~(A)*C*B+A*C*B)"),
    .INIT(8'he2))
    al_ee689b0c (
    .a(al_7f151afd[5]),
    .b(al_1bd38818[0]),
    .c(al_50d27df2[5]),
    .o(al_1db9833e[5]));
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    al_da3205d2 (
    .a(al_e765e4ce[0]),
    .b(al_e765e4ce[1]),
    .c(al_e765e4ce[2]),
    .d(al_e765e4ce[3]),
    .o(al_d21cd2ba));
  AL_MAP_LUT4 #(
    .EQN("(D*~C*~B*A)"),
    .INIT(16'h0200))
    al_1aefe382 (
    .a(al_d21cd2ba),
    .b(al_e765e4ce[4]),
    .c(al_e765e4ce[5]),
    .d(al_9829b3b7[0]),
    .o(al_124cb870));
  AL_DFF_X al_14fec9f5 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_124cb870),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_8d3c91f3));
  PH1_LOGIC_ERAM #(
    //.FORCE_KEEP("OFF"),
    .ADDR_WIDTH_A(6),
    .ADDR_WIDTH_B(6),
    .ASYNC_RESET_RELEASE_A("ASYNC"),
    .ASYNC_RESET_RELEASE_B("ASYNC"),
    .BYTE_A(1),
    .BYTE_B(1),
    .BYTE_ENABLE(0),
    .DATA_DEPTH_A(64),
    .DATA_DEPTH_B(64),
    .DATA_WIDTH_A(5),
    .DATA_WIDTH_B(5),
    .DEBUGGABLE("NO"),
    .FILL_ALL("NONE"),
    .IMPLEMENT("20K"),
    .INIT_FILE("init_str:00000 10000 01000 11000 00100 01100 11100 00010 10010 01010 11010 00110 10110 01110 11110 00001 10001 10001 01001 11001 00101 10101 10101 01101 11101 11101 00011 00011 10011 10011 10011 01011 01011 01011 01011 01011 01011 01011 01011 01011 01011 10011 10011 10011 00011 11101 11101 01101 10101 00101 00101 11001 01001 00001 11110 01110 10110 11010 01010 00010 01100 10100 11000 10000"),
    .MODE("SP"),
    .OREGSET_A("RESET"),
    .OREGSET_B("RESET"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE_A("ASYNC"),
    .RESETMODE_B("ASYNC"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    al_82f1a528 (
    .addra(al_bf62f43),
    .addrb(6'b000000),
    .bea(1'b0),
    .beb(1'b0),
    .cea(1'b1),
    .ceb(1'b0),
    .clka(clk),
    .clkb(1'b0),
    .dia(5'b00000),
    .dib(5'b00000),
    .ocea(1'b1),
    .oceb(1'b0),
    .rsta(1'b0),
    .rstb(1'b0),
    .wea(1'b0),
    .web(1'b0),
    .doa(al_8aaaf100));
  AL_DFF_X al_e2342da (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[8]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[8]));
  AL_DFF_X al_f8c23993 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[9]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[9]));
  AL_DFF_X al_7f0c0435 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[10]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[10]));
  AL_DFF_X al_b354880f (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[11]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[11]));
  AL_DFF_X al_b3ef0560 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[12]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[12]));
  AL_DFF_X al_a0292264 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[13]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[13]));
  AL_DFF_X al_ac9b3078 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[14]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[14]));
  AL_DFF_X al_fd18d67 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[15]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[15]));
  AL_DFF_X al_d6bb0029 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[16]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[16]));
  AL_DFF_X al_474f8f4a (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[17]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[17]));
  AL_DFF_X al_b26d62bf (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[0]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[0]));
  AL_DFF_X al_ab9dd774 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[18]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[18]));
  AL_DFF_X al_88b39ea0 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[19]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[19]));
  AL_DFF_X al_9db2f7ba (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[20]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[20]));
  AL_DFF_X al_4354aafd (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[21]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[21]));
  AL_DFF_X al_ab055865 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[22]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[22]));
  AL_DFF_X al_9f75260d (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[23]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[23]));
  AL_DFF_X al_aa1e0ec3 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[24]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[24]));
  AL_DFF_X al_e9f72998 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[25]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[25]));
  AL_DFF_X al_3d07ae02 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[26]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[26]));
  AL_DFF_X al_4f22adc1 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[27]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[27]));
  AL_DFF_X al_809f7104 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[1]));
  AL_DFF_X al_16a9ca3a (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[28]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[28]));
  AL_DFF_X al_c0fff07d (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[29]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[29]));
  AL_DFF_X al_8fe65937 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[30]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[30]));
  AL_DFF_X al_65d1adb3 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[31]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[31]));
  AL_DFF_X al_c1468025 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[2]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[2]));
  AL_DFF_X al_c19d8344 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[3]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[3]));
  AL_DFF_X al_ca1eda73 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[4]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[4]));
  AL_DFF_X al_fa89b429 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[5]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[5]));
  AL_DFF_X al_3462fe16 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[6]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[6]));
  AL_DFF_X al_87f5414c (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7521c31[7]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4c12045b[7]));
  AL_DFF_X al_6eb318e4 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_20075ca4[0]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_7f151afd[0]));
  AL_DFF_X al_10074c95 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_20075ca4[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_7f151afd[1]));
  AL_DFF_X al_5fb1cf51 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_20075ca4[2]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_7f151afd[2]));
  AL_DFF_X al_dc5daab3 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_20075ca4[3]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_7f151afd[3]));
  AL_DFF_X al_5394044a (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_20075ca4[4]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_7f151afd[4]));
  AL_DFF_X al_b89d9b42 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_20075ca4[5]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_7f151afd[5]));
  AL_DFF_X al_de040350 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7f151afd[0]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_bf62f43[0]));
  AL_DFF_X al_25378cfc (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_1db9833e[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_bf62f43[1]));
  AL_DFF_X al_dc93576e (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_1db9833e[2]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_bf62f43[2]));
  AL_DFF_X al_76b20766 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_1db9833e[3]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_bf62f43[3]));
  AL_DFF_X al_a8ce422 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_1db9833e[4]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_bf62f43[4]));
  AL_DFF_X al_e3895fe2 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_1db9833e[5]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_bf62f43[5]));
  AL_DFF_X al_31c2c18 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_bf62f43[0]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2c65e87[0]));
  AL_DFF_X al_bed75354 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_bf62f43[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2c65e87[1]));
  AL_DFF_X al_b2c2a4b7 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_bf62f43[2]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2c65e87[2]));
  AL_DFF_X al_99383aba (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_bf62f43[3]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2c65e87[3]));
  AL_DFF_X al_f8178b2c (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_bf62f43[4]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2c65e87[4]));
  AL_DFF_X al_be1fc3e5 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_bf62f43[5]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2c65e87[5]));
  AL_DFF_X al_22aeac4e (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2c65e87[0]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_ff8d588f[0]));
  AL_DFF_X al_6d6ea447 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2c65e87[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_ff8d588f[1]));
  AL_DFF_X al_1164b4aa (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2c65e87[2]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_ff8d588f[2]));
  AL_DFF_X al_ddd1c04b (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2c65e87[3]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_ff8d588f[3]));
  AL_DFF_X al_bf982701 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2c65e87[4]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_ff8d588f[4]));
  AL_DFF_X al_34da7a0f (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2c65e87[5]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_ff8d588f[5]));
  AL_DFF_X al_5a8019b7 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_ff8d588f[0]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_e765e4ce[0]));
  AL_DFF_X al_1c037ee8 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_ff8d588f[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_e765e4ce[1]));
  AL_DFF_X al_73573309 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_ff8d588f[2]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_e765e4ce[2]));
  AL_DFF_X al_ba745b34 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_ff8d588f[3]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_e765e4ce[3]));
  AL_DFF_X al_b8b592bf (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_ff8d588f[4]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_e765e4ce[4]));
  AL_DFF_X al_146e96d3 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_ff8d588f[5]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_e765e4ce[5]));
  AL_DFF_X al_252ea06e (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_20075ca4[6]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_1bd38818[0]));
  AL_DFF_X al_8e33936e (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_20075ca4[7]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_1bd38818[1]));
  AL_DFF_X al_3918e059 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_1bd38818[0]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_bb164c48[0]));
  AL_DFF_X al_96c6b78 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_1bd38818[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_bb164c48[1]));
  AL_DFF_X al_f1db63d4 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_bb164c48[0]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_7a1b1ebf[0]));
  AL_DFF_X al_fdf401f2 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_bb164c48[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_7a1b1ebf[1]));
  AL_DFF_X al_b9877cbc (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7a1b1ebf[0]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_78084675[0]));
  AL_DFF_X al_d38326ed (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_7a1b1ebf[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_78084675[1]));
  AL_DFF_X al_39ebc759 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_78084675[0]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_9829b3b7[0]));
  AL_DFF_X al_58535df1 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_78084675[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_9829b3b7[1]));
  AL_DFF_X al_fd544ba8 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_8aaaf100[0]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_6790cfef[0]));
  AL_DFF_X al_40ebe0d4 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_8aaaf100[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_6790cfef[1]));
  AL_DFF_X al_b4cd3408 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_8aaaf100[2]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_6790cfef[2]));
  AL_DFF_X al_16607eff (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_8aaaf100[3]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_6790cfef[3]));
  AL_DFF_X al_2e1082f (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_8aaaf100[4]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_6790cfef[4]));
  AL_DFF_X al_96f1f8a7 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_9829b3b7[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_4f8d039a[1]));
  AL_DFF_X al_f488aa32 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_4f8d039a[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2bbe55df[1]));
  AL_DFF_X al_286967dc (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_75776e99[0]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(wave_sin[0]));
  AL_DFF_X al_25e9fff5 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_bc5c8fc3[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(wave_sin[1]));
  AL_DFF_X al_4376c392 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_bc5c8fc3[2]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(wave_sin[2]));
  AL_DFF_X al_549078f7 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_bc5c8fc3[3]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(wave_sin[3]));
  AL_DFF_X al_aa29b77f (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_bc5c8fc3[4]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(wave_sin[4]));
  AL_DFF_X al_f61e0c79 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_bc5c8fc3[5]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(wave_sin[5]));
  AL_DFF_X al_cd459a96 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_bc5c8fc3[6]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(wave_sin[6]));
  AL_DFF_X al_9f40c8 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_bc5c8fc3[7]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(wave_sin[7]));
  AL_DFF_X al_16ad90bc (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_6790cfef[0]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_8378b540[0]));
  AL_DFF_X al_e1044ec0 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_6790cfef[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_8378b540[1]));
  AL_DFF_X al_16da6de4 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_6790cfef[2]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_8378b540[2]));
  AL_DFF_X al_e819e904 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_6790cfef[3]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_8378b540[3]));
  AL_DFF_X al_4990808d (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_6790cfef[4]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_8378b540[4]));
  AL_DFF_X al_5e904a35 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_8378b540[0]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_7c6da17f[0]));
  AL_DFF_X al_116f1db3 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_d0d95c2b[0]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_7c6da17f[1]));
  AL_DFF_X al_6c993e82 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_d0d95c2b[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_7c6da17f[2]));
  AL_DFF_X al_23963ea6 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_d0d95c2b[2]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_7c6da17f[3]));
  AL_DFF_X al_6c25cf29 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_d0d95c2b[3]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_7c6da17f[4]));
  AL_DFF_X al_e7cc423c (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_d0d95c2b[4]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_7c6da17f[5]));
  AL_DFF_X al_2c6ea385 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_d0d95c2b[5]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_7c6da17f[6]));
  AL_DFF_X al_cbbb4490 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_e1c1520b[0]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_75776e99[0]));
  AL_DFF_X al_30153836 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_e1c1520b[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_75776e99[1]));
  AL_DFF_X al_37ead40d (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_e1c1520b[2]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_75776e99[2]));
  AL_DFF_X al_7625712c (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_e1c1520b[3]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_75776e99[3]));
  AL_DFF_X al_2531de5d (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_e1c1520b[4]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_75776e99[4]));
  AL_DFF_X al_2ccbdc6d (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_e1c1520b[5]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_75776e99[5]));
  AL_DFF_X al_2c62c395 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_e1c1520b[6]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_75776e99[6]));
  AL_DFF_X al_d574702c (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_4c12045b[24]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2adbf503[24]));
  AL_DFF_X al_c40abbb9 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_4c12045b[25]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2adbf503[25]));
  AL_DFF_X al_f44b6762 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_4c12045b[26]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2adbf503[26]));
  AL_DFF_X al_7e86e513 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_4c12045b[27]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2adbf503[27]));
  AL_DFF_X al_5cd26eed (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_4c12045b[28]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2adbf503[28]));
  AL_DFF_X al_339f6b0e (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_4c12045b[29]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2adbf503[29]));
  AL_DFF_X al_eeda67cf (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_4c12045b[30]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2adbf503[30]));
  AL_DFF_X al_18d03100 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_4c12045b[31]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2adbf503[31]));
  AL_DFF_X al_71b1275f (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2adbf503[24]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2b6fc17c[24]));
  AL_DFF_X al_8abb1dc0 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2adbf503[25]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2b6fc17c[25]));
  AL_DFF_X al_ffbcf3 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2adbf503[26]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2b6fc17c[26]));
  AL_DFF_X al_c42575cd (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2adbf503[27]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2b6fc17c[27]));
  AL_DFF_X al_95276817 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2adbf503[28]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2b6fc17c[28]));
  AL_DFF_X al_e27d67aa (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2adbf503[29]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2b6fc17c[29]));
  AL_DFF_X al_551037ca (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2adbf503[30]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2b6fc17c[30]));
  AL_DFF_X al_7f606122 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2adbf503[31]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_2b6fc17c[31]));
  AL_DFF_X al_2e8a2570 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2b6fc17c[24]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_20075ca4[0]));
  AL_DFF_X al_4c05617e (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2b6fc17c[25]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_20075ca4[1]));
  AL_DFF_X al_7cbb1b5f (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2b6fc17c[26]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_20075ca4[2]));
  AL_DFF_X al_1851373 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2b6fc17c[27]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_20075ca4[3]));
  AL_DFF_X al_6ef4721c (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2b6fc17c[28]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_20075ca4[4]));
  AL_DFF_X al_ef14836c (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2b6fc17c[29]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_20075ca4[5]));
  AL_DFF_X al_29111b42 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2b6fc17c[30]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_20075ca4[6]));
  AL_DFF_X al_9e5c600b (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_2b6fc17c[31]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_20075ca4[7]));
  AL_DFF_X al_1ec04f80 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_3bc6703c[1]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_50d27df2[1]));
  AL_DFF_X al_ec2280f (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_3bc6703c[2]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_50d27df2[2]));
  AL_DFF_X al_ecb5afd4 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_3bc6703c[3]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_50d27df2[3]));
  AL_DFF_X al_d15fb662 (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_3bc6703c[4]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_50d27df2[4]));
  AL_DFF_X al_e22992ea (
    .ar(~rst_n),
    .as(1'b0),
    .clk(clk),
    .d(al_3bc6703c[5]),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(al_50d27df2[5]));
  AL_MAP_LUT3 #(
    .EQN("(C@(B*A))"),
    .INIT(8'h78))
    al_d6aba0b6 (
    .a(al_2bbe55df[1]),
    .b(al_75776e99[0]),
    .c(al_75776e99[1]),
    .o(al_bc5c8fc3[1]));
  AL_MAP_LUT4 #(
    .EQN("(D@(A*~(~C*~B)))"),
    .INIT(16'h57a8))
    al_bba87de2 (
    .a(al_2bbe55df[1]),
    .b(al_75776e99[0]),
    .c(al_75776e99[1]),
    .d(al_75776e99[2]),
    .o(al_bc5c8fc3[2]));
  AL_MAP_LUT3 #(
    .EQN("(C@(B*~A))"),
    .INIT(8'hb4))
    al_a8d32043 (
    .a(al_c4992340),
    .b(al_2bbe55df[1]),
    .c(al_75776e99[3]),
    .o(al_bc5c8fc3[3]));
  AL_MAP_LUT4 #(
    .EQN("(D@(B*~(~C*A)))"),
    .INIT(16'h3bc4))
    al_c61147f4 (
    .a(al_c4992340),
    .b(al_2bbe55df[1]),
    .c(al_75776e99[3]),
    .d(al_75776e99[4]),
    .o(al_bc5c8fc3[4]));
  AL_MAP_LUT5 #(
    .EQN("(E@(B*~(~D*~C*A)))"),
    .INIT(32'h333bccc4))
    al_b08d86be (
    .a(al_c4992340),
    .b(al_2bbe55df[1]),
    .c(al_75776e99[3]),
    .d(al_75776e99[4]),
    .e(al_75776e99[5]),
    .o(al_bc5c8fc3[5]));
  AL_MAP_LUT6 #(
    .EQN("(F@(B*~(~E*~D*~C*A)))"),
    .INIT(64'h3333333bccccccc4))
    al_4326cc2d (
    .a(al_c4992340),
    .b(al_2bbe55df[1]),
    .c(al_75776e99[3]),
    .d(al_75776e99[4]),
    .e(al_75776e99[5]),
    .f(al_75776e99[6]),
    .o(al_bc5c8fc3[6]));
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*~A)"),
    .INIT(8'h01))
    al_dfe3ec93 (
    .a(al_75776e99[0]),
    .b(al_75776e99[1]),
    .c(al_75776e99[2]),
    .o(al_c4992340));
  AL_MAP_LUT6 #(
    .EQN("(B*~(~F*~E*~D*~C*A))"),
    .INIT(64'hccccccccccccccc4))
    al_41479871 (
    .a(al_c4992340),
    .b(al_2bbe55df[1]),
    .c(al_75776e99[3]),
    .d(al_75776e99[4]),
    .e(al_75776e99[5]),
    .f(al_75776e99[6]),
    .o(al_bc5c8fc3[7]));

endmodule 

