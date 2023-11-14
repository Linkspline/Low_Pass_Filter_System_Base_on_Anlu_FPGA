module singal_gen(
    input clk, // 时钟输入
    input rst_n,
    input SCK,
    input CS,
    input RD_DONE,
    output reg DOUTA,
    output reg DOUTB
);

wire [7:0] singal_out;
wire [7:0] singal_out0;
wire [7:0] singal_out1;
reg [4:0] count14;

dds_gen u_dds_gen(
    .clk(clk),
    .rst_n(rst_n),
    .wave_sin(singal_out0)
);
dds_gen1 u_dds_gen1(
    .clk(clk),
    .rst_n(rst_n),
    .wave_cos(singal_out1)
);
assign singal_out = ((singal_out0>127?(singal_out0-127):(singal_out0+127)) + (singal_out1>127?(singal_out1-127):(singal_out1+127)))>>1; // 6k * 1k
// assign singal_out = (singal_out1>127?(singal_out1-127):(singal_out1+127)); // 6k
// assign singal_out = (singal_out0>127?(singal_out0-127):(singal_out0+127)); // 1k


reg [13:0] shift_reg;
reg CS_pre;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg<=0;
        CS_pre<=0;
    end 
    else begin
        CS_pre<=CS;
        if (CS_pre & !CS) begin
            shift_reg<={6'b000000,singal_out};
        end
    end
end

//地址控制
always @(negedge SCK or negedge rst_n)
begin
    if(!rst_n) begin
        count14<=13;
    end
    else if (count14==0) begin
        count14<=13;
    end
    else count14<=count14-1;
end
always @(negedge SCK or negedge rst_n)
begin
    if(!rst_n) begin 
        DOUTA<=0;
        DOUTB<=0;
    end else if (~CS & ~RD_DONE) begin
        DOUTA<=shift_reg[count14-1];
        DOUTB<=shift_reg[count14-1];
    end
end
// assign DOUTA=shift_reg[count14];
// assign DOUTB=DOUTA;

endmodule
