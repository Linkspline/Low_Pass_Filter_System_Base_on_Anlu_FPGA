from scapy.all import sniff, Ether, hexdump
import binascii
import numpy as np
import threading
import matplotlib.pyplot as plt
import matplotlib.animation as animation

fig, ax = plt.subplots()
ax.set_xlabel('Time')  
ax.set_ylabel('Value')

# 定义要匹配的特定MAC地址
target_mac = "DA:02:03:04:05:06"
HEAD = '002b67beceaada02030405060800'

# 全局最新数据buffer
BUFF_LEN = 355
# data_buff = np.zeros(BUFF_LEN)
data_buff = [0]*BUFF_LEN

# 绘制初始图表(只有x、y轴)
x=np.array(range(BUFF_LEN))
y=data_buff
line, = ax.plot(x, y)   
ax.set_xlim(0,BUFF_LEN)
ax.set_ylim(0,1<<16)

def update(i):
    x=np.array(range(BUFF_LEN))
    y=data_buff
    # print(y)
    line.set_xdata(x)
    line.set_ydata(y)
    fig.canvas.draw()
    
# 定义回调函数来处理接收到的报文
def packet_callback(packet):
    global data_buff
    # print("Received packet with source MAC address:", target_mac)
    raw_data = bytes(packet)  # 获取报文的完整原始数据
    hex_data = binascii.hexlify(raw_data).decode('utf-8')  # 将原始数据转换为十六进制形式
    # print(len(hex_data),hex_data)
    if (HEAD in hex_data):
        recv_data = hex_data[28:]
    else:
        recv_data = hex_data
    if (len(recv_data)<=100):
        return 
    # print(len(recv_data),recv_data)
    recv_data_dec = []
    for i in range(0,len(recv_data),4):
        recv_data_dec.append(int(recv_data[i:i+4],16))
    
    data_buff = data_buff[0:(BUFF_LEN-len(recv_data_dec))]+recv_data_dec
    # data_buff[0:(BUFF_LEN-len(recv_data_dec))] = data_buff[len(recv_data_dec):BUFF_LEN]
    # data_buff[-len(recv_data_dec):] = np.array(recv_data_dec)
    # print(data_buff)

# 设置过滤条件，仅捕获源MAC地址为特定MAC地址的数据包
filter_condition = f"ether src {target_mac}"

# 监听网络接口，接收报文
def packet_sniffer():
    sniff(filter=filter_condition, prn=packet_callback, iface="以太网")

# 创建一个线程来运行报文捕获
sniffer_thread = threading.Thread(target=packet_sniffer)

# 启动报文捕获线程
sniffer_thread.start()

# 在主线程中可以继续进行其他操作，同时报文捕获线程会异步执行
ani = animation.FuncAnimation(fig,update,interval=3000)
plt.show()