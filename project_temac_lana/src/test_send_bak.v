// 测试 给client_loopback提供输入信号，是的借用这个模块发送特定的数据
// （以下信号均对标client_loopback）
// 以rx_ll_clock为时钟
module test_send(
    input clk,
    input rst_n,

    output reg [7:0] data_out,
    output reg sof,
    output reg eof,
    output src_rdy,
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
            if (send_cont == 1500) send_cont <= 0;
            else send_cont <= send_cont + 1;
        end
    end
end
reg [119:0] HEAD = 120'h00002b67beceaada02030405060800;
reg [3:0] head_cont;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rd_enable <= 0;
        sof<=0;
        eof<=0;
        head_cont <= 0;
        dst_rdy <=0;
        data_out <=0;
    end
    else begin
        if (afull && ~rd_enable) begin
            dst_rdy<=1;
            if (head_cont==14) begin
                rd_enable<=1;
                head_cont <= 0;
            end
            else head_cont <= head_cont+1;
            
            if (head_cont > 0) begin
                data_out <= HEAD[(14-head_cont)*8+:8];  // for debug
                sof<=0;
            end
            else sof<=1;
        end
        if (data_valid) data_out <= dout;
        if (aempty || send_cont==1500) begin
            rd_enable<=0;
            dst_rdy<=0;
            eof<=1;
        end
        else eof<=0;
    end
end
assign src_rdy = dst_rdy;

// assign data_out = data_valid? dout: HEAD[head_cont*8+:8];

endmodule