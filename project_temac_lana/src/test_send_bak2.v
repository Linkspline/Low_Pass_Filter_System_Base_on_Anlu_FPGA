// 测试 给client_loopback提供输入信号，是的借用这个模块发送特定的数据
// （以下信号均对标client_loopback）
// 以rx_ll_clock为时钟
module test_send(
    input clk,
    input rst_n,

    output reg [7:0] data_out,
    output reg sof,
    output reg eof,
    output reg src_rdy,
    output reg dst_rdy
);

reg        clk0;
reg [8:0] cont;
parameter CONT_MAX = 500;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk0<=0;
        cont<=0;
    end
    else begin
        if (cont==CONT_MAX) begin
            clk0<=~clk0;
            cont <=0; 
        end else begin
            cont<=cont+1;
        end
    end
end

parameter DATA_MAX = 31'h7fffffff;
reg [31:0] send_data;
always @(posedge clk0 or negedge rst_n) begin
    if (!rst_n) begin
        send_data <= 0;
    end
    else begin
        if (send_data == DATA_MAX) send_data <= 0;
        else send_data <= send_data+1;
    end
end

reg rd_enable;
wire data_valid;
wire afull;
wire aempty;
wire [7:0] dout;
// 32位进，从低8位开始往外送
data_fifo u_data_fifo(
    .rst(~rst_n),
    .clkw(clk0),
    .clkr(clk),
    .we(1),
    .di(send_data),
    .re(rd_enable),
    .dout(dout),
    .valid(data_valid),
    .afull(afull),
    .aempty(aempty)
);

reg [10:0] send_cont;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        send_cont <= 0;
    end
    else begin
        if (data_valid) begin
            if (send_cont == 1420) send_cont <= 0;
            else send_cont <= send_cont + 1;
        end
    end
end
reg [111:0] HEAD = 112'hda0203040506002b67beceaa0800;
reg [3:0] head_cont;

//  状态机 
parameter [1:0] IDLE = 2'b00;
parameter [1:0] TX_HEAD = 2'b01;
parameter [1:0] TX_DATA = 2'b10;
parameter [1:0] TX_BUFF = 2'b11;
reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <=0 ;
        sof<=0;
        eof<=0;
        head_cont<=0;
        dst_rdy<=0;
        data_out <=0;
        rd_enable<=0;
        src_rdy<=0;
    end
    else begin
        case (state) 
            IDLE: begin
                eof<=0;
                dst_rdy<=0;;
                sof<=0;
                head_cont<=0;
                rd_enable<=0;
                src_rdy<=0;
                if (afull) begin
                    data_out<=8'hFF;
                    state<= TX_HEAD;
                end
                else data_out<=0;
            end
            TX_HEAD: begin
                data_out <= HEAD[(13-head_cont)*8+:8];
                if (head_cont==13) begin
                    state <= TX_DATA;
                    head_cont <=0;
                    rd_enable<=1;
                end
                else head_cont <= head_cont+1;

                if (head_cont==0) sof <= 1;
                else sof<=0;
                dst_rdy<=1;
                src_rdy<=1;
            end
            TX_DATA: begin
                data_out <= dout;
                if (aempty || send_cont==1419) begin
                    state<= TX_BUFF;
                    rd_enable<=0;
                    eof<=1;
                end
            end
            TX_BUFF: begin
                src_rdy<=0;
                eof<=0;
                if (head_cont==15) begin // just for buffer to use head_cont
                    state <= IDLE;
                    dst_rdy<=0;
                    head_cont <=0;
                end
                else head_cont <= head_cont+1;
            end
        endcase
    end
end

// assign src_rdy = dst_rdy;

// assign data_out = data_valid? dout: HEAD[head_cont*8+:8];

endmodule