/*********************uart_top UART串口环路测试*********************
1.uiuart_rx接收驱动，用于接收串口数据，当uart_rvalid_o代表uiuart_rx接收驱动
接收到了总线的有效数据
2.uiuart_tx发送驱动，用于发送数据，当S_I_uart_wreq为高电平，请求发送数据
环路测试中，用uart_rvalid_o = S_I_uart_wreq，使用接收的数据再转发出去uart_wdata _i = uart_wdata_o 
*********************************************************************/

`timescale 1ns / 1ns //仿真时钟刻度和精度

module uart_top#
(
parameter integer SYSCLKHZ =  25_000_000  //系统输入时钟频率参数
)
(
input  I_sysclk_p,//系统时钟输入
input  I_uart_rx,//uart rx接收信号
output O_uart_tx //uart tx发送信号
);


reg [11:0] rstn_cnt = 0;//上电后延迟复位
wire uart_rstn;//内部复位信号
wire uart_wreq,uart_rvalid;
wire [7:0]uart_wdata,uart_rdata;

assign uart_wreq  = uart_rvalid;//用uart rx接收数据有效的uart_rvalid信号，控制uart发送模块的发送请求
assign uart_wdata = uart_rdata; //接收的数据给发送模块发送

assign uart_rstn = rstn_cnt[11];//延迟复位设计，用计数器的高bit控制复位

//同步计数器实现复位
always @(posedge I_sysclk_p)begin
    if(rstn_cnt[11] == 1'b0)
        rstn_cnt <= rstn_cnt + 1'b1;
    else 
        rstn_cnt <= rstn_cnt;
end

//例化uart 发送模块
uiuart_tx#
(
.BAUD_DIV(SYSCLKHZ/115200-1)    
)
uart_tx_u 
(
.I_clk(I_sysclk_p),//系统时钟输入
.I_uart_rstn(uart_rstn), //系统复位
.I_uart_wreq(uart_wreq), //uart发送驱动的写请求信号，高电平有效
.I_uart_wdata(uart_wdata), //uart发送驱动的写数据
.O_uart_wbusy(),//uart 发送驱动的忙标志
.O_uart_tx(O_uart_tx)//uart 串行数据发送
);

//例化uart 接收
uiuart_rx#
(
.BAUD_DIV(SYSCLKHZ/115200-1)   
)
uart_rx_u 
(
.I_clk(I_sysclk_p), //系统时钟输入
.I_uart_rx_rstn(uart_rstn),//系统复位
.I_uart_rx(I_uart_rx), //uart 串行数据接收
.O_uart_rdata(uart_rdata), //uart 接收数据
.O_uart_rvalid(uart_rvalid)//uart 接收数据有效，当uart_rvalid_o =1'b1 uart_rdata_o输出的数据有效
);
    
endmodule

