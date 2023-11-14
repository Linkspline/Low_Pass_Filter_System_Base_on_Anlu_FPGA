module AD7266_Read 
(
	input sys_clk,
	input rst_n,

	input OUTA_IN,//数据输出1
	input OUTB_IN,//数据输出2
	output reg CS,
	output reg SCK,
	output reg[2:0] AD_A2_A0, // 恒为0 
	output AD_RANGE,
	output AD_DIFF,	
	output RD_DONE,
	output reg[11:0] A1_Result,
	output reg[11:0] B1_Result,
	output reg[11:0] A2_Result,
	output reg[11:0] B2_Result,
	output reg[11:0] A3_Result,
	output reg[11:0] B3_Result,
	output reg[11:0] A4_Result,
	output reg[11:0] B4_Result,
	output reg[11:0] A5_Result,
	output reg[11:0] B5_Result,
	output reg[11:0] A6_Result,
	output reg[11:0] B6_Result

 // input[3:0] AD_A3_A0_OUT,
 //output reg[13:0] AD_Result_OUT
);
localparam count_MAX=16'd1;
reg[15:0] count_clk;
reg[15:0] CONVST_time;
reg [5:0] count_SCK;
reg spi_clk;
reg [5:0] count_spi_clk_P;
reg [5:0] count_spi_clk_N;
reg spi_rd_done;//读取结束标志位
reg [5:0] spi_state;
reg [27:0] A1B1_Result;
reg [27:0] A2B2_Result;
reg [27:0] A3B3_Result;
reg [27:0] A4B4_Result;
reg [27:0] A5B5_Result;
reg [27:0] A6B6_Result;

reg BUSY_PRE,READY_FLAG;

assign AD_RANGE=1'b0;
assign AD_DIFF=1'b1;
assign RD_DONE=spi_rd_done;
//第一步产生SPI通信时钟
always@(posedge sys_clk or negedge rst_n)//分频产生SPI模块总时钟和控制时钟
	begin
		if(!rst_n)
			begin
				count_clk<=16'd0;
				spi_clk<=1'b0;
			end
		else if(count_clk==count_MAX)		
			begin
				spi_clk<=~spi_clk;
				count_clk<=16'd0;				
			end
		else
			count_clk<=count_clk+16'd1;
	end
