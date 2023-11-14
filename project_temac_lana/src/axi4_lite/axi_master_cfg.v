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

  module axi_master_cfg 
  	#(
		parameter  tx_cfg	            = {24'b0,1'b0,7'b0101010},
		parameter  rx_cfg	            = {24'b0,8'b00101010},
        parameter  pause_srcad_cfg	    = 48'h5af1f2f3f4f5,  //暂停帧 mac源地址:48'h5af1f2f3f4f5,
		parameter  speed_cfg	        = {30'b0,2'b10},
        parameter  flow_ctrl_cfg	    = {30'b0,2'b00},
		parameter  ad_filter_mode_cfg	= {31'b0,1'b0},      //1'b1：启用混杂模式  1'b0：启用地址过滤模式,
        parameter  unicast_ad_cfg	    = 48'h0605040302DA,
		parameter  ad_table0_cfg	    = 48'h06050403020A,
        parameter  ad_table1_cfg	    = 48'h16151413121A,
		parameter  ad_table2_cfg	    = 48'h26252423222A,
        parameter  ad_table3_cfg	    = 48'h36353433323A,
        parameter  ad_table4_cfg	    = 48'h46454443424A,
        parameter  ad_table5_cfg	    = 48'h56555453525A,
		parameter  ad_table6_cfg	    = 48'h66656463626A,
        parameter  ad_table7_cfg	    = 48'h76757473727A,
        parameter  ad_table8_cfg	    = 48'h86858483828A,
        parameter  ad_table9_cfg	    = 48'h96959493929A,
		parameter  ad_table10_cfg	    = 48'hA6A5A4A3A2AA,
        parameter  ad_table11_cfg	    = 48'hB6B5B4B3B2BA,
        parameter  ad_table12_cfg	    = 48'hC6C5C4C3C2CA,
        parameter  ad_table13_cfg	    = 48'hD6D5D4D3D2DA,
		parameter  ad_table14_cfg	    = 48'hE6E5E4E3E2EA,
        parameter  ad_table15_cfg	    = 48'hF6F5F4F3F2FA,
		parameter  mdio_clk_cfg	        = {25'b0,7'b1001001},  // mdc = m_axi_aclk/(9+1)*2=50/20=2.5MHZ
		parameter  mdio_we1_data_cfg	= {16'h0,16'h9340},    //PHY芯片地址：phy_A:5'b00010  phy_B:5'b00001   对PHY仅配置基本模式控制寄存器（0x00/5'h00）即可:双工/速度配置
        parameter  mdio_we1_ctrl_cfg	= {19'b0,5'b00000,5'b00001,2'b01,1'b1},  //16'h9340： 千兆全双工 ； 16'hb300：百兆全双工；  16'h9300：十兆全双工
		parameter  mdio_rd1_ctrl_cfg	= {19'b0,5'b00000,5'b00001,2'b10,1'b1}   //16'h9240：千兆半双工（核不支持）；16'hb200：百兆半双工；  16'h9200：十兆半双工 
 		
	)
    (	
        input   wire             init_axi_txn,  // (initiate)发起AXI事务
        output  wire             axi_txn_done,  // AXI事务完成时断言
        //AXI总线
        input   wire             m_axi_aclk,
        input   wire             m_axi_areset,
        output  wire [7 : 0]     m_axi_awaddr,
        output  wire             m_axi_awvalid,
        input   wire             m_axi_awready,
        output  wire [31: 0]     m_axi_wdata,   
        output  wire             m_axi_wvalid,
        input   wire             m_axi_wready,
        input   wire [1 : 0]     m_axi_bresp,
        input   wire             m_axi_bvalid,
        output  wire             m_axi_bready,
        output  wire [7 : 0]     m_axi_araddr,
        output  wire             m_axi_arvalid,
        input   wire             m_axi_arready,
        input   wire [31: 0]     m_axi_rdata,
        input   wire [1 : 0]     m_axi_rresp,
        input   wire             m_axi_rvalid,
        output  wire             m_axi_rready
        
     
    );
    
  //----------------------------------------------------------------------------
  // 模块内部信号
  //----------------------------------------------------------------------------
  // 读写事务次数
   localparam  we_transactions_num     = 6'h2D;  // we_transactions_num 值比 #337行 case(write_index)最大值加1
   localparam  rd_transactions_num     = 6'h13;  // rd_transactions_num 值比 #530行 case(read_index) 最大值加1
  //地址参数
   localparam  tx_address 				= 8'h10;
   localparam  rx_address 				= 8'h20;
   localparam  pause_srcad0_address 	= 8'h30;
   localparam  pause_srcad1_address 	= 8'h40;
   localparam  speed_address 			= 8'h50;
   localparam  flow_ctrl_address 		= 8'h60;
   localparam  ad_filter_mode_address 	= 8'h70;
   localparam  unicast_ad0_address 		= 8'h80;
   localparam  unicast_ad1_address 		= 8'h82;
   localparam  ad_table0_address 		= 8'h84;
   localparam  ad_table1_address 		= 8'h86;
   localparam  mdio_clk_address 		= 8'h90;
   localparam  mdio_ctrl_address 		= 8'hA0;
   localparam  mdio_rd_data_address 	= 8'hB0;
   localparam  mdio_we_data_address 	= 8'hC0;
  
  parameter [1:0] IDLE 		  = 2'b00, // 当INIT_AXI_TXN上有0到1的转换时，当前状态机跳转为INIT_WRITE，INIT_WRITE此状态启动AXI4Lite写事务
				  INIT_WRITE  = 2'b01, // 此状态初始化写事务，一旦完成写，状态机将状态更改为INIT_READ
				  INIT_READ   = 2'b10; // 此状态初始化读取事务，读取完成
  
  //AXI总线8个输出信号寄存器
    reg [7 : 0] 	axi_awaddr;     //output   
    reg  	        axi_awvalid;    //output
    reg [31 : 0] 	axi_wdata;      //output
	reg  	        axi_wvalid;     //output
    reg  	        axi_bready;     //output
    reg [7 : 0] 	axi_araddr;     //output
	reg  	        axi_arvalid;    //output
	reg  	        axi_rready;     //output
  //中间信号
	reg [1:0]    master_state;
    reg  		 init_txn_ff;
	reg  		 init_txn_ff2;
    reg  		 start_single_write;
	reg [5:0] 	 write_index;
	reg  		 start_single_read;
	reg [5:0] 	 read_index;
	reg  		 write_issued;
	reg  		 read_issued;
	reg  		 last_write;
	reg  	     last_read;
	reg  		 writes_done;
	reg  		 reads_done;
    reg          axi_txn_done_reg; /*synthesis keep=true*/
	reg [31 : 0] rd_data_val;   /*synthesis keep=true*/
	
    //----------------------------------------------------------------------------
    // i/o connections assignments（axi4-lite总线 8个输出信号）
    //----------------------------------------------------------------------------
    assign m_axi_awaddr     = axi_awaddr; 
    assign m_axi_awvalid    = axi_awvalid;
    assign m_axi_wdata      = axi_wdata;  
    assign m_axi_wvalid     = axi_wvalid; 
    assign m_axi_bready     = axi_bready; 
    assign m_axi_araddr     = axi_araddr; 
    assign m_axi_arvalid    = axi_arvalid;
    assign m_axi_rready     = axi_rready; 
    
    assign axi_txn_done     = axi_txn_done_reg; 
    
    //----------------------------------------------------------------------------
    // (initiate)发起AXI事务.启动标志信号产生逻辑
    //---------------------------------------------------------------
  	
	//产生一个脉冲以启动AXI事务。
	always @(posedge m_axi_aclk)										      
	  begin                                                                        
	    // Initiates AXI transaction delay    
	    if (m_axi_areset == 1)                                                   
	      begin                                                                    
	        init_txn_ff <= 1'b0;                                                   
	        init_txn_ff2 <= 1'b0;     
       end                                                                               
	    else                                                                       
	      begin  
	        init_txn_ff <= init_axi_txn;
	        init_txn_ff2 <= init_txn_ff;                                                                 
	      end                                                                      
	  end 
    
    assign init_txn_pulse	= (!init_txn_ff2) && init_txn_ff;   //上升沿
  
	//=======================================================================
	// 写时序
	//======================================================================= 
    //--------------------
	//写地址通道
	//--------------------

	// 写地址通道的目的是为整个事务请求地址和命令信息。 

	// 请注意，在此示例中，axi_awvalid / axi_wvalid是在同一时间声明的，然后彼此独立解除声明。
	// 在链路伙伴接收之前，AXI的VALID信号必须保持有效状态。

	  always @(posedge m_axi_aclk)										      
	  begin                                                                          
	    if (m_axi_areset == 1 || init_txn_pulse == 1'b1)                                                   
	      begin                                                                    
	        axi_awvalid <= 1'b0;                                                   
	      end                                                                      
	      //表示用户逻辑可用新的地址/数据命令           
	    else                                                                       
	      begin                                                                    
	        if (start_single_write)                                                
	          begin                                                                
	            axi_awvalid <= 1'b1;                                               
	          end                                                                  
	     //地址由互连从机接收（从机发出m_axi_awready）
	        else if (m_axi_awready && axi_awvalid)                                 
	          begin                                                                
	            axi_awvalid <= 1'b0;                                               
	          end                                                                  
	      end                                                                      
	  end 
      
      // start_single_write触发新的写入事务。  
      // write_index是一个计数器，用于跟踪 已发出/已启动 的写事务的数量                                                         
	  always @(posedge m_axi_aclk)                                                 
	  begin                                                                        
	    if (m_axi_areset == 1 || init_txn_pulse == 1'b1)                                                   
	      begin                                                                    
	        write_index <= 0;                                                      
	      end                                                                      
	      // 表示新的 写地址/写数据 ，可由用户逻辑提供                                               
	    else if (start_single_write)                                               
	      begin                                                                    
	        write_index <= write_index + 1;                                        
	      end                                                                      
	  end 
      
    //-------------------------------
	//写数据通道：axi_wvalid信号
	//------------------------------

	// 写数据通道用于传输实际数据。  
    // 数据生成特定于示例设计，下面显示 valid / wready 握手

	   always @(posedge m_axi_aclk)                                        
	   begin                                                                         
	     if (m_axi_areset == 1  || init_txn_pulse == 1'b1)                                                    
	       begin                                                                     
	         axi_wvalid <= 1'b0;                                                     
	       end                                                                       
	     //通过用户逻辑给新的地址/数据命令发送信号              
	     else if (start_single_write)                                                
	       begin                                                                     
	         axi_wvalid <= 1'b1;                                                     
	       end                                                                       
	     //数据被互连从设备接受（从设备发出m_axi_wready）      
	     else if (m_axi_wready && axi_wvalid)                                        
	       begin                                                                     
	        axi_wvalid <= 1'b0;                                                      
	       end                                                                       
	   end
       
    //--------------------------------------------------
	//写数据通道：用户逻辑（写 地址/数据 激励）
	//--------------------------------------------------
 /*  配置值						配置地址
    tx_cfg	         			tx_address 				= 8'h10
    rx_cfg	                    rx_address 				= 8'h20
    pause_srcad_cfg	            pause_srcad0_address 	= 8'h30
    speed_cfg	                pause_srcad1_address 	= 8'h40
    flow_ctrl_cfg	            speed_address 			= 8'h50
    ad_filter_mode_cfg          flow_ctrl_address 		= 8'h60
    unicast_ad_cfg	            ad_filter_mode_address 	= 8'h70
    ad_table3_cfg	            unicast_ad0_address 	= 8'h80	
    ad_table2_cfg	            unicast_ad1_address 	= 8'h82	
    ad_table1_cfg	            ad_table0_address 		= 8'h84
    ad_table0_cfg	            ad_table1_address 		= 8'h86
    mdio_clk_cfg	            mdio_clk_address 		= 8'h90
    mdio_we1_ctrl_cfg	        mdio_ctrl_address 		= 8'hA0
    mdio_we1_data_cfg	        mdio_rd_data_address 	= 8'hB0
    mdio_rd1_ctrl_cfg           mdio_we_data_address 	= 8'hC0
	 */
    
    // 根据需要针对不同的地址模式修改它们。

	  //write addresses                                        
	  always @(posedge m_axi_aclk)                                  
	      begin                                                     
	        if (m_axi_areset == 1  || init_txn_pulse == 1'b1)                                
	          begin                                                 
	            axi_awaddr <= speed_address;    
                axi_wdata  <= speed_cfg;   //开始数据值为速度配置
	          end                                                   
	          // 表示新的写地址/写数据可由用户逻辑//提供                            
	        //else if (m_axi_awready && axi_awvalid) 
            else if (m_axi_bvalid)   
             begin 
                case(write_index)
              //6'h00:  begin
                    // axi_awaddr <= speed_address; 
                    // axi_wdata  <= speed_cfg; 
                    // end
				6'h01:  begin
                    axi_awaddr <= tx_address; 
                    axi_wdata  <= tx_cfg; 
                    end
                6'h02:  begin
                    axi_awaddr <= rx_address; 
                    axi_wdata  <= rx_cfg; 
                    end
                6'h03:  begin
                    axi_awaddr <= pause_srcad0_address; 
                    axi_wdata  <= pause_srcad_cfg[31:0]; 
                    end
                6'h04:  begin
                    axi_awaddr <= pause_srcad1_address; 
                    axi_wdata  <= {16'h0,pause_srcad_cfg[47:32]}; 
                    end
                6'h05:  begin
                    axi_awaddr <= flow_ctrl_address; 
                    axi_wdata  <= flow_ctrl_cfg; 
                    end
                6'h06:  begin
                    axi_awaddr <= ad_filter_mode_address; 
                    axi_wdata  <= ad_filter_mode_cfg; 
                    end
                6'h07:  begin
                    axi_awaddr <= unicast_ad0_address; 
                    axi_wdata  <= unicast_ad_cfg[31:0]; 
                    end
                6'h08:  begin
                    axi_awaddr <= unicast_ad1_address; 
                    axi_wdata  <= {16'h0,unicast_ad_cfg[47:32]}; 
                    end
				6'h09:  begin
                    axi_awaddr <= ad_table1_address; 
                    axi_wdata  <= {16'hf,ad_table15_cfg[47:32]}; 
                    end
                6'h0A:  begin
                    axi_awaddr <= ad_table0_address; 
                    axi_wdata  <= ad_table15_cfg[31:0]; 
                    end
                6'h0B:  begin
                    axi_awaddr <= ad_table1_address; 
                    axi_wdata  <= {16'he,ad_table14_cfg[47:32]}; 
                    end
                6'h0C:  begin
                    axi_awaddr <= ad_table0_address; 
                    axi_wdata  <= ad_table14_cfg[31:0]; 
                    end
				6'h0D:  begin
                    axi_awaddr <= ad_table1_address; 
                    axi_wdata  <= {16'hd,ad_table13_cfg[47:32]}; 
                    end
                6'h0E:  begin
                    axi_awaddr <= ad_table0_address; 
                    axi_wdata  <= ad_table13_cfg[31:0]; 
                    end
				6'h0F:  begin
                    axi_awaddr <= ad_table1_address; 
                    axi_wdata  <= {16'hc,ad_table12_cfg[47:32]}; 
                    end
                6'h10:  begin
                    axi_awaddr <= ad_table0_address; 
                    axi_wdata  <= ad_table12_cfg[31:0]; 
                    end
                6'h11:  begin
                    axi_awaddr <= ad_table1_address; 
                    axi_wdata  <= {16'hb,ad_table11_cfg[47:32]}; 
                    end
                6'h12:  begin
                    axi_awaddr <= ad_table0_address; 
                    axi_wdata  <= ad_table11_cfg[31:0]; 
                    end
                6'h13:  begin
                    axi_awaddr <= ad_table1_address; 
                    axi_wdata  <= {16'ha,ad_table10_cfg[47:32]}; 
                    end
                6'h14:  begin
                    axi_awaddr <= ad_table0_address; 
                    axi_wdata  <= ad_table10_cfg[31:0]; 
                    end
				6'h15:  begin
                    axi_awaddr <= ad_table1_address; 
                    axi_wdata  <= {16'h9,ad_table9_cfg[47:32]}; 
                    end
                6'h16:  begin
                    axi_awaddr <= ad_table0_address; 
                    axi_wdata  <= ad_table9_cfg[31:0]; 
                    end
				6'h17:  begin
                    axi_awaddr <= ad_table1_address; 
                    axi_wdata  <= {16'h8,ad_table8_cfg[47:32]}; 
                    end
                6'h18:  begin
                    axi_awaddr <= ad_table0_address; 
                    axi_wdata  <= ad_table8_cfg[31:0]; 
                    end
                6'h19:  begin
                    axi_awaddr <= ad_table1_address; 
                    axi_wdata  <= {16'h7,ad_table7_cfg[47:32]}; 
                    end
                6'h1A:  begin
                    axi_awaddr <= ad_table0_address; 
                    axi_wdata  <= ad_table7_cfg[31:0]; 
                    end
                6'h1B:  begin
                    axi_awaddr <= ad_table1_address; 
                    axi_wdata  <= {16'h6,ad_table6_cfg[47:32]}; 
                    end
                6'h1C:  begin
                    axi_awaddr <= ad_table0_address; 
                    axi_wdata  <= ad_table6_cfg[31:0]; 
                    end
				6'h1D:  begin
                    axi_awaddr <= ad_table1_address; 
                    axi_wdata  <= {16'h5,ad_table5_cfg[47:32]}; 
                    end
                6'h1E:  begin
                    axi_awaddr <= ad_table0_address; 
                    axi_wdata  <= ad_table5_cfg[31:0]; 
                    end
				6'h1F:  begin
                    axi_awaddr <= ad_table1_address; 
                    axi_wdata  <= {16'h4,ad_table4_cfg[47:32]}; 
                    end
                6'h20:  begin
                    axi_awaddr <= ad_table0_address; 
                    axi_wdata  <= ad_table4_cfg[31:0]; 
                    end
                6'h21:  begin
                    axi_awaddr <= ad_table1_address; 
                    axi_wdata  <= {16'h3,ad_table3_cfg[47:32]}; 
                    end
                6'h22:  begin
                    axi_awaddr <= ad_table0_address; 
                    axi_wdata  <= ad_table3_cfg[31:0]; 
                    end
                6'h23:  begin
                    axi_awaddr <= ad_table1_address; 
                    axi_wdata  <= {16'h2,ad_table2_cfg[47:32]}; 
                    end
                6'h24:  begin
                    axi_awaddr <= ad_table0_address; 
                    axi_wdata  <= ad_table2_cfg[31:0]; 
                    end
				6'h25:  begin
                    axi_awaddr <= ad_table1_address; 
                    axi_wdata  <= {16'h1,ad_table1_cfg[47:32]}; 
                    end
                6'h26:  begin
                    axi_awaddr <= ad_table0_address; 
                    axi_wdata  <= ad_table1_cfg[31:0]; 
                    end
				6'h27:  begin
                    axi_awaddr <= ad_table1_address; 
                    axi_wdata  <= {16'h0,ad_table0_cfg[47:32]}; 
                    end   
                6'h28:  begin
                    axi_awaddr <= ad_table0_address; 
                    axi_wdata  <= ad_table0_cfg[31:0]; 
                    end
                    
                6'h29:  begin
                    axi_awaddr <= mdio_clk_address; 
                    axi_wdata  <= mdio_clk_cfg; 
                    end
                6'h2A:  begin
                    axi_awaddr <= mdio_we_data_address; 
                    axi_wdata  <= mdio_we1_data_cfg; 
                    end
				6'h2B:  begin
                    axi_awaddr <= mdio_ctrl_address; 
                    axi_wdata  <= mdio_we1_ctrl_cfg; 
                    end
                6'h2C:  begin                        //读启动
                    axi_awaddr <= mdio_ctrl_address; 
                    axi_wdata  <= mdio_rd1_ctrl_cfg; 
                    end
				default: begin
                    axi_awaddr <= 8'h0; 
                    axi_wdata  <= 32'h0; 
                    end
                endcase                                                               
	          end                                                   
	      end                                                       
	                                                                
      	                                       
	                          
    
     
    //----------------------------
	//写响应（b）通道
	//----------------------------

	//写响应通道提供有关写已提交到内存的反馈。 
    // bready将在数据和写入地址都已到达并被从机接受后发生，并可以保证随后没有启动的其他访问。
	// bresp位[1]用于指示整个写入突发期间来自互连或从属的任何错误。 本示例将捕获该错误。

	  always @(posedge m_axi_aclk)                                    
	  begin                                                                
	    if (m_axi_areset == 1 || init_txn_pulse == 1'b1)                                           
	      begin                                                            
	        axi_bready <= 1'b0;                                            
	      end                                                              
	    // 由主控器接受/确认带有axi_bready的信号灯，从机断言m_axi_bvalid                          
	   // else if (m_axi_bvalid && ~axi_bready) 
        else if (m_axi_awready && m_axi_wready)
	      begin                                                            
	        axi_bready <= 1'b1;                                            
	      end                                                              
	    // 一个时钟周期后置低                                  
	    //else if (axi_bready) 
         else if (m_axi_bvalid)
	      begin                                                            
	        axi_bready <= 1'b0;                                            
	      end                                                              
	    // retain the previous value                                       
	    else                                                               
	      axi_bready <= axi_bready;                                        
	  end                                                                  
	                                                                       
	//flag write errors                                                    
	// assign write_resp_error = (axi_bready & m_axi_bvalid & m_axi_bresp[1]);


	//=======================================================================
	// 读时序
	//======================================================================= 
	//----------------------------
	//读取地址通道
	//----------------------------
	//start_single_read触发新的读取事务。 
    //read_index是一个计数器，用于跟踪 已发出/已发起 的读取事务数

	  always @(posedge m_axi_aclk)                                                     
	  begin                                     
      if (m_axi_areset == 1 || init_txn_pulse == 1'b1)                                                       
	      begin                                                                        
	        read_index <= 0;                                                           
	      end                                                                          
	    // 表示用户逻辑提供了新的读取地址                                                     
	    else if (start_single_read)                                                    
	      begin                                                                        
	        read_index <= read_index + 1;                                              
	      end                                                                          
	  end                                                                              
	                                                                                   
	  // 当主机有一个有效的读取地址时，将声明一个新的axi_arvalid。  
      // start_single_read触发新的读取//事务                                                                   
	  always @(posedge m_axi_aclk)                                                     
	  begin                                                                            
	    if (m_axi_areset == 1 || init_txn_pulse == 1'b1)                                                       
	      begin                                                                        
	        axi_arvalid <= 1'b0;                                                       
	      end                                                                          
	    //表示用户逻辑可用新的读地址命令                 
	    else if (start_single_read)                                                    
	      begin                                                                        
	        axi_arvalid <= 1'b1;                                                       
	      end                                                                          
	    //raddress被互连/从设备接受（从设备发出m_axi_arready）    
	    else if (m_axi_arready && axi_arvalid)                                         
	      begin                                                                        
	        axi_arvalid <= 1'b0;                                                       
	      end                                                                          
	    // retain the previous value            
	  end                                                                              

	//--------------------------------
	//读取数据（和响应）通道
	//--------------------------------

	//读取数据通道返回读取请求的结果.当有有效的读取数据可用时，主机将通过断言axi_rready接受读取数据。

	  always @(posedge m_axi_aclk)                                    
	  begin                                                                 
	    if (m_axi_areset == 1 || init_txn_pulse == 1'b1)                                            
	      begin                                                             
	        axi_rready <= 1'b0;                                             
	      end                                                               
	    // 主机通过axi_rready接受/确认rdata / rresp ,从机声明m_axi_rvalid                           
	    //else if (m_axi_rvalid && ~axi_rready) 
        else if (m_axi_arready) 
	      begin                                                             
	        axi_rready <= 1'b1;                                             
	      end                                    
	    else if (m_axi_rvalid)                                                
	      begin                                                             
	        axi_rready <= 1'b0;                   
          end                                                               
	    // retain the previous value                                        
	  end                                                                   
	                                                                        
	// flag write errors                                                     
	// assign read_resp_error = (axi_rready & m_axi_rvalid & m_axi_rresp[1]);  

	//--------------------------------
	//用户逻辑:读取数据
	//--------------------------------

 /*	    配置地址
       tx_address 				= 8'h10
       rx_address 				= 8'h20
       pause_srcad0_address 	= 8'h30
       pause_srcad1_address 	= 8'h40
       speed_address 			= 8'h50
       flow_ctrl_address 		= 8'h60
       ad_filter_mode_address 	= 8'h70
       unicast_ad0_address 	    = 8'h80	
       unicast_ad1_address 	    = 8'h82	
       ad_table0_address 		= 8'h84
       ad_table1_address 		= 8'h86
       mdio_clk_address 		= 8'h90
       mdio_ctrl_address 		= 8'hA0
       mdio_rd_data_address 	= 8'hB0
       mdio_we_data_address 	= 8'hC0
 */
     
    // 根据需要针对不同的地址模式修改它们。

                                          
	  //read addresses                                              
	  always @(posedge m_axi_aclk)                                  
	      begin                                                     
	        if (m_axi_areset == 1  || init_txn_pulse == 1'b1)                                
	          begin                                                 
	            axi_araddr <= speed_address;
	          end                                                   
	          // 表示新的写地址/写数据,可由用户逻辑提供                            
	        //else if (m_axi_arready && axi_arvalid)
            else if (m_axi_rvalid && axi_rready)
	          begin
			  case(read_index)
              //6'h00:  axi_araddr <= speed_address;
				6'h01:  axi_araddr <= tx_address;
                6'h02:  axi_araddr <= rx_address;
                6'h03:  axi_araddr <= pause_srcad0_address;
                6'h04:  axi_araddr <= pause_srcad1_address;
                6'h05:  axi_araddr <= flow_ctrl_address;
                6'h06:  axi_araddr <= ad_filter_mode_address;
                6'h07:  axi_araddr <= unicast_ad0_address;
                6'h08:  axi_araddr <= unicast_ad1_address;
				6'h09:  axi_araddr <= ad_table1_address;  //读出为最近配置地址表的地址
                6'h0A:  axi_araddr <= ad_table0_address;
                6'h0B:  axi_araddr <= ad_table1_address;
                6'h0C:  axi_araddr <= ad_table0_address;
				6'h0D:  axi_araddr <= ad_table1_address;
                6'h0E:  axi_araddr <= ad_table0_address;
				6'h0F:  axi_araddr <= ad_table1_address; 
                6'h10:  axi_araddr <= ad_table0_address;
                6'h11:  axi_araddr <= mdio_clk_address; 
                6'h12:  axi_araddr <= mdio_rd_data_address; 

				default: axi_araddr <= 8'h0; 
               endcase    
              end                                                   
	      end                                                       
                                                               
	  always @(posedge m_axi_aclk)                                  
	      begin                                                     
	        if (m_axi_areset == 1  || init_txn_pulse == 1'b1)                                
	          begin                                                 
	            rd_data_val <= 32'h0;             
	          end                                                   
	          // 表示新的写地址/写数据,可由用户逻辑提供                            
	        else if (m_axi_rvalid && axi_rready)                    
	          begin                                                 
	            rd_data_val <= m_axi_rdata;
	          end                                                   
	      end 
          
    //====================================================    
	//实现命令接口状态机
    //====================================================
      
	  always @( posedge m_axi_aclk)                                                    
	  begin                                                                             
	    if (m_axi_areset == 1 )                                                     
	      begin                                                                         
	      // 复位条件
          // 复位条件下所有信号均分配有默认值          
	        master_state  		<= IDLE;                                            
	        start_single_write 	<= 1'b0;                                                 
	        write_issued  		<= 1'b0;                                                      
	        start_single_read  	<= 1'b0;                                                 
	        read_issued   		<= 1'b0;
            axi_txn_done_reg    <= 1'b0;
	      end                 
      else                                                                            
	      begin                                                                         
	       // state transition                                                          
	        case (master_state)                                                                                                                                
	         IDLE:                                                             
				// 声明 init_txn_pulse 时，此状态负责启动 axi事务 
	            if ( init_txn_pulse == 1'b1 )                                     
	              begin                                                                 
	                master_state        <= INIT_WRITE;
                    axi_txn_done_reg    <= 1'b0;
	              end                                                                   
	            else                                                                    
	              begin                                                                 
	                master_state  <= IDLE;                                    
	              end                                                                   
	                                                                                    
	         INIT_WRITE:                                                               
	            // 此状态负责发出start_single_write脉冲以启动写入事务。  
                // 发出写事务，直到断言last_write信号为止。  
                // 写控制器                                                     
	            if (writes_done)                                                        
	              begin                                                                 
	                master_state <= INIT_READ;                                     
	              end                                                                   
	            else                                                                    
	              begin                                                                 
	                master_state  <= INIT_WRITE;                                                                                                      
	                  if (~axi_awvalid && ~axi_wvalid && ~m_axi_bvalid && ~m_axi_bready && ~last_write && ~start_single_write && ~write_issued)
                      //if (m_axi_bvalid && ~last_write && ~start_single_write && ~write_issued)
	                    begin                                                           
	                      start_single_write <= 1'b1;                                   
	                      write_issued  <= 1'b1;                                        
	                    end                                                             
	                  //else if (axi_bready)
                      else if (m_axi_bvalid) 
	                    begin                                                           
	                      write_issued  <= 1'b0;                                        
	                    end                                                             
	                  else                                                              
	                    begin                                                           
	                      start_single_write <= 1'b0; //negate to generate a pulse      
	                    end                                                             
	              end                                                                   
	                                                                                    
	         INIT_READ:                                                                
	            // 此状态负责发出start_single_read脉冲以启动读取事务。  
                // 发出读事务，直到断言last_read信号为止。                           
	            // read controller                                                     
	             if (reads_done)                                                        
	               begin                                                                
	                 master_state      <= IDLE;
                     axi_txn_done_reg  <= 1'b1;
	               end                                                                  
	             else                                                                   
	               begin                                                                
	                 master_state  <= INIT_READ;                                      
	                                                                                    
	                 if (~axi_arvalid && ~m_axi_rvalid && ~axi_rready && ~last_read && ~start_single_read && ~read_issued)
	                   begin                                                            
	                     start_single_read <= 1'b1;                                     
	                     read_issued  <= 1'b1;                                          
	                   end      
                     //else if (axi_rready) 
                     else if (m_axi_rvalid)
	                   begin                                                            
	                     read_issued  <= 1'b0;                                          
	                   end                                                              
	                 else                                                               
	                   begin                                                            
	                     start_single_read <= 1'b0; //negate to generate a pulse        
	                   end                                                              
	               end                                                                  
	                                                                                                                               
	          default :                                                                
	             begin                                                                  
	               master_state  <= IDLE;                                     
	             end                                                                    
	        endcase                                                                     
	    end                                                                             
	  end //master_execution_proc                                                       
	                                                                                    
	  //终端写入次数                                                            
	                                                                                    
	  always @(posedge m_axi_aclk)                                                      
	  begin                                                                             
	    if (m_axi_areset == 1  || init_txn_pulse == 1'b1)                                                         
	      last_write <= 1'b0;    
        //最后一次写入应与写入地址就绪响应相关联       
	    else if ((write_index == we_transactions_num) && m_axi_awready)    //transactions_num值比 case(write_index)值加1            
	      last_write <= 1'b1;                                                           
	    else                                                                            
	      last_write <= last_write;                                                     
	  end                                                                               
	                                                                                    
	  //检查最后的写入完成。                                                
	                                                                                    
	  //此逻辑是用最后的写入响应来限定最后的写入计数。 这演示了如何确认是否已提交写入。                                                                      
	                                                                                    
	  always @(posedge m_axi_aclk)                                                      
	  begin                                                                             
	    if (m_axi_areset == 1  || init_txn_pulse == 1'b1)                                                         
	      writes_done <= 1'b0;                                                                                                                                     
	      //the writes_done should be associated with a bready response                 
	    else if (last_write && m_axi_bvalid && axi_bready)                              
	      writes_done <= 1'b1;                                                          
	    else                                                                            
	      writes_done <= writes_done;                                                   
	  end                                                                               
	                                                                                    
	//------------------                                                                
	//read example                                                                      
	//------------------                                                                
	                                                                                    
	//终端读取计数                                                               
	                                                                                    
	  always @(posedge m_axi_aclk)               
      begin                                                                             
	    if (m_axi_areset == 1  || init_txn_pulse == 1'b1)                                                         
	      last_read <= 1'b0;                                                            
	                                                                                    
	    //最后读取应与读取地址就绪响应相关联         
	    else if ((read_index == rd_transactions_num) && (m_axi_arready) )        // rd_transactions_num 值 比 case(read_index) 值加1      
	      last_read <= 1'b1;                                                            
	    else                                                                            
	      last_read <= last_read;                                                       
	  end                                                                               
	                                                                                    
	/*                                                                                  
	 检查最后的读取完成。                                                   
	                                                                                    
	 该逻辑是用最终的读取响应/数据来限定最后的读取计数。                                                                     
	 */                                                                                 
	  always @(posedge m_axi_aclk)                                                      
	  begin                                                                             
	    if (m_axi_areset == 1  || init_txn_pulse == 1'b1)                                                         
	      reads_done <= 1'b0;                                                                                                                                       
	    //reads_done应该与已读响应相关联                
	    else if (last_read && m_axi_rvalid && axi_rready)                               
	      reads_done <= 1'b1;                                                           
	    else                                                                            
	      reads_done <= reads_done;                                                     
	    end                                                                             
	                                    
	

endmodule
