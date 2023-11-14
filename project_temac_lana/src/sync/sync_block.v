// ===========================================================================
// Copyright (c) 2011-2020 Anlogic Inc. All Right Reserved.
//
// TEL: 86-21-61633787
// WEB: http://www.anlogic.com/
// ===========================================================================
//
//
//  
//
//
// ===========================================================================

module sync_block(clk, data_in, data_out);
   
   parameter [1:0] INITIALISE = 2'b00;
   
   input           clk;
   input           data_in;
   output          data_out;
   
   
   // 内部信号
   wire            data_sync1;
     
   
   FD #(INITIALISE[0]) data_sync(.C(clk), .D(data_in), .Q(data_sync1));
   
   
   FD #(INITIALISE[0]) data_sync_reg(.C(clk), .D(data_sync1), .Q(data_out));
   
endmodule
