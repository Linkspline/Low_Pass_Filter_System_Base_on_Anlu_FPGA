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

module rgmii_interface (
    
    // 同步复位
    input            tx_reset,
    input			 tx_reset90,   
    input            rx_reset,

    // 指示当前运行速度为10/100
    input            speed_10_100,

    // 以下端口是RGMII物理接口：这些端口将位于FPGA的引脚上
    output     [3:0] rgmii_txd,
    output           rgmii_tx_ctl,
    output           rgmii_txc,
    input      [3:0] rgmii_rxd,
    input            rgmii_rx_ctl,
    input            rgmii_rxc,

    // 以下信号为RGMII状态信号
    output reg       link_status,
    output reg [1:0] clock_speed,
    output reg       duplex_status,

    // 以下端口连接到 TEMAC核 的 内部GMII接口模块
    input            gmii_txc_en,
    input      [7:0] gmii_txd,
    input            gmii_tx_en,
    input            gmii_tx_er,
    output           gmii_crs,
    output           gmii_col,
    output     [7:0] gmii_rxd,
    output           gmii_rx_dv,
    output           gmii_rx_er,
    
    //发送时钟信号
    input            tx_clk,                // gtx_clk: 125mhz
    input			 tx_clk90,
    input            rgmii_txc_en,
    input            rgmii_txc_en_shift,
    
    // MAC核 和 客户端逻辑 的接收器时钟信号
    output           rx_rgmii_clk       //output： 125mhz（1gbps） 25mhz(100mbps)    2.5mhz(10mbps)
  );



  //----------------------------------------------------------------------------
  // 模块 内部 信号
  //----------------------------------------------------------------------------

 
  reg    [3:0] gmii_txd_falling;             // gmii_txd信号在tx_clk的下降沿锁存。
  wire         rgmii_txc_odelay;             // RGMII接收器时钟ODDR输出.
  wire         rgmii_tx_ctl_odelay;          // RGMII控制信号ODDR输出.
  wire   [3:0] rgmii_txd_odelay;             // RGMII数据ODDR输出.
  wire         rgmii_tx_ctl_int;             // 内部RGMII传输控制信号.
  wire         rgmii_rx_ctl_delay;
  wire   [3:0] rgmii_rxd_delay;
  wire         rgmii_rx_ctl_reg;             // 内部RGMII接收器控制信号.

  reg          tx_en_to_ddr;

  wire         gmii_rx_dv_reg;               
  wire         gmii_rx_er_reg;               
  wire   [7:0] gmii_rxd_reg;                 

  wire         inband_ce;                    //RGMII带内状态寄存器 使能输出信号
  wire         rgmii_rxc_int;


   //==============================================================================
   // RGMII 发送逻辑
   //==============================================================================

  //----------------------------------------------------------------------------
  // RGMII 发送器时钟管理：rgmii_txc
  //----------------------------------------------------------------------------
   // 产生 rgmii_txc 时钟.
   PH1_LOGIC_ODDR  rgmii_txc_ddr 
   (
      .q             (rgmii_txc_odelay), //output 125mhz（1gbps） 25mhz(100mbps)    2.5mhz(10mbps)
     .clk            (tx_clk),
     // .clk           (tx_clk90),
      .d0            (rgmii_txc_en_shift),
      .d1            (rgmii_txc_en),
      .rst           (tx_reset)
      //.rst           (tx_reset90)
   );

   // 延时输出2ns,以便将时钟边沿集中在rgmii_txd [3：0]有效窗口内。仿真0.285ns
   // EG_LOGIC_ODELAY 
   // #(
      // .OUTDEL  (1)
   // )
   // delay_rgmii_tx_clk 
   // (
      // .i       (rgmii_txc_odelay),
      // .o       (rgmii_txc)     //output 125mhz（1gbps） 25mhz(100mbps)    2.5mhz(10mbps)
   // );
   assign rgmii_txc = rgmii_txc_odelay;
   
   //---------------------------------------------------------------------------
   // RGMII 发送逻辑 : rgmii_txd
   //---------------------------------------------------------------------------
    // 1Gbps gmii_txd  8位有效; rgmii_txc双沿使能发送8位
    // 10/100Mbps gmii_txd 仅低四位有效，rgmii_txc双沿使能重复发送低四位
    // 1Gbps时，125mhz的rgmii_txc，上升沿发送低四位，下降沿发送高四位。 一个时钟周期8bit, 125*8=1Gbps
    // 100Mbps时，25mhz的rgmii_txc，上升沿发送低四位，下降沿发送低四位。 相当于一个时钟周期只发一个4bit, 25*4=100mbps
    // 10Mbps时同100mbps,数据有效位在每byte的低四位，虽然一个时钟周期重复发低四位，相当于一个时钟周期只发一个低4位。
    
   always @ (speed_10_100, gmii_txd)
   begin
      if (speed_10_100 == 1'b0) // 1Gbps gmii_txd  8位有效
         gmii_txd_falling     <= gmii_txd[7:4];
      else      // 10/100Mbps gmii_txd高四位无效，rgmii_txc双沿使能发送低四位
         gmii_txd_falling     <= gmii_txd[3:0];
   end

   genvar i;
   generate for (i=0; i<4; i=i+1)
     begin : txdata_out_bus
	 
		PH1_LOGIC_ODDR  rgmii_txd_out 
        (
        .q             (rgmii_txd_odelay[i]),
        .clk           (tx_clk),
        .d0            (gmii_txd[i]),
        .d1            (gmii_txd_falling[i]),
        .rst           (tx_reset)
        );

   // 延迟输出 2 ns； 仿真：0.175ns
		// EG_LOGIC_ODELAY 
        // #(
			// .OUTDEL  (0)
		// )
		// delay_rgmii_txd (
			// .i       (rgmii_txd_odelay[i]),
			// .o       (rgmii_txd[i])
		// );
	assign rgmii_txd[i] = rgmii_txd_odelay[i];
     end
   endgenerate


   //---------------------------------------------------------------------------
   // RGMII 发送逻辑 : rgmii_tx_ctl
   //---------------------------------------------------------------------------
   // 编码 rgmii ctl 信号
   assign rgmii_tx_ctl_int = gmii_tx_en ^ gmii_tx_er;

   // 需要逻辑以确保 错误信号 将在整个时钟相位内，将tx_ctl发送为低电平
   always @(speed_10_100 or gmii_tx_en or gmii_tx_er or rgmii_txc_en)
   begin
      if (speed_10_100)
         tx_en_to_ddr = gmii_tx_en & (!gmii_tx_er || rgmii_txc_en);
      else
         tx_en_to_ddr = gmii_tx_en;
   end
    
    // oDDR primitive
   PH1_LOGIC_ODDR  ctl_output 
   (
      .q             (rgmii_tx_ctl_odelay),
      .clk           (tx_clk),
      .d0            (tx_en_to_ddr),
      .d1            (rgmii_tx_ctl_int),
      .rst           (tx_reset)
   );

    // 延迟输出 2 ns； 仿真：0.175ns
   // EG_LOGIC_ODELAY 
   // #(
      // .OUTDEL  (0)
   // )
   // delay_rgmii_tx_ctl 
   // (
      // .i       (rgmii_tx_ctl_odelay),
      // .o       (rgmii_tx_ctl)
   // );
	assign rgmii_tx_ctl = rgmii_tx_ctl_odelay;

   //==============================================================================
   // RGMII 接收逻辑
   //==============================================================================

   //---------------------------------------------------------------------------
   // RGMII 接收逻辑：rgmii_rxc
   //---------------------------------------------------------------------------

   assign	rgmii_rxc_int = rgmii_rxc;      ////input 125mhz（1gbps） 25mhz(100mbps)    2.5mhz(10mbps)
   assign   rx_rgmii_clk  = rgmii_rxc_int;  // 内部信号给到输出端口
   
   
   //---------------------------------------------------------------------------
   // RGMII 接收逻辑：rgmii_rxd ---->  gmii_rxd_reg
   //---------------------------------------------------------------------------
    // 1Gbps gmii_rxd  8位有效; rgmii_rxc双沿使能接收8位
    // 10/100Mbps gmii_rxd 仅低四位有效，rgmii_rxc双沿使能接收高低四位数据相同
    // 1gbps时，125mhz的rgmii_rxc，上升沿接收四位数据（对应低4bit），下降沿接收四位数据（对应高4bit）。 一个时钟周期8bit, 125mhz*8=1gbps
    // 100mbps时，25mhz的rgmii_rxc，上升沿接收四位数据，下降沿接收四位数据（高四位和低四位数据相同）。 相当于单沿采样，一个时钟周期只收一个4bit（数据有效位在每byte的低四位：高低四位重复）, 25mhz*4=100mbps
    // 10mbps时同100mbps,虽然一个时钟周期上下沿重复接收相同四位数据，相当于一个时钟周期只收一个4bit。
     
   genvar j;
   generate for (j=0; j<4; j=j+1)
     begin : rxdata_bus
	
	// EG_LOGIC_IDELAY delay_rgmii_rxd 
    // (
      // .i       (rgmii_rxd[j]),
      // .o       (rgmii_rxd_delay[j])
      // );
	assign rgmii_rxd_delay[j]=rgmii_rxd[j];
     end
   endgenerate

   // Instantiate Double Data Rate Input flip-flops.
   // DDR_CLK_EDGE attribute specifies output data alignment from IDDR component

   genvar k;
   generate for (k=0; k<4; k=k+1)
     begin : rxdata_in_bus
	 
	 PH1_LOGIC_IDDR rgmii_rx_data_in 
     (
          .q0            (gmii_rxd_reg[k]),
          .q1            (gmii_rxd_reg[k+4]),
          .clk           (rgmii_rxc_int),
          .d             (rgmii_rxd_delay[k]),
          .rst           (1'b0)
       );

     
     end
   endgenerate
   
   //---------------------------------------------------------------------------
   // RGMII 接收逻辑：rgmii_rx_ctl ------> gmii_rx_dv、gmii_rx_er
   //---------------------------------------------------------------------------
	
	// EG_LOGIC_IDELAY delay_rgmii_rx_ctl 
    // (
      // .i       (rgmii_rx_ctl),
      // .o       (rgmii_rx_ctl_delay)
      // );
	  assign rgmii_rx_ctl_delay = rgmii_rx_ctl;
 
    PH1_LOGIC_IDDR rgmii_rx_ctl_in 
    (
          .q0            (gmii_rx_dv_reg),
          .q1            (rgmii_rx_ctl_reg),
          .clk           (rgmii_rxc_int),
          .d             (rgmii_rx_ctl_delay),
          .rst           (1'b0)
       );


   // 解码 gmii_rx_er signal
   assign gmii_rx_er_reg = gmii_rx_dv_reg ^ rgmii_rx_ctl_reg;


  //----------------------------------------------------------------------------
  // 接收逻辑：内部信号给到输出端口：gmii_rxd、gmii_rx_dv、gmii_rx_er、gmii_col、gmii_crs
  //----------------------------------------------------------------------------

  assign gmii_rxd      = gmii_rxd_reg;
  assign gmii_rx_dv    = gmii_rx_dv_reg;
  assign gmii_rx_er    = gmii_rx_er_reg;

  // 从RGMII创建GMII格式的冲突和载波侦听信号 
  assign gmii_col = (gmii_tx_en | gmii_tx_er) & (gmii_rx_dv_reg | gmii_rx_er_reg);
  assign gmii_crs = (gmii_tx_en | gmii_tx_er) | (gmii_rx_dv_reg | gmii_rx_er_reg);
  
  

  //==============================================================================
  // RGMII 状态寄存器
  //==============================================================================

   // 在帧间间隔期间启用带内状态寄存器
   
   assign inband_ce = !(gmii_rx_dv_reg || gmii_rx_er_reg);

   always @ (posedge rgmii_rxc_int)
   begin
      if (rx_reset) begin
         link_status          <= 1'b0;
         clock_speed[1:0]     <= 2'b0;
         duplex_status        <= 1'b0;
      end
      else if (inband_ce) begin
         link_status          <= gmii_rxd_reg[0];
         clock_speed[1:0]     <= gmii_rxd_reg[2:1];
         duplex_status        <= gmii_rxd_reg[3];
      end
   end






endmodule

