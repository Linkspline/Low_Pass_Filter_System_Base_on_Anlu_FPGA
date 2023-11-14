`timescale 1ns / 1ns 


module uiuart_rx#
(
 parameter integer  BAUD_DIV     = 10416  //�����ʷ�Ƶ������BAUD_DIV=ϵͳʱ��Ƶ��/������-1 ����100Mϵͳʱ�ӣ�������115200 BAUD_DIV= 100_000_000/115200-1
)
(
input I_clk, //ϵͳʱ������
input I_uart_rx_rstn,//ϵͳ��λ����
input I_uart_rx,//uart rx �����ź�����
output [7:0] O_uart_rdata,//uart rx���յ����������
output O_uart_rvalid// uart rx ����������Ч�źţ���Ϊ1��ʱ��O_uart_rdata������Ч
);

localparam  BAUD_DIV_SAMP = (BAUD_DIV/8)-1;                            //��β��������ղ�����ϵ���İ˷�֮һ���в���

wire bps_en       ; //������ʹ���ź�
wire samp_en      ; //����ʹ���ź�
wire bit_cap_done ; //uart rx�����źŲ�����Ч�������
wire uart_rx_done ; //uart 1byte �������
wire bit_data     ; //���յ�1bit����
wire I_uart_rxnt  ; //I_uart_rxnt�������źż�⣬����Ϊ�͵�ƽ��������ܴ�����ʼλ(UART ��ʼλΪ�͵�ƽ)

reg [13:0]  baud_div = 14'd0;//�����ʷ�Ƶ������
reg [13:0]  samp_cnt = 14'd0;//����������
reg [4 :0]  I_uart_rx_r = 5'd0;//�첽�ɼ���μĴ�
reg [3 :0]  bit_cnt=4'd0;//bit ������
reg [3 :0]  cap_cnt=4'd0;//cap ������
reg [4 :0]  rx_bit_tmp = 5'd0;//rx_bit_tmp���ڶ�β�����ͨ������������ߵ�ƽ�����͵͵�ƽ�������жϱ��β����Ǹߵ�ƽ���ǵ͵�ƽ
reg [7 :0]  rx_data = 8'd0;//���ݽ��ռĴ���

reg bps_start_en_r = 1'b0;
reg bit_cap_done_r = 1'b0;
reg bps_start_en,start_check_done,start_check_failed;

assign bps_en       =   (baud_div == (BAUD_DIV - 1'b1));                     //���һ�β����ʴ����ź�
assign samp_en      =   (samp_cnt == (BAUD_DIV_SAMP - 1'b1 ));               //���һ�β����ʲ����ź�
assign bit_cap_done =   (cap_cnt  == 3'd7);//��������
assign uart_rx_done =   (bit_cnt  == 9)&&(baud_div == BAUD_DIV >> 1);//��ֹͣλ��ʼ����ǰ����֮һλ������uart_rx_done�źţ��Ա���ǰ׼��������һ�����ݵĽ���

assign bit_data     =   (rx_bit_tmp < 5'd15) ? 0 : 1; //rx_bit_tmp���ڶ�β�����ͨ������������ߵ�ƽ�����͵͵�ƽ�������жϱ��β����Ǹߵ�ƽ���ǵ͵�ƽ����߿���������
//����5���ź����ͣ��жϿ�ʼ����
assign I_uart_rxnt  =   I_uart_rx_r[4] | I_uart_rx_r[3] | I_uart_rx_r[2] | I_uart_rx_r[1] | I_uart_rx_r[0];
assign O_uart_rdata   =   rx_data;
assign O_uart_rvalid  =   uart_rx_done;   

//�����ʼ�����
always@(posedge I_clk)begin
    if(bps_start_en && baud_div < BAUD_DIV)                 //baud_div������Ŀ��ֵBAUD_DIV 
        baud_div <= baud_div + 1'b1;
    else 
        baud_div <= 14'd0;
end

//8bit����ʹ�ܣ�8�������ʲ�����Ҳ������������������ڲ���8��������
always@(posedge I_clk)begin
    if(bps_start_en && samp_cnt < BAUD_DIV_SAMP)             //bps_start_en�ߵ�ƽ��Ч����ʼ��bit���в�����samp_cnt��8���ڲ������ٶȶ�ÿ��bit����
        samp_cnt <= samp_cnt + 1'b1;                         //samp_cnt����+1       
    else 
        samp_cnt <= 14'd0;                                   //samp_cnt��������
end

//uart rx bus asynchronous to Synchronous
always@(posedge I_clk)begin 
    I_uart_rx_r <= {I_uart_rx_r[3:0],I_uart_rx};             //I_uart_rx�����ݴ���I_uart_rx_r���л���
end

//uart�����������
always@(posedge I_clk)begin
    if(I_uart_rx_rstn == 1'b0 || uart_rx_done || start_check_failed) //bps_start_en���͵������������λ��������ɡ�У��ʧ��
        bps_start_en    <= 1'b0;                                               //���ս���
    else if((I_uart_rxnt == 1'b0)&(bps_start_en==1'b0))//���жϵ�I_uart_rxnt == 1'b0����������֮ǰ����(bps_start_en==1'b0���������߿���)
        bps_start_en    <= 1'b1;//ʹ�ܲ����ʼ�����ʹ��
end

//uart��������ʹ��
always@(posedge I_clk)begin
        bps_start_en_r    <= bps_start_en;                              //bps_start_en�źŴ�һ�ģ�������������ز�׽
end

always@(posedge I_clk)begin
    if(I_uart_rx_rstn == 1'b0 || start_check_failed)begin//��ϵͳ��λ������start_check_failed������start_check_done��start_check_failed
        start_check_done    <= 1'b0;
        start_check_failed  <= 1'b0;
    end    
    else if(bps_start_en == 1'b1&&bps_start_en_r == 1'b0) begin//����⵽start�źţ�Ҳ����start_check_done��start_check_failed
        start_check_done    <= 1'b0;
        start_check_failed  <= 1'b0;
    end
    else if((bit_cap_done&&bit_cap_done_r==1'b0)&&(start_check_done == 1'b0))begin//��һ�������ʲ����������ж��Ƿ�һ����Ч����ʼλ�����������Ч�ģ�start_check_failed����Ϊ1
        start_check_failed <= bit_data ? 1'b1 : 1'b0;
        start_check_done   <= 1'b1;//�����Ƿ�start_check_failed==1����������start_check_done=1������start_check_failed==1������һ��ϵͳʱ������start_check_done=0
    end     
end

//bits ������
always@(posedge I_clk)begin
    if(I_uart_rx_rstn == 1'b0 || uart_rx_done || bps_start_en == 1'b0)//��λ��������ɡ��������߿���(bps_start_en == 1'b0),����bit_cnt
        bit_cnt   <= 4'd0;                                                    
    else if(bps_en)//ÿһ��bps_en��Ч����1
        bit_cnt <= bit_cnt + 1'b1;  // bit_cnt���������ڼ��㵱ǰ�����˵ڼ���bit 
end

//8�ι���������߿�����
always@(posedge I_clk)begin
    if(I_uart_rx_rstn == 1'b0 || bps_en == 1'b1 || bps_start_en == 1'b0) begin //��I_uart_rx_rstn=0����bps_en=1����bps_start_en==0������cap_cnt��rx_bit_tmp
        cap_cnt     <= 4'd0;
        rx_bit_tmp  <= 5'd15; 
    end
    else if(samp_en)begin//bit����ʹ��
        cap_cnt     <= cap_cnt + 1'b1;//cap_cnt���ڼ�¼�˵�ǰ�ǵڼ��ι�������1��bit����8��
        rx_bit_tmp  <= I_uart_rx_r[4] ? rx_bit_tmp + 1'b1 :  rx_bit_tmp - 1'b1;   //��β���������Ǹߵ�ƽ+1,����ǵ͵�ƽ-1�����տ�����bit��������rx_bit_tmp���С��15�����ǵ͵�ƽ
    end                                                                                   
end

//�Ĵ�һ��bit_cap_done�����ڲ����ߵ�ƽ�������������õ�
always@(posedge I_clk)
    bit_cap_done_r <= bit_cap_done;


always@(posedge I_clk)begin
    if(I_uart_rx_rstn == 1'b0 || bps_start_en == 1'b0)//����λ�������߿��У�����rx_data
        rx_data  <= 8'd0;  
    else if(start_check_done&&(bit_cap_done&&bit_cap_done_r==1'b0)&&bit_cnt < 9)//��start_check_done��Ч������bit_cnt<9,ÿ��bit_cap_done��Ч�����һ����λ�Ĵ�
        rx_data  <= {bit_data,rx_data[7:1]};                                         //����ת���������ݴ���rx_data �У���8λ
end

endmodule

