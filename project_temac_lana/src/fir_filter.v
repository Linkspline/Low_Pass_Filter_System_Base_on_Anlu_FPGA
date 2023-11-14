//////////////////////////////////////////////////////////////////////////////
// Project: 50th Order FIR Filter
// Creator: Yaseen Salah                                                  
// Date   : 10 Feb 2023                                                  
/////////////////////////////////////////////////////////////////////////////
module fir_filter
	#(  parameter ORDER	         = 50 ,
		parameter DATA_IN_WIDTH  = 16 ,
		parameter DATA_OUT_WIDTH = 32 ,
		parameter TAP_DATA_WIDTH = 16 ,
		parameter TAP_ADDR_WIDTH = 6  )
	(
		input  wire  signed [DATA_IN_WIDTH-1 : 0]   i_fir_data_in  ,
		input  wire                                 i_fir_en  	   ,
		// input  wire         			    i_tap_wr_en    ,
		// input  wire  	    [TAP_ADDR_WIDTH-1 : 0]  i_tap_wr_addr  , 
		// input  wire         [TAP_DATA_WIDTH-1 : 0]  i_tap_wr_data  , 
		input  wire                                 i_clk          ,
		input  wire                        	    i_rst_n        ,
		output reg   signed [DATA_OUT_WIDTH-1 : 0]  o_fir_data_out      
	);

//internal registers declaration as 2D-arrays for optimized hardware description 
reg signed [TAP_DATA_WIDTH-1 : 0] tap[ORDER : 0] ;
reg signed [DATA_IN_WIDTH-1  : 0] buffer[ORDER : 0] ;
reg signed [DATA_OUT_WIDTH-1 : 0] accumulator[ORDER : 0] ;

integer i ;

//51-taps block logic
always @(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n)
		begin
		//50th order fir coefficients
			tap[0]	<= 16'b 0000000001100000;
			tap[1]	<= 16'b 0000000001011111;
			tap[2]	<= 16'b 0000000001011110;
			tap[3]	<= 16'b 0000000001011100;
			tap[4]	<= 16'b 0000000001011000;
			tap[5]	<= 16'b 0000000001010000;
			tap[6]	<= 16'b 0000000001000110;
			tap[7]	<= 16'b 0000000000110111;
			tap[8]	<= 16'b 0000000000100111;
			tap[9]	<= 16'b 0000000000010110;
			tap[10]	<= 16'b 0000000000000111;
			tap[11]	<= 16'b 0000000000000000;
			tap[12]	<= 16'b 0000000000000010;
			tap[13]	<= 16'b 0000000000010100;
			tap[14]	<= 16'b 0000000000111000;
			tap[15]	<= 16'b 0000000001110001;
			tap[16]	<= 16'b 0000000010111110;
			tap[17]	<= 16'b 0000000100011111;
			tap[18]	<= 16'b 0000000110001110;
			tap[19]	<= 16'b 0000001000001000;
			tap[20]	<= 16'b 0000001010000011;
			tap[21]	<= 16'b 0000001011110111;
			tap[22]	<= 16'b 0000001101011101;
			tap[23]	<= 16'b 0000001110101100;
			tap[24]	<= 16'b 0000001111011110;
			tap[25]	<= 16'b 0000001111110000;
			tap[26]	<= 16'b 0000001111011110;
			tap[27]	<= 16'b 0000001110101100;
			tap[28]	<= 16'b 0000001101011101;
			tap[29]	<= 16'b 0000001011110111;
			tap[30]	<= 16'b 0000001010000011;
			tap[31]	<= 16'b 0000001000001000;
			tap[32]	<= 16'b 0000000110001110;
			tap[33]	<= 16'b 0000000100011111;
			tap[34]	<= 16'b 0000000010111110;
			tap[35]	<= 16'b 0000000001110001;
			tap[36]	<= 16'b 0000000000111000;
			tap[37]	<= 16'b 0000000000010100;
			tap[38]	<= 16'b 0000000000000010;
			tap[39]	<= 16'b 0000000000000000;
			tap[40]	<= 16'b 0000000000000111;
			tap[41]	<= 16'b 0000000000010110;
			tap[42]	<= 16'b 0000000000100111;
			tap[43]	<= 16'b 0000000000110111;
			tap[44]	<= 16'b 0000000001000110;
			tap[45]	<= 16'b 0000000001010000;
			tap[46]	<= 16'b 0000000001011000;
			tap[47]	<= 16'b 0000000001011100;
			tap[48]	<= 16'b 0000000001011110;
			tap[49]	<= 16'b 0000000001011111;
			tap[50]	<= 16'b 0000000001100000;

		end
	// else if(i_tap_wr_en && !i_fir_en) //preventing coeff change during the operation
	// 	begin
	// 		tap[i_tap_wr_addr] <= i_tap_wr_data ;
	// 	end
end

//51-buffers block logic
always @(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n)
		begin
			for (i=0 ; i<=ORDER ; i=i+1)
				begin
					buffer[i] <= 16'b0 ;
				end
		end
	else if (i_fir_en)
		begin
			buffer[0] <= i_fir_data_in ;
			for (i=0 ; i<ORDER ; i=i+1)
				begin
					buffer[i+1] <= buffer[i] ;
				end
		end
end

//51-accumulator block logic
always @(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n)
		begin
			for (i=0 ; i<=ORDER ; i=i+1)
				begin
					accumulator[i] <= 32'b0 ;
				end			
		end
	else if (i_fir_en) 
		begin
			for (i=0 ; i<=ORDER ; i=i+1)
				begin
					accumulator[i] <= buffer[i] * tap[i] ;
				end
		end
end

//output logic
always @(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n)
		begin
			o_fir_data_out <= 32'b0 ;
		end
	else if (i_fir_en)
		begin
			o_fir_data_out <= accumulator[0]  + accumulator[1] 
					+ accumulator[2]  + accumulator[3]
					+ accumulator[4]  + accumulator[5]
					+ accumulator[6]  + accumulator[7]
					+ accumulator[8]  + accumulator[9]
					+ accumulator[10] + accumulator[11]
					+ accumulator[12] + accumulator[13]
					+ accumulator[14] + accumulator[15]
					+ accumulator[16] + accumulator[17]
					+ accumulator[18] + accumulator[19]
					+ accumulator[20] + accumulator[21]
					+ accumulator[22] + accumulator[23]
					+ accumulator[24] + accumulator[25]
					+ accumulator[26] + accumulator[27]
					+ accumulator[28] + accumulator[29]
					+ accumulator[30] + accumulator[31]
					+ accumulator[32] + accumulator[33]
					+ accumulator[34] + accumulator[35]
					+ accumulator[36] + accumulator[37]
					+ accumulator[38] + accumulator[39]	
					+ accumulator[40] + accumulator[41]
					+ accumulator[42] + accumulator[43]
					+ accumulator[44] + accumulator[45]
					+ accumulator[46] + accumulator[47]
					+ accumulator[48] + accumulator[49]
					+ accumulator[50] ;					  				  
		end
end
 
endmodule
