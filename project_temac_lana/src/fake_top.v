module fake_top(
    input clk,
    input rst_n,
    output [31:0] A1_fltres,
    output clk_fltres,
    output [7:0] A1_Result
);

wire   DOUTA_IN ;
wire   DOUTB_IN ;

// top_fir Outputs
wire  [2:0] AD_A2_A0                   ;
wire  CS                                   ;
wire  SCK                                  ;
wire  sck_test                             ;
wire  RD_DONE                              ;
wire  [2:0]  Vdd_fmc_adj               ;

// 25MHz -> 100MHz
wire clk0;
// wire        pll_lock;
// mypll u_my_pll(
//     .refclk(clk),
//     .reset(~rst_n),
//     .lock(pll_lock),
//     .clk0_out(clk0)
// );
assign clk0=clk;

singal_gen u_singal_gen(
    .clk(clk0),
    .rst_n(rst_n),
    .SCK(SCK),
    .CS(CS),
    .RD_DONE(RD_DONE),
    .DOUTA(DOUTA_IN),
    .DOUTB(DOUTB_IN)
);


top_fir  u_top_fir (
    .I_sysclk_p              ( clk0               ),
    .I_reset_n               ( rst_n                ),
    .DOUTA_IN                ( DOUTA_IN                 ),
    .DOUTB_IN                ( DOUTB_IN                 ),

    .AD_A2_A0                ( AD_A2_A0       ),
    .CS                      ( CS                       ),
    .SCK                     ( SCK                      ),
    .sck_test                ( sck_test                 ),
    .RD_DONE                 ( RD_DONE                  ),
    .Vdd_fmc_adj             ( Vdd_fmc_adj   ),
    .A1_fltres               (A1_fltres),
    .clk_fltres              (clk_fltres),
    .A1_Result               (A1_Result)
);

endmodule