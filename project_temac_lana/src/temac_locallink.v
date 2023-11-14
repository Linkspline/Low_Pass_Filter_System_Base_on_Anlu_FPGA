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

module temac_locallink
   (
      // 异步复位
      //---------------------------------------
      input         reset,
      
      //全局发送时钟
      //--------------------------
      input         gtx_clk,
      input			gtx_clk90,

      // 客户端接收接口
      //---------------------------------------
      output        rx_clk,
      output        rx_clk_en,
      output [26:0] rx_status_vector,
      output        rx_status_vld,
      

      // 客户端接收（FIFO侧）接口
      //----------------------------------------
      input         rx_ll_clock,
      input         rx_ll_reset,
      output [7:0]  rx_ll_data_out,
      output        rx_ll_sof_out_n,
      output        rx_ll_eof_out_n,
      output        rx_ll_src_rdy_out_n,
      input         rx_ll_dst_rdy_in_n,

      // 客户端发送器接口
      //------------------------------------------
      output        tx_clk,
      output        tx_clk_en,
      output        tx_rdy,   // For test
      input         tx_stop,
      input  [7:0]  tx_ifg_val,
      output [28:0] tx_status_vector,
      output        tx_status_vld,

      // 客户端发送（FIFO侧）接口
      //-------------------------------------------
      input         tx_ll_clock,
      input         tx_ll_reset,
      input  [7:0]  tx_ll_data_in,
      input         tx_ll_sof_in_n,
      input         tx_ll_eof_in_n,
      input         tx_ll_src_rdy_in_n,
      output        tx_ll_dst_rdy_out_n,

      // 流控接口
      //--------------------------------
      input         pause_req,
      input  [15:0] pause_val,
      input  [47:0] pause_source_addr,
      
      // 初始默认单播地址值
      //--------------------------------
      input [47:0]  unicast_address,
      
      // AXI主机管理接口
      //-----------------------------------	  
	  //AXI总线
      input          s_axi_aclk,
      input  [7 : 0] s_axi_awaddr,
      input          s_axi_awvalid,
      output         s_axi_awready,
      input  [31: 0] s_axi_wdata,   
      input          s_axi_wvalid,
      output         s_axi_wready,
      output [1 : 0] s_axi_bresp,
      output         s_axi_bvalid,
      input          s_axi_bready,
      input  [7 : 0] s_axi_araddr,
      input          s_axi_arvalid,
      output         s_axi_arready,
      output [31: 0] s_axi_rdata,
      output [1 : 0] s_axi_rresp,
      output         s_axi_rvalid,
      input          s_axi_rready,

      // 向量配置总线
      //-----------------------------
      input [19:0]  mac_cfg_vector,
      
      // RGMII 接口
      //----------------------------------
      output [3:0]  rgmii_txd,
      output        rgmii_tx_ctl,
      output        rgmii_txc,
      input  [3:0]  rgmii_rxd,
      input         rgmii_rx_ctl,
      input         rgmii_rxc,

      // RGMII 状态寄存器
      //--------------------------------
      output        inband_link_status,
      output [1:0]  inband_clock_speed,
      output        inband_duplex_status,

      // MDIO 接口
      //------------------------------
      input         mdio_i,
      output        mdio_o,
      output        mdio_oen,
      output        mdio_clk

      
   );
   
  //======================================================
  //参数
   //----------------------------------------------------------------   
   //IP核生成时，GUI配置的参数
   //----------------------------------------------------------------
   parameter     P_HALF_DUPLEX 	    = 1'b1;		// 如果为true，则内核半双工和全双工模式，否则仅支持全双工模式。
   parameter     P_HOST_EN 	        = 1'b1;		// 如果为true，则内核仅支持AXI接口管理配置，否则内核仅支持矢量总线配置。
   parameter     P_ADD_FILT_EN 	    = 1'b1;     // 如果为true，则内核支持地址过滤。
   parameter     P_ADD_FILT_LIST 	= 16;		// 内核支持的地址表可配置地址个数
   parameter     P_SPEED_10_100     = 1'b0;		// 如果为true，则内核仅支持10/100 Mbps速度。
   parameter     P_SPEED_1000 	    = 1'b0;		// 如果为true，则内核仅支持1000 Mbps速度。
   parameter     P_TRI_SPEED 	    = 1'b1;		// 如果为true，则内核支持3速

  //----------------------------------------------------------------------------
  // 模块内部信号
  //----------------------------------------------------------------------------
  
  //rx域 接收时钟 及 复位信号
  //-----------------------
  wire       rx_clk_int;    
  wire       rx_clk_en_int; 
  
  wire       rx_reset_int;  
  reg        rx_pre_reset;  
  reg        rx_reset;      

  //tx域 发送时钟 及 复位信号
  //-----------------------
  wire       tx_clk_int;    
  wire       tx_clk_en_int; 
  
  wire       tx_reset_int;  
  reg        tx_pre_reset;  
  reg        tx_reset;      

  // 客户端接收接口
  //-----------------------
  wire [7:0] rx_data;
  wire       rx_data_valid;
  wire       rx_correct_frame;
  wire       rx_error_frame;

  // 客户端发送接口
  //-----------------------
  wire [7:0] tx_data;
  wire       tx_data_en;
