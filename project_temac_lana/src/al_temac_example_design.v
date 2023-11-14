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

module al_temac_example_design
    (
      // 异步复位
      input         reset_n,
      // 时钟
      input wire    sysclk_P,
      // RGMII 接口
      output [3:0]  rgmii_txd,
      output        rgmii_tx_ctl,
      output        rgmii_txc,
      input  [3:0]  rgmii_rxd,
      input         rgmii_rx_ctl,
      input         rgmii_rxc,
      // MDIO 接口
      //---------------
      inout         mdio,
      output        mdc
    );
  
  //----------------------------------------------------------------------------
  // top level parameter
  //----------------------------------------------------------------------------	
   //----------------------------------------------------------------   
   //IP核生成时，GUI配置的参数
   //----------------------------------------------------------------
   parameter     P_HALF_DUPLEX 	    = 1'b1;		// 如果为true，则内核半双工和全双工模式，否则仅支持全双工模式。
   parameter     P_HOST_EN 	        = 1'b0;		// 如果为true，则内核仅支持AXI接口管理配置，否则内核仅支持矢量总线配置。
   parameter     P_ADD_FILT_EN 	    = 1'b1;     // 如果为true，则内核支持地址过滤。
   parameter     P_ADD_FILT_LIST 	= 16;		// 内核支持的地址表可配置地址个数
   parameter     P_SPEED_10_100     = 1'b0;		// 如果为true，则内核仅支持10/100 Mbps速度。
   parameter     P_SPEED_1000 	    = 1'b0;		// 如果为true，则内核仅支持1000 Mbps速度。
   parameter     P_TRI_SPEED 	    = 1'b1;		// 如果为true，则内核支持3速

   //----------------------------------------------------------------   
   // MAC核配置参数
   //----------------------------------------------------------------
    parameter  tx_cfg	            = {24'b0,1'b0,7'b0101010}; //发送器配置
	parameter  rx_cfg	            = {24'b0,8'b00101010};     //接收器配置 
    parameter  pause_srcad_cfg	    = 48'hf6f5f4f3f25a;        //暂停帧mac源地址配置
	parameter  speed_cfg	        = {30'b0,2'b10};           //速度配置 2'b10 千兆 2'b01 百兆 2'b00十兆
    parameter  flow_ctrl_cfg	    = {30'b0,2'b00};           //流控配置 
	parameter  ad_filter_mode_cfg	= {31'b0,1'b0};            //地址过滤模式配置：1'b1：启用混杂模式  1'b0：启用地址过滤模式
    parameter  unicast_ad_cfg	    = 48'h0605040302DA;        //单播地址配置
	parameter  ad_table0_cfg	    = 48'h06050403020A;        //地址表地址配置
    parameter  ad_table1_cfg	    = 48'h16151413121A;
	parameter  ad_table2_cfg	    = 48'h26252423222A;
    parameter  ad_table3_cfg	    = 48'h36353433323A;
    parameter  ad_table4_cfg	    = 48'h46454443424A;
    parameter  ad_table5_cfg	    = 48'h56555453525A;
	parameter  ad_table6_cfg	    = 48'h66656463626A;
    parameter  ad_table7_cfg	    = 48'h76757473727A;
    parameter  ad_table8_cfg	    = 48'h86858483828A;
    parameter  ad_table9_cfg	    = 48'h96959493929A;
	parameter  ad_table10_cfg	    = 48'hA6A5A4A3A2AA;
    parameter  ad_table11_cfg	    = 48'hB6B5B4B3B2BA;
    parameter  ad_table12_cfg	    = 48'hC6C5C4C3C2CA;
    parameter  ad_table13_cfg	    = 48'hD6D5D4D3D2DA;
	parameter  ad_table14_cfg	    = 48'hE6E5E4E3E2EA;
    parameter  ad_table15_cfg	    = 48'hF6F5F4F3F2FA;
	parameter  mdio_clk_cfg	        = {25'b0,7'b1001001};//mdc配置： mdc = m_axi_aclk/(9+1)*2=50/20=2.5MHZ
	parameter  mdio_we1_data_cfg	= {16'h0,16'h9340};  //16'h9340(千兆全双工);16'hb300(百兆全双工);16'h9300(十兆全双工);16'h9240(千兆半双工、核不支持);16'hb200(百兆半双工);16'h9200(十兆半双工) 
    parameter  mdio_we1_ctrl_cfg	= {19'b0,5'b00000,5'b00001,2'b01,1'b1}; //PHY芯片地址：phy_A:5'b00010  phy_B:5'b00001   对PHY仅配置基本模式控制寄存器（0x00/5'h00）即可:双工/速度配置  
	parameter  mdio_rd1_ctrl_cfg	= {19'b0,5'b00000,5'b00001,2'b10,1'b1};  //读取对PHY芯片配置值
 		
  //----------------------------------------------------------------------------
  // 模块内部信号
  //----------------------------------------------------------------------------
  
  //时钟信号
  wire        gtx_clk;        // 125MHZ
  wire        gtx_clk_bufg;
  
  wire        s_axi_aclk;     // 50MHZ
//wire        s_axi_aclk_bufg;

  // mac核时钟信号 / 时钟使能信号
  wire        tx_clk_int;
  wire        rx_clk_int;                     
  wire        rx_clk_en_int;                
  wire        tx_clk_en_int;

  //复位信号
  wire        tx_reset;  

  // Tx LocalLink FIFO I/F
  reg  [5:0]  tx_ll_pre_reset;
  reg         tx_ll_reset;
  
  wire        tx_ll_clk;
  wire [7:0]  tx_ll_data;
  wire        tx_ll_sof_n;
  wire        tx_ll_eof_n;
  wire        tx_ll_src_rdy_n;
  wire        tx_ll_dst_rdy_n;

  // Rx LocalLink FIFO I/F
  wire        rx_ll_reset;
  
  wire        rx_ll_clk;
  wire [7:0]  rx_ll_data;
  wire        rx_ll_sof_n;
  wire        rx_ll_eof_n;
  wire        rx_ll_src_rdy_n;
  wire        rx_ll_dst_rdy_n;

  // Tx和Rx统计状态向量
  wire [26:0] rx_status_vector_int;
  wire        rx_status_vld_int;
  wire [28:0] tx_status_vector_int;
  wire        tx_status_vld_int;
  
  // 客户端接口
  wire        tx_rdy;
  wire        tx_stop;
  wire [7:0]  tx_ifg_val;

  wire        pause_req;
  wire [15:0] pause_val;
  wire [47:0] pause_source_addr;
   
  wire [47:0] unicast_address;

  // 向量配置总线 
  wire [19:0] mac_cfg_vector;  
   	  	
  //AXI总线
  wire [7 : 0] s_axi_awaddr;    
  wire         s_axi_awvalid;    
  wire         s_axi_awready;    
  wire [31: 0] s_axi_wdata;       
  wire         s_axi_wvalid;    
  wire         s_axi_wready;    
  wire [1 : 0] s_axi_bresp;    
  wire         s_axi_bvalid;    
  wire         s_axi_bready;    
  wire [7 : 0] s_axi_araddr;      
  wire         s_axi_arvalid;    
  wire         s_axi_arready;    
  wire [31: 0] s_axi_rdata;    
  wire [1 : 0] s_axi_rresp;    
  wire         s_axi_rvalid;    
  wire         s_axi_rready;
 
 // MDIO接口
  reg         mdio_i;
  wire        mdio_o;
  wire        mdio_oen;

//============================================================          
//  mdio port
//============================================================
      assign mdio = mdio_oen ? 1'bz : mdio_o;
    //assign mdio_i = mdio;
      always @(mdio)
      begin
         mdio_i = mdio;
      end
            
//============================================================
// pll
//============================================================  
	wire resetn;
	wire gtx_clk90;
    pll u_pll
    (
    .refclk     (sysclk_P  ),
	.reset      (~reset_n  ),
	.lock    	(resetn    ),
    .clk0_out	(gtx_clk   ),   //125m
    .clk1_out	(gtx_clk90 ),   //125m
    .clk2_out	(s_axi_aclk)    //50mhz
    );

  assign  reset = !resetn;
  
wire rgmii_rxc_90;
rx_pll u_rx_pll(
.refclk		(rgmii_rxc),
.lock		(),
.clk0_out	(),
.clk1_out	(rgmii_rxc_90)
);

          
//=============================================================================================
// 参数配置逻辑
//=============================================================================================
   //需配置的客户端接口（初始默认值）
   
   assign  tx_stop    = 1'b0;
   assign  tx_ifg_val = 8'h00;
   
   assign  pause_req  = 1'b0;
   assign  pause_val  = 16'h0;
   assign  pause_source_addr = 48'h5af1f2f3f4f5;
   
   assign  unicast_address   = 48'h0605040302DA;
      
   assign  mac_cfg_vector    = {1'b0,2'b00,2'b10,8'b00000010,7'b0000010};   //使能矢量配置时（P_HOST_EN = 1'b0），由mac_cfg_vector给内核配置，此时AXI管理接口无效
   
 //------------------------------------------------------------------------
 //每次复位后，基于AXI_Master模块流水线配置mac内核和PHY芯片 
    wire         init_axi_txn;
    wire         axi_txn_done;
    reg 		 init_axi_txn_reg;   /*synthesis keep=true*/
	reg			 reset_ff,reset_ff2;
	
	always @(posedge s_axi_aclk)										      
	begin                                                                            
	     reset_ff <= reset;
	     reset_ff2 <= reset_ff;                                                                                                                                       
	end 
    	
	always @(posedge s_axi_aclk)										      
	begin                                                                           
	    if (reset == 1)                                                                                                                     
	        init_axi_txn_reg <= 1'b0;                                                                                                                               
	    else if((!reset_ff) && reset_ff2)     //下降沿                                                                 
	        init_axi_txn_reg <= 1'b1;  
		else if(axi_txn_done)                                                                      
	        init_axi_txn_reg <= 1'b0;    
	end 
    
	assign  init_axi_txn = init_axi_txn_reg;   // (initiate)发起AXI事务，在 reset下降沿
	
    axi_master_cfg 
    #(
		.tx_cfg	            (tx_cfg),
		.rx_cfg	            (rx_cfg),
        .pause_srcad_cfg	(pause_srcad_cfg),
		.speed_cfg	        (speed_cfg),
        .flow_ctrl_cfg	    (flow_ctrl_cfg),
		.ad_filter_mode_cfg	(ad_filter_mode_cfg),
        .unicast_ad_cfg	    (unicast_ad_cfg),
		.ad_table0_cfg	    (ad_table0_cfg),
        .ad_table1_cfg	    (ad_table1_cfg),
		.ad_table2_cfg	    (ad_table2_cfg),
        .ad_table3_cfg	    (ad_table3_cfg),
        .ad_table4_cfg	    (ad_table4_cfg),
        .ad_table5_cfg	    (ad_table5_cfg),
		.ad_table6_cfg	    (ad_table6_cfg),
        .ad_table7_cfg	    (ad_table7_cfg),
        .ad_table8_cfg	    (ad_table8_cfg),
        .ad_table9_cfg	    (ad_table9_cfg),
		.ad_table10_cfg	    (ad_table10_cfg),
        .ad_table11_cfg	    (ad_table11_cfg),
        .ad_table12_cfg	    (ad_table12_cfg),
        .ad_table13_cfg	    (ad_table13_cfg),
		.ad_table14_cfg	    (ad_table14_cfg),
        .ad_table15_cfg	    (ad_table15_cfg),
		.mdio_clk_cfg	    (mdio_clk_cfg),
		.mdio_we1_data_cfg	(mdio_we1_data_cfg),
        .mdio_we1_ctrl_cfg	(mdio_we1_ctrl_cfg),
		.mdio_rd1_ctrl_cfg	(mdio_rd1_ctrl_cfg)
	) 
    u_axi_master_cfg
    (	
        .init_axi_txn   (init_axi_txn),  // (initiate)发起AXI事务
        .axi_txn_done   (axi_txn_done),  // AXI事务完成时置高
                        
        .m_axi_aclk     (s_axi_aclk),
        .m_axi_areset   (reset),
        .m_axi_awaddr   (s_axi_awaddr),
        .m_axi_awvalid  (s_axi_awvalid),
        .m_axi_awready  (s_axi_awready),
        .m_axi_wdata    (s_axi_wdata),   
        .m_axi_wvalid   (s_axi_wvalid),
        .m_axi_wready   (s_axi_wready),
        .m_axi_bresp    (s_axi_bresp),
        .m_axi_bvalid   (s_axi_bvalid),
        .m_axi_bready   (s_axi_bready),
        .m_axi_araddr   (s_axi_araddr),
        .m_axi_arvalid  (s_axi_arvalid),
        .m_axi_arready  (s_axi_arready),
        .m_axi_rdata    (s_axi_rdata),
        .m_axi_rresp    (s_axi_rresp),
        .m_axi_rvalid   (s_axi_rvalid),
        .m_axi_rready   (s_axi_rready) 
    );
  
 
//===========================================================================================
// ODDR、BUFG、reset_sync等逻辑
//===========================================================================================
 
 //------------------------------------------------------------------------
 // Drive client clocks off chip
/* 
	EG_LOGIC_ODDR  rx_clk_ddr(
		.q(rx_clk),
		.clk(rx_clk_int),
		.d1(1'b0),
		.d0(1'b1),
		.rst(reset)
	);
	
	EG_LOGIC_ODDR  tx_clk_ddr(
		.q(tx_clk),
		.clk(tx_clk_int),
		.d1(1'b0),
		.d0(1'b1),
		.rst(reset)
	);
 */ 

  //----------------------------------------------------------------------------
  // gtx_clk：全局发送时钟
  //----------------------------------------------------------------------------


  // 通过BUFG将clk布线到全局时钟
    //BUFG bufg_gtx_clk (.I(gtx_clk), .O(gtx_clk_bufg));
    //BUFG bufg_grx_clk (.I(rgmii_rxc), .O(rgmii_rxc_bufg));

  //BUFG  bufg_host_clk  (.I(s_axi_aclk), .O(s_axi_aclk_bufg));

  //----------------------------------------------------------------------------
  // 产生用于 client_loopback模块 和 FIFO 的 时钟 和 同步复位信号
  //----------------------------------------------------------------------------

  // 在Tx时钟域中生成同步复位信号
   reset_sync tx_reset_gen (
      .clk              (tx_clk_int),
      .enable           (1'b1),
      .reset_in         (reset),
      .reset_out        (tx_reset)
   );

  // 在 LocalLink 发送时钟域 中 生成 完全同步复位
   always @(posedge tx_clk_int)
   begin
        if (tx_reset) 
        begin
          tx_ll_pre_reset <= 6'b111111;
          tx_ll_reset     <= 1;
        end
        else 
        begin
          tx_ll_pre_reset[0]          <= 0;
          tx_ll_pre_reset[5:1]        <= tx_ll_pre_reset[4:0];
          tx_ll_reset                 <= tx_ll_pre_reset[5];
        end
   end 

  //----------------------------------
  // LocalLink FIFO Clock and Reset 

  assign tx_ll_clk = tx_clk_int;
  assign rx_ll_clk = tx_clk_int;

  assign rx_ll_reset = tx_ll_reset;

  //----------------------------------------------------------------------------
  //  例化 loopback 模块；   环回输出帧：目的地址和源地址交换
  //----------------------------------------------------------------------------
  wire [7:0] send_data;
  wire send_sof;
  wire send_eof;
  wire src_rdy;
  wire dst_rdy;

  test_send u_test_send(
    .clk(tx_clk_int),
    .rst_n(~tx_ll_reset),
    .data_out(send_data),
    .sof(send_sof),
    .eof(send_eof),
    .src_rdy(src_rdy),
    .dst_rdy(dst_rdy)
  );
  
  client_loopback u_client_loopback
    (
      .rx_ll_clock          (tx_clk_int),
      .rx_ll_reset          (tx_ll_reset),
      .rx_ll_data_in        (send_data), // (rx_ll_data),
      .rx_ll_sof_in_n       (~send_sof), // (rx_ll_sof_n),
      .rx_ll_eof_in_n       (~send_eof), // (rx_ll_eof_n),
      .rx_ll_src_rdy_in_n   (~src_rdy),  // (rx_ll_src_rdy_n),
      .tx_ll_data_out       (tx_ll_data),
      .tx_ll_sof_out_n      (tx_ll_sof_n),
      .tx_ll_eof_out_n      (tx_ll_eof_n),
      .tx_ll_src_rdy_out_n  (tx_ll_src_rdy_n),
      .tx_ll_dst_rdy_in_n   (~dst_rdy)  // (tx_ll_dst_rdy_n)
    );
  
  // client_loopback u_client_loopback
  //   (
  //     .rx_ll_clock          (tx_clk_int),
  //     .rx_ll_reset          (tx_ll_reset),
  //     .rx_ll_data_in        (rx_ll_data),
  //     .rx_ll_sof_in_n       (rx_ll_sof_n),
  //     .rx_ll_eof_in_n       (rx_ll_eof_n),
  //     .rx_ll_src_rdy_in_n   (rx_ll_src_rdy_n),
  //     .tx_ll_data_out       (tx_ll_data),
  //     .tx_ll_sof_out_n      (tx_ll_sof_n),
  //     .tx_ll_eof_out_n      (tx_ll_eof_n),
  //     .tx_ll_src_rdy_out_n  (tx_ll_src_rdy_n),
  //     .tx_ll_dst_rdy_in_n   (tx_ll_dst_rdy_n)
  //   );

  assign rx_ll_dst_rdy_n = tx_ll_dst_rdy_n;
  
/*   
  //----------------------------------------------------------------------------
  // 数据生成模块：为了测试流控、IFG调整功能
  //----------------------------------------------------------------------------
    //data_gen_flow_ctrl u1_data_gen_flow_ctrl  //用于 接收器流控 功能测试
    data_gen  u1_data_gen               //用于 IFG调整 功能测试 或者 loopback功能测试
    (
      .rx_ll_clock          (tx_clk_int),
      .rx_ll_reset          (tx_ll_reset),
	  
	  .tx_gen_data_en		(axi_txn_done),// 配置完成后，开始发送产生的帧数据，使能信号高电平有效
	  
      .rx_ll_data_in        (rx_ll_data),
      .rx_ll_sof_in_n       (rx_ll_sof_n),
      .rx_ll_eof_in_n       (rx_ll_eof_n),
      .rx_ll_src_rdy_in_n   (rx_ll_src_rdy_n),
	  
      .tx_ll_data           (tx_ll_data),
      .tx_ll_sof_out_n      (tx_ll_sof_n),
      .tx_ll_eof_out_n      (tx_ll_eof_n),
      .tx_ll_src_rdy_out_n  (tx_ll_src_rdy_n),
      .tx_ll_dst_rdy_in_n   (tx_ll_dst_rdy_n)
    );

	assign rx_ll_dst_rdy_n = tx_ll_dst_rdy_n;
 */
 
  //----------------------------------------------------------------------------
  // 例化 TRIMAC locallink 模块
  //----------------------------------------------------------------------------
  temac_locallink 
    #(
    .P_HALF_DUPLEX   (P_HALF_DUPLEX     ), 
    .P_HOST_EN       (P_HOST_EN         ),  
    .P_ADD_FILT_EN   (P_ADD_FILT_EN     ), 
    .P_ADD_FILT_LIST (P_ADD_FILT_LIST   ), 
    .P_SPEED_10_100  (P_SPEED_10_100    ), 
    .P_SPEED_1000    (P_SPEED_1000      ), 
    .P_TRI_SPEED     (P_TRI_SPEED       )
    )
  trimac_locallink
    (
      // 异步复位
      .reset                (reset),

      //全局发送时钟
      .gtx_clk              (gtx_clk),
      .gtx_clk90			      (gtx_clk90),
      // 客户端接收接口
      .rx_clk               (rx_clk_int),
      .rx_clk_en            (rx_clk_en_int),
      .rx_status_vector     (rx_status_vector_int),
      .rx_status_vld        (rx_status_vld_int),

      // 客户端接收（FIFO侧）接口
      .rx_ll_clock          (rx_ll_clk),
      .rx_ll_reset          (rx_ll_reset),
      .rx_ll_data_out       (rx_ll_data),
      .rx_ll_sof_out_n      (rx_ll_sof_n),
      .rx_ll_eof_out_n      (rx_ll_eof_n),
      .rx_ll_src_rdy_out_n  (rx_ll_src_rdy_n),
      .rx_ll_dst_rdy_in_n   (rx_ll_dst_rdy_n),

      // 客户端发送器接口
      .tx_clk               (tx_clk_int),
      .tx_clk_en            (tx_clk_en_int),
      .tx_rdy               (tx_rdy),
      .tx_stop              (tx_stop),
      .tx_ifg_val           (tx_ifg_val),
      .tx_status_vector     (tx_status_vector_int),
      .tx_status_vld        (tx_status_vld_int),

      // 客户端发送（FIFO侧）接口
      .tx_ll_clock          (tx_ll_clk),
      .tx_ll_reset          (tx_ll_reset),
      .tx_ll_data_in        (tx_ll_data),
      .tx_ll_sof_in_n       (tx_ll_sof_n),
      .tx_ll_eof_in_n       (tx_ll_eof_n),
      .tx_ll_src_rdy_in_n   (tx_ll_src_rdy_n),
      .tx_ll_dst_rdy_out_n  (tx_ll_dst_rdy_n),

      // 流控接口
	  .pause_req            (pause_req),
      .pause_val            (pause_val),
      .pause_source_addr    (pause_source_addr),

      // 初始默认单播地址值
      .unicast_address      (unicast_address),
      
      // AXI主机管理接口
	  .s_axi_aclk           (s_axi_aclk), 
	  .s_axi_awaddr         (s_axi_awaddr),    //input  wire [7 : 0]     
	  .s_axi_awvalid        (s_axi_awvalid),   //input  wire             
	  .s_axi_awready        (s_axi_awready),   //output wire             
	  .s_axi_wdata          (s_axi_wdata),     //input  wire [31: 0]     
	  .s_axi_wvalid         (s_axi_wvalid),    //input  wire             
	  .s_axi_wready         (s_axi_wready),    //output wire             
	  .s_axi_bresp          (s_axi_bresp),     //output wire [1 : 0]     
	  .s_axi_bvalid         (s_axi_bvalid),    //output wire             
	  .s_axi_bready         (s_axi_bready),    //input  wire             
	  .s_axi_araddr         (s_axi_araddr),    //input  wire [7 : 0]     
	  .s_axi_arvalid        (s_axi_arvalid),   //input  wire             
	  .s_axi_arready        (s_axi_arready),   //output wire             
	  .s_axi_rdata          (s_axi_rdata),     //output wire [31: 0]     
	  .s_axi_rresp          (s_axi_rresp),     //output wire [1 : 0]     
	  .s_axi_rvalid         (s_axi_rvalid),    //output wire             
	  .s_axi_rready         (s_axi_rready),    //input  wire
      
      // 向量配置总线
      .mac_cfg_vector       (mac_cfg_vector),
      
      // RGMII 接口
      .rgmii_txd            (rgmii_txd),
      .rgmii_tx_ctl         (rgmii_tx_ctl),
      .rgmii_txc            (rgmii_txc),
      .rgmii_rxd            (rgmii_rxd),
      .rgmii_rx_ctl         (rgmii_rx_ctl),
      .rgmii_rxc            (rgmii_rxc_90),
      
      // RGMII 状态寄存器
      .inband_link_status   (inband_link_status),
      .inband_clock_speed   (inband_clock_speed),
      .inband_duplex_status (inband_duplex_status),

      // MDIO 接口
      .mdio_clk             (mdc),
      .mdio_i               (mdio_i),
      .mdio_o               (mdio_o),
      .mdio_oen             (mdio_oen)      
    );

endmodule
