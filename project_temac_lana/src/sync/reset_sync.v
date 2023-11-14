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


module reset_sync 
#(
  parameter INITIALISE = 2'b11
)
(
   input       reset_in,
   input       clk,
   input       enable,
   output      reset_out
);


wire  reset_stage1;
wire  reset_stage2;

  FDPE #(
   .INIT (INITIALISE[0])
  ) reset_sync1 (
  .C  (clk), 
  .CE (enable),
  .PRE(reset_in),
  .D  (1'b0),
  .Q  (reset_stage1) 
  );
  
  FDPE #(
   .INIT (INITIALISE[1])
  ) reset_sync2 (
  .C  (clk), 
  .CE (enable),
  .PRE(reset_in),
  .D  (reset_stage1),
  .Q  (reset_stage2) 
  );


assign reset_out = reset_stage2;



endmodule