//产生SCK时钟信号
always @(negedge spi_clk or negedge rst_n)//产生SCK信号	
	begin 
		if(!rst_n)
			SCK=1'b1;
		else if(!CS)
			begin
				if(count_spi_clk_N==6'd27)
					SCK=1'b1;
				else
					begin
						SCK<=~SCK;//产生SCK信号
					end
			end
	  else SCK=1'b1;		
	end
always @(negedge spi_clk or negedge rst_n)//count_spi_clk_N控制
	begin
		if(!rst_n)
			begin
				count_spi_clk_N<=6'd0;
			end
		else if (!CS)
			begin
			  if(count_spi_clk_N==6'd27)
					count_spi_clk_N<=6'd0;
				else
					count_spi_clk_N<=count_spi_clk_N+6'd1;
			end
		else count_spi_clk_N<=6'd0;
	end	
always @(posedge spi_clk or negedge rst_n)//读取控制CS
	begin
		if(!rst_n)
			begin
				CS<=1'b1;	
			end
		else if(READY_FLAG==1'b1)
			begin
				CS<=1'b0;
			end
		else if (count_spi_clk_P==6'd26)
				CS<=1'b1;
	end
always @(posedge spi_clk or negedge rst_n)//count_spi_clk_P控制
	begin
		if(!rst_n)
			begin
				count_spi_clk_P<=6'd0;
			end
		else if (!CS)
			begin
			  if(count_spi_clk_P==6'd26)
					count_spi_clk_P<=6'd0;
				else
					count_spi_clk_P<=count_spi_clk_P+6'd1;
			end
		else count_spi_clk_P<=6'd0;
	end	
//always@(posedge spi_clk )//读取数据
always@(posedge SCK )//读取数据
	begin	
		 if(!CS)
			begin
				if(count_SCK<6'd14)
					begin
						case(AD_A2_A0)	
							3'd0:
								begin
									A1B1_Result[27-count_SCK]<=OUTA_IN;
									A1B1_Result[13-count_SCK]<=OUTB_IN;
								end
							3'd1:
								begin
									A2B2_Result[27-count_SCK]<=OUTA_IN;
									A2B2_Result[13-count_SCK]<=OUTB_IN;
								end
							3'd2:	
								begin
									A3B3_Result[27-count_SCK]<=OUTA_IN;
									A3B3_Result[13-count_SCK]<=OUTB_IN;
								end
							3'd3:	
								begin
									A4B4_Result[27-count_SCK]<=OUTA_IN;
									A4B4_Result[13-count_SCK]<=OUTB_IN;
								end
							3'd4:	
								begin
									A5B5_Result[27-count_SCK]<=OUTA_IN;
									A5B5_Result[13-count_SCK]<=OUTB_IN;
								end
							3'd5:	
								begin
									A6B6_Result[27-count_SCK]<=OUTA_IN;
									A6B6_Result[13-count_SCK]<=OUTB_IN;
								end
							default:;
						endcase
					end	
			end
	end
	
always@(negedge SCK or negedge rst_n)	//SCK脉冲数控制
	begin
		if(!rst_n)
			begin
				count_SCK<=6'd0;
			end
		else if(count_SCK==6'd13)
			begin
				count_SCK<=6'd0;
			end
	  else 
			count_SCK<=count_SCK+6'd1;
	end
	
always@(posedge spi_clk or negedge rst_n)//读取完成标志位控制
	begin
		if(!rst_n)
			begin
				spi_rd_done<=1'b0;
			end
		else if(count_spi_clk_N==6'd26)
			spi_rd_done<=1'b1;
		else if(CS==1'b1)
			spi_rd_done<=1'b0;
	end
	
always@(posedge spi_clk or negedge rst_n)//保存到各自的结果寄存器
	begin
		if(!rst_n)
			begin
				A1_Result<=12'd0;
				B1_Result<=12'd0;
				A2_Result<=12'd0;
				B2_Result<=12'd0;
				A3_Result<=12'd0;
				B3_Result<=12'd0;
				A4_Result<=12'd0;
				B4_Result<=12'd0;
				A5_Result<=12'd0;
				B5_Result<=12'd0;
				A6_Result<=12'd0;
				B6_Result<=12'd0;
			end
		else if(spi_rd_done==1'b1)
			begin
				case(AD_A2_A0)
					3'd0:
						begin
							A1_Result<=A1B1_Result[25:14];	
							B1_Result<=A1B1_Result[11:0];			
						end
					3'd1:
						begin
							A2_Result<=A2B2_Result[25:14];	
							B2_Result<=A2B2_Result[11:0];
						end	
					3'd2:
						begin
							A3_Result<=A3B3_Result[25:14];	
							B3_Result<=A3B3_Result[11:0];
						end
					3'd3:
						begin
							A4_Result<=A4B4_Result[25:14];	
							B4_Result<=A4B4_Result[11:0];
						end
					3'd4:
						begin
							A5_Result<=A5B5_Result[25:14];	
							B5_Result<=A5B5_Result[11:0];
						end
					3'd5:
						begin
							A6_Result<=A6B6_Result[25:14];	
							B6_Result<=A6B6_Result[11:0];
						end
					default:;	
				endcase
			end		
	end
/*
always@(AD_Result_OUT or rst_n or A1_Result or A2_Result or A3_Result
or A4_Result or A5_Result or A6_Result or B1_Result or B2_Result or B3_Result or B4_Result or B5_Result or B6_Result )//模块输出采样结果
	begin
		if(!rst_n)
			begin
				 AD_Result_OUT<=16'd0;
			end	
		else
			begin
				case(AD_A3_A0_OUT)
				4'h0:AD_Result_OUT<=A1_Result;
				4'h1:AD_Result_OUT<=A2_Result;
				4'h2:AD_Result_OUT<=A3_Result;
				4'h3:AD_Result_OUT<=A4_Result;
				4'h4:AD_Result_OUT<=A5_Result;
				4'h6:AD_Result_OUT<=A6_Result;
				4'h7:AD_Result_OUT<=B1_Result;
				4'h8:AD_Result_OUT<=B2_Result;
				4'h9:AD_Result_OUT<=B3_Result;
				4'hA:AD_Result_OUT<=B4_Result;
				4'hB:AD_Result_OUT<=B5_Result;
				4'hC:AD_Result_OUT<=B6_Result;
				default:;
				endcase
			end
	end
*/

always@(posedge spi_clk  or negedge rst_n)
	begin
		if(!rst_n)
			begin
				CONVST_time<=16'd0;
			end
		else if(CONVST_time==16'd180)
			begin
				CONVST_time<=16'd0;
			end
		else if(CONVST_time>16'd180)
				CONVST_time<=16'd0;
		else 
			CONVST_time<=CONVST_time+16'd1;
	end
always@(posedge spi_clk  or negedge rst_n)
	begin
		if(!rst_n)
			begin
				AD_A2_A0<=3'b000;
			end
		else
			begin
				case(CONVST_time)
				16'd0:
					AD_A2_A0<=3'b000;					
				16'd30:
					AD_A2_A0<=3'b000;
				16'd60:
					AD_A2_A0<=3'b000;
				16'd90:
					AD_A2_A0<=3'b000;
				16'd120:
					AD_A2_A0<=3'b000;
				16'd150:
					AD_A2_A0<=3'b000;
					// 16'd0:
					// 	AD_A2_A0<=3'b000;					
					// 16'd30:
					// 	AD_A2_A0<=3'b001;
					// 16'd60:
					// 	AD_A2_A0<=3'b010;
					// 16'd90:
					// 	AD_A2_A0<=3'b011;
					// 16'd120:
					// 	AD_A2_A0<=3'b100;
					// 16'd150:
					//    	AD_A2_A0<=3'b101;
					default:;
				endcase
			end		
	end
	
always@(posedge spi_clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				READY_FLAG<=1'b0;
			end
		else
			begin
				case(CONVST_time)
					16'd1:READY_FLAG<=1'b1;					
					16'd2:READY_FLAG<=1'b0;
					16'd31:READY_FLAG<=1'b1;	
					16'd32:READY_FLAG<=1'b0;
					16'd61:READY_FLAG<=1'b1;	
					16'd62:READY_FLAG<=1'b0;
					16'd91:READY_FLAG<=1'b1;	
					16'd92:READY_FLAG<=1'b0;
					16'd121:READY_FLAG<=1'b1;
					16'd122:READY_FLAG<=1'b0;
					16'd151:READY_FLAG<=1'b1;
					16'd152:READY_FLAG<=1'b0;
					default:;
				endcase
			end		
	end	
endmodule 