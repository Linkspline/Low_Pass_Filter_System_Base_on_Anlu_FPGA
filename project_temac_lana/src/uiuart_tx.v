`timescale 1ns / 1ns 

module uiuart_tx#
(
 parameter integer BAUD_DIV     = 10416                           //设置采样系数 （时钟/采样率-1）
)
(
    input        I_clk,       //系统时钟输入
    input        I_uart_rstn, //系统复位输入
    input        I_uart_wreq, //发送数据请求   
    input [7:0]  I_uart_wdata,//发送数据      
    output       O_uart_wbusy,//发送状态忙，代表正在发送数据   
    output       O_uart_tx    //uart tx 发送总线
);

localparam  UART_LEN = 4'd10; //设置uart 发送的bit数量为10，代表1bit起始位，8bits数据,1bit停止位
wire        bps_en ; //发送使能
reg         uart_wreq_r   = 1'b0;//寄存一次I_uart_wreq
reg         bps_start_en    = 1'b0; //波特率计数器启动使能，也是发送启动使能
reg [13:0]  baud_div        = 14'd0;//波特率计数器
reg [9 :0]  uart_wdata_r  = 10'h3ff;//寄存I_uart_wreq
reg [3 :0]  tx_cnt          = 4'd0;//计数发送了多少bits

assign O_uart_tx = uart_wdata_r[0];//总线上的数据，始终是uart_wdata_r[0]

assign O_uart_wbusy = bps_start_en;//总线忙标志，即是bps_start_en为有效，即当总线忙于发送，总线忙

// 发送使能
assign bps_en = (baud_div == BAUD_DIV);                 //产生一次发送使能信号，条件是baud_div == BAUD_DIV，波特率计数达成

//波特率计数器
always@(posedge I_clk )begin
    if((I_uart_rstn== 1'b0) || (I_uart_wreq==1'b1&uart_wreq_r==1'b0))begin
        baud_div <= 14'd0;
    end
    else begin
        if(bps_start_en && baud_div < BAUD_DIV)        //bps_start_en的信号拉高，表示开始发送 
           baud_div <= baud_div + 1'b1;                //且baud_div < BAUD_DIV波特率计算，未达到波特率baud_div+1
        else 
            baud_div <= 14'd0;                         //达到清零
    end
end

always@(posedge I_clk)begin
    uart_wreq_r <= I_uart_wreq;                           //寄存一次I_uart_wreq信号
end

//当I_uart_wreq从低电平变为高电平，启动发送
always@(posedge I_clk)begin
    if(I_uart_rstn == 1'b0)
        bps_start_en    <= 1'b0;                           //复位，计数清零
    else if(I_uart_wreq==1'b1&uart_wreq_r==1'b0)          //I_uart_wreq上升沿激活
        bps_start_en    <= 1'b1;                           //激活后将 bps_start_en拉高，传输开始
    else if(tx_cnt == UART_LEN)                            //tx_cnt用于计数当前发送的bits数量，当达到预定值UART_LEN
        bps_start_en    <= 1'b0;                           //将 bps_start_en拉低，传输结束
    else 
        bps_start_en    <= bps_start_en;                    
end

//发送bits计数器
always@(posedge I_clk)begin
    if(((I_uart_rstn== 1'b0) || (I_uart_wreq==1'b1&uart_wreq_r==1'b0))||(tx_cnt == 10))//当复位、启动发送、发送完成，重置tx_cnt
        tx_cnt <=4'd0;
    else if(bps_en && (tx_cnt < UART_LEN))   //tx_cnt计数器，每发送一个bit加1
        tx_cnt <= tx_cnt + 1'b1;
end

//uart发送并串移位控制器
always@(posedge I_clk)begin
    if((I_uart_wreq==1'b1&uart_wreq_r==1'b0)) //当发送请求有效，寄存需要发送的数据到uart_wdata_r
        uart_wdata_r  <= {1'b1,I_uart_wdata[7:0],1'b0};//寄存需要发送的数据，包括1bit 起始位，8bits数据，1bit停止位
    else if(bps_en && (tx_cnt < (UART_LEN - 1'b1)))                               //shift 9 bits
        uart_wdata_r <= {uart_wdata_r[0],uart_wdata_r[9:1]};                     //并串转换，将并行数据依次传输
    else 
        uart_wdata_r <= uart_wdata_r;
end   
endmodule
