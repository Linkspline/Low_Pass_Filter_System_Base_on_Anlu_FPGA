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

module client_FIFO 
 #(
    parameter FULL_DUPLEX_ONLY = 0
  )

  (
    // Transmit FIFO MAC TX Interface
    input         tx_reset,            // 同步复位(tx_clk)
    input         tx_clk,              // MAC发送时钟
    input         tx_clk_en,           // tx_clk的时钟使能
    output [7:0]  tx_data,             // 数据到MAC发送器
    output        tx_data_en,          // 有效信号到MAC发送器
    input         tx_rdy,              // 来自MAC发送器的rdy信号
  //output        tx_stop,             // 终止信号到MAC发送器
    input         tx_collision,        // 来自MAC发送器的冲突信号
    input         tx_retransmit,       // 来自MAC发送器重新发送信号

    // Transmit FIFO Local-link Interface
    input         tx_ll_clock,         // FIFO写时钟
    input         tx_ll_reset,         // 同步复位（tx_ll_clock）
    input  [7:0]  tx_ll_data_in,       // 数据发送到FIFO
    input         tx_ll_sof_in_n,      // FIFO的SOF指示
    input         tx_ll_eof_in_n,      // FIFO的eof指示
    input         tx_ll_src_rdy_in_n,  // src Reddy 指示信号到FIFO
    output        tx_ll_dst_rdy_out_n, // FIFO的dst ready指示
    output [3:0]  tx_fifo_status,      // FIFO存储器状态
    output        tx_overflow,         // FIFO的溢出指示信号

    // Receive FIFO MAC RX Interface
    input         rx_reset,            // 同步复位（rx_clk）
    input         rx_clk,              // MAC接收时钟
    input         rx_clk_en,           // rx_clk的时钟使能
    input  [7:0]  rx_data,             // 来自MAC接收器的数据
    input         rx_data_valid,       // 来自MAC接收器的有效信号
    input         rx_correct_frame,    // 来自MAC接收器的正确帧指示
    input         rx_error_frame,      // 来自MAC接收器的错误帧指示
    output        rx_overflow,         // FIFO的溢出指示信号

    // Receive FIFO Local-link Interface
    input         rx_ll_clock,         // FIFO读取时钟
    input         rx_ll_reset,         // 同步复位（rx_ll_clock）
    output [7:0]  rx_ll_data_out,      // 来自Rx FIFO的数据
    output        rx_ll_sof_out_n,     // FIFO中的sof指示
    output        rx_ll_eof_out_n,     // FIFO的eof指示
    output        rx_ll_src_rdy_out_n, // FIFO的src ready指示
    input         rx_ll_dst_rdy_in_n,  // dst ready 指示信号到FIFO
    output [3:0]  rx_fifo_status       // FIFO存储器状态
  );


  // assign tx_stop = 1'b0;


  //----------------------------------------------------------------------------
  // Instantiate the Transmitter FIFO
  //----------------------------------------------------------------------------
  tx_client_fifo #
  (
    .FULL_DUPLEX_ONLY (FULL_DUPLEX_ONLY)
  )
  tx_fifo
  (
    .rd_clk           (tx_clk),
    .rd_sreset        (tx_reset),
    .rd_enable        (tx_clk_en),
    .tx_data          (tx_data),
    .tx_data_valid    (tx_data_en),
    .tx_ack           (tx_rdy),
    .tx_collision     (tx_collision),
    .tx_retransmit    (tx_retransmit),
    .overflow         (tx_overflow),
    .wr_clk           (tx_ll_clock),
    .wr_sreset        (tx_ll_reset),
    .wr_data          (tx_ll_data_in),
    .wr_sof_n         (tx_ll_sof_in_n),
    .wr_eof_n         (tx_ll_eof_in_n),
    .wr_src_rdy_n     (tx_ll_src_rdy_in_n),
    .wr_dst_rdy_n     (tx_ll_dst_rdy_out_n),
    .wr_fifo_status   (tx_fifo_status)
  );


  //----------------------------------------------------------------------------
  // Instantiate the Receiver FIFO
  //----------------------------------------------------------------------------
  rx_client_fifo rx_fifo
  (
    .wr_clk           (rx_clk),
    .wr_enable        (rx_clk_en),
    .wr_sreset        (rx_reset),
    .rx_data          (rx_data),
    .rx_data_valid    (rx_data_valid),
    .rx_good_frame    (rx_correct_frame),
    .rx_bad_frame     (rx_error_frame),
    .overflow         (rx_overflow),
    .rd_clk           (rx_ll_clock),
    .rd_sreset        (rx_ll_reset),
    .rd_data_out      (rx_ll_data_out),
    .rd_sof_n         (rx_ll_sof_out_n),
    .rd_eof_n         (rx_ll_eof_out_n),
    .rd_src_rdy_n     (rx_ll_src_rdy_out_n),
    .rd_dst_rdy_n     (rx_ll_dst_rdy_in_n),
    .rx_fifo_status   (rx_fifo_status)
  );


endmodule