//wire       tx_rdy;
//wire       tx_stop;
  wire       tx_collision;
  wire       tx_retransmit;


  //----------------------------------------------------------------------------
  // 将 时钟信号/时钟使能信号 输出
  //----------------------------------------------------------------------------

   assign rx_clk          = rx_clk_int;
   assign rx_clk_en       = rx_clk_en_int;
   assign tx_clk          = tx_clk_int;
   assign tx_clk_en       = tx_clk_en_int;

   //---------------------------------------------------------------------------
   // 例化 复位同步
   //---------------------------------------------------------------------------

   // 在Tx时钟域中生成同步复位信号
   reset_sync tx_reset_gen 
   (
      .clk              (tx_clk_int),
      .enable           (1'b1),
      .reset_in         (reset),
      .reset_out        (tx_reset_int)
   );

   // 在Tx时钟域中生成 完全同步复位
   always @(posedge tx_clk_int)
   begin
        if (tx_reset_int) 
        begin
          tx_pre_reset      <= 1;
          tx_reset          <= 1;
        end
        else 
        begin
          tx_pre_reset      <= 0;
          tx_reset          <= tx_pre_reset;
        end
   end 

   //-----------------------------------------------------------------------
   // 在rx时钟域中生成 同步复位信号
   reset_sync rx_reset_gen 
   (
      .clk              (rx_clk_int),
      .enable           (1'b1),
      .reset_in         (reset),
      .reset_out        (rx_reset_int)
   );

   // 在rx时钟域中生成 完全同步复位
   always @(posedge rx_clk_int)
   begin
        if (rx_reset_int) 
        begin
          rx_pre_reset      <= 1;
          rx_reset          <= 1;
        end
        else 
        begin
          rx_pre_reset      <= 0;
          rx_reset          <= rx_pre_reset;
        end
   end 

  //----------------------------------------------------------------------------
  // 例化客户端FIFO
  //----------------------------------------------------------------------------
  client_FIFO  u_client_FIFO
   (
      // MAC TX 接口
      .tx_reset             (tx_reset),
      .tx_clk               (tx_clk_int),      
      .tx_clk_en            (tx_clk_en_int),
      .tx_data              (tx_data),
      .tx_data_en           (tx_data_en),
      .tx_rdy               (tx_rdy),
    //.tx_stop              (tx_stop),
      .tx_collision         (tx_collision),
      .tx_retransmit        (tx_retransmit),

      // 客户端发送（FIFO侧）接口
      .tx_ll_clock          (tx_ll_clock),
      .tx_ll_reset          (tx_ll_reset),
      .tx_ll_data_in        (tx_ll_data_in),
      .tx_ll_sof_in_n       (tx_ll_sof_in_n),
      .tx_ll_eof_in_n       (tx_ll_eof_in_n),
      .tx_ll_src_rdy_in_n   (tx_ll_src_rdy_in_n),
      .tx_ll_dst_rdy_out_n  (tx_ll_dst_rdy_out_n),
    //.tx_fifo_status       (),
    //.tx_overflow          (),

      // MAC RX 接口
      .rx_reset             (rx_reset),
      .rx_clk               (rx_clk_int),     
      .rx_clk_en            (rx_clk_en_int),
      .rx_data              (rx_data),
      .rx_data_valid        (rx_data_valid),
      .rx_correct_frame     (rx_correct_frame),
      .rx_error_frame       (rx_error_frame),
    //.rx_overflow          (),

      // 客户端接收（FIFO侧）接口
      .rx_ll_clock          (rx_ll_clock),
      .rx_ll_reset          (rx_ll_reset),
      .rx_ll_data_out       (rx_ll_data_out),
      .rx_ll_sof_out_n      (rx_ll_sof_out_n),
      .rx_ll_eof_out_n      (rx_ll_eof_out_n),
      .rx_ll_src_rdy_out_n  (rx_ll_src_rdy_out_n),
      .rx_ll_dst_rdy_in_n   (rx_ll_dst_rdy_in_n)
    //.rx_fifo_status       ()
  );


  //----------------------------------------------------------------------------
  // 例化 TEMAC Block 模块
  //----------------------------------------------------------------------------
  temac_block 
    #(
    .P_HALF_DUPLEX   (P_HALF_DUPLEX     ), 
    .P_HOST_EN       (P_HOST_EN         ), 
    .P_ADD_FILT_EN   (P_ADD_FILT_EN     ), 
    .P_ADD_FILT_LIST (P_ADD_FILT_LIST   ), 
    .P_SPEED_10_100  (P_SPEED_10_100    ), 
    .P_SPEED_1000    (P_SPEED_1000      ), 
    .P_TRI_SPEED     (P_TRI_SPEED       )
    )
  trimac_block
   (
      // 异步复位
      .reset                (reset),
      
      //全局发送时钟
      .gtx_clk              (gtx_clk),
      .gtx_clk90			(gtx_clk90),

      // 客户端接收接口
      .rx_clk               (rx_clk_int),
      .rx_clk_en            (rx_clk_en_int),
      .rx_data              (rx_data),
      .rx_data_valid        (rx_data_valid),
      .rx_correct_frame     (rx_correct_frame),
      .rx_error_frame       (rx_error_frame),
      .rx_status_vector     (rx_status_vector),
      .rx_status_vld        (rx_status_vld),

      // 客户发送器接口
      .tx_clk               (tx_clk_int),
      .tx_clk_en            (tx_clk_en_int),
      .tx_data              (tx_data),
      .tx_data_en           (tx_data_en),
      .tx_rdy               (tx_rdy),
      .tx_stop              (tx_stop),
      .tx_collision         (tx_collision),
      .tx_retransmit        (tx_retransmit),
      .tx_ifg_val           (tx_ifg_val),
      .tx_status_vector     (tx_status_vector),
      .tx_status_vld        (tx_status_vld),

      //流控接口
      .pause_req            (pause_req),
      .pause_val            (pause_val),
      .pause_source_addr    (pause_source_addr),
      
      //初始默认单播地址值
      .unicast_address      (unicast_address),
      
      // AXI主机管理接口
	  .s_axi_aclk           (s_axi_aclk), 
	  .s_axi_awaddr         (s_axi_awaddr),     //input  wire [7 : 0]     
	  .s_axi_awvalid        (s_axi_awvalid),    //input  wire             
	  .s_axi_awready        (s_axi_awready),    //output wire             
	  .s_axi_wdata          (s_axi_wdata),      //input  wire [31: 0]     
	  .s_axi_wvalid         (s_axi_wvalid),     //input  wire             
	  .s_axi_wready         (s_axi_wready),     //output wire             
	  .s_axi_bresp          (s_axi_bresp),      //output wire [1 : 0]     
	  .s_axi_bvalid         (s_axi_bvalid),     //output wire             
	  .s_axi_bready         (s_axi_bready),     //input  wire             
	  .s_axi_araddr         (s_axi_araddr),     //input  wire [7 : 0]     
	  .s_axi_arvalid        (s_axi_arvalid),    //input  wire             
	  .s_axi_arready        (s_axi_arready),    //output wire             
	  .s_axi_rdata          (s_axi_rdata),      //output wire [31: 0]     
	  .s_axi_rresp          (s_axi_rresp),      //output wire [1 : 0]     
	  .s_axi_rvalid         (s_axi_rvalid),     //output wire             
	  .s_axi_rready         (s_axi_rready),     //input  wire
      
      // 向量配置总线
      .mac_cfg_vector       (mac_cfg_vector),

      // RGMII接口
      .rgmii_txd            (rgmii_txd),
      .rgmii_tx_ctl         (rgmii_tx_ctl),
      .rgmii_txc            (rgmii_txc),
      .rgmii_rxd            (rgmii_rxd),
      .rgmii_rx_ctl         (rgmii_rx_ctl),
      .rgmii_rxc            (rgmii_rxc),
      .inband_link_status   (inband_link_status),
      .inband_clock_speed   (inband_clock_speed),
      .inband_duplex_status (inband_duplex_status),

      // MDIO 接口
      .mdio_clk             (mdio_clk),
      .mdio_i               (mdio_i),
      .mdio_o               (mdio_o),
      .mdio_oen             (mdio_oen)
   );



endmodule
