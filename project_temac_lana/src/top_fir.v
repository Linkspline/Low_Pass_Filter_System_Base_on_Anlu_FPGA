`timescale 1ns/1ps

module top_fir( 
input        I_sysclk_p,
input        I_reset_n,

input         DOUTA_IN, // FMC_LA11_P
input         DOUTB_IN, // FMC_LA07_N

// 滤波器输出
output [31:0] A1_fltres,
output reg clk_fltres,
output [11:0] A1_Result,

// 配置输出信号
output wire[2:0] AD_A2_A0,
output wire   CS,
output wire    SCK,
output wire    sck_test,
output wire         RD_DONE,
output wire[2:0]  Vdd_fmc_adj
// output wire[11:0] A2_Result,
// output wire[11:0] B2_Result,
// output wire[11:0] A3_Result,
// output wire[11:0] B3_Result,
// output wire[11:0] A4_Result,
// output wire[11:0] B4_Result,
// output wire[11:0] A5_Result,
// output wire[11:0] B5_Result,
// output wire[11:0] A6_Result,
// output wire[11:0] B6_Result,
);
// reg        clk_fltres;
reg [8:0] cont;
parameter CONT_MAX = 500;
always @(posedge I_sysclk_p or negedge I_reset_n) begin
    if (!I_reset_n) begin
        clk_fltres<=0;
        cont<=0;
    end
    else begin
        if (cont==CONT_MAX) begin
            clk_fltres<=~clk_fltres;
            cont <=0; 
        end else begin
            cont<=cont+1;
        end
    end
end


// wire        pll_lock;
// //pll instance
// mypll u_mypll(
// .reset       (1'b0),
// .refclk      (I_sysclk_p),
// .clk_fltres_out    (clk_fltres),// 25MHz
// .lock        (pll_lock)
// );

assign Vdd_fmc_adj = 3'd7;

AD7266_Read u_AD7266(
.sys_clk    (I_sysclk_p),//SPI时钟是sys_clk的四分频
.rst_n      (I_reset_n),
.OUTA_IN    (DOUTA_IN),//数据输出1
.OUTB_IN    (DOUTB_IN),//数据输出2
.CS         (CS),
.SCK        (SCK),
.AD_A2_A0   (AD_A2_A0),
.RD_DONE    (RD_DONE),
.A1_Result  (A1_Result)
);
wire [31:0] A1_fltres_32;

fir_filter u_fir_filter (
    .i_fir_data_in({4'b0000,A1_Result}),
    .i_fir_en(1),
    // .i_tap_wr_en(),
    // .i_tap_wr_addr(),
    // .i_tap_wr_data(),
    .i_clk(clk_fltres),
    .i_rst_n(I_reset_n),
    .o_fir_data_out (A1_fltres_32)
);

assign A1_fltres = (A1_fltres_32[31:14]);
// assign A1_fltres = ((A1_fltres_32[31:14]-82)<<2)+(A1_fltres_32[31:14]-82);

assign sck_test = SCK;
endmodule
