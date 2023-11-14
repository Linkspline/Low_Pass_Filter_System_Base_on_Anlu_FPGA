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

`timescale 1 ns/1 ps

`define PH1

//***********************//
module FDPE (
    input C,
    input CE,
    input PRE,
    input D,
    output Q
    );

    parameter INIT = 1'b1;

    reg q_o;
    initial q_o = INIT;
    assign Q = q_o;

    always @ (posedge PRE or posedge C) begin
     if (PRE)
      q_o <= 1'b1;
     else if (CE)
      q_o <= D;
    end

    specify
     (posedge PRE => (Q +: 1'b1)) = (0, 0);
     if (!PRE && CE)
      (posedge C => (Q +: D)) = (100, 100);
    endspecify

endmodule


//***********************//
module FD (
    input C,
    input D,
    output Q
    );

    parameter INIT = 1'b0;

    reg q_o;
    initial q_o = INIT;
    assign Q = q_o;

    always @ (posedge C) 
      q_o <= D;

    specify
     (posedge C => (Q +: D)) = (0, 0);
    endspecify

endmodule

//***********************//
/* module BUFGMUX(
    input I0,
    input I1,
    input S,
    output O
    );

    parameter CLK_SEL_TYPE = "SYNC";
    localparam clk_sel_in = (CLK_SEL_TYPE == "ASYNC") ? "1" : "0";

    `ifdef AL3
     AL_LOGIC_BUFGMUX #(.INIT_OUT(clk_sel_in))
                  BUFGMUX_AL3(.o(O),
                              .i0(I0),
                              .i1(I1),
                              .s(S)
                             );
    `endif                       

    `ifdef EG4
     EG_LOGIC_BUFGMUX #(.INIT_OUT(clk_sel_in))
                  BUFGMUX_EG4(.o(O),
                              .i0(I0),
                              .i1(I1),
                              .s(S)
                             );
    `endif

    `ifdef EF2
     EF2_LOGIC_BUFGMUX #(.INIT_OUT(clk_sel_in))
                   BUFGMUX_EF2(.o(O),
                               .i0(I0),
                               .i1(I1),
                               .s(S)
                              );
    `endif

endmodule

 */
 
//***********************//
module BUFG(
    input I,
    output O
    );

    `ifdef AL3
     AL_LOGIC_BUFG BUFG_AL3(.o(O),.i(I));
    `endif

    `ifdef EG4
      EG_LOGIC_BUFG BUFG_EG4(.o(O),.i(I));
    `endif

    `ifdef EF1
      ELF_LOGIC_BUFG BUFG_ELF(.o(O),.i(I));
    `endif

    `ifdef EF2
      EF2_LOGIC_BUFG BUFG_EF2(.o(O),.i(I));
    `endif

    `ifdef PH1
      PH1_LOGIC_BUFG BUFG_PH1(.o(O),.i(I));
    `endif
    
endmodule


