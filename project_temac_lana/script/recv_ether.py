from scapy.all import sniff, Ether, hexdump
import binascii
import numpy as np
import threading
import matplotlib.pyplot as plt
import pyqtgraph as pg
from PyQt6.QtWidgets import QApplication
from scipy.fft import fft

app = QApplication([])  # 创建QApplication实例
win = pg.GraphicsLayoutWidget()
win.setWindowTitle(u'波形显示')
p = win.addPlot()#win.addPlot()添加一个波形窗口，多次调用会将窗口分成多个界面
p.addLegend() #不添加就显示不了图例 ，一定要放在plot前调用
curve = p.plot(pen = 'b',name='signal')#为新的变量添加新的曲线

DIS_LEN = 300 # 页面最多显示数据
#配置波形显示信息
def DisplayConfig():   
    p.showGrid(x=True,y=True, alpha=0.5)
    p.setLabels(left='y/V',bottom='x/point',title='imu')#left纵坐标名 bottom横坐标名
    label = pg.TextItem()
    p.addItem(label)
    
# 定义要匹配的特定MAC地址
target_mac = "DA:02:03:04:05:06"
HEAD = '002b67beceaada02030405060800'

# 全局最新数据buffer
BUFF_LEN = 80000
DIS_LEN = 200
data_buff = np.zeros(BUFF_LEN)
# data_buff = [0]*BUFF_LEN

freq_buff = np.zeros(100)
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
    # 找到编码方式
    # for i in range(0,8,2):
    #     tmpd1=int(recv_data[i+6:i+8]+recv_data[i+4:i+6]+recv_data[i+2:i+4]+recv_data[i:i+2],16)
    #     tmpd2=int(recv_data[i+14:i+16]+recv_data[i+12:i+14]+recv_data[i+10:i+12]+recv_data[i+8:i+10],16)
    #     if (tmpd1+1==tmpd2):
    #         recv_data=recv_data[i:]
    # print(len(recv_data),recv_data)
    recv_data_dec = []
    for i in range(0,len(recv_data),8):
        tmpd = int(recv_data[i+6:i+8]+recv_data[i+4:i+6]+recv_data[i+2:i+4]+recv_data[i:i+2],16)%BUFF_LEN
        if tmpd>140 or tmpd<80:
            break 
        recv_data_dec.append(tmpd)
    with open('data.txt','a') as f:
        for d in recv_data_dec:
            f.write(str(d)+' ')
    # data_buff = data_buff[0:(BUFF_LEN-len(recv_data_dec))]+recv_data_dec
    if (len(recv_data_dec)>=BUFF_LEN):
        data_buff = np.array(recv_data_dec[-BUFF_LEN:])
    elif (len(recv_data_dec)>0):
        data_buff[0:-len(recv_data_dec)] = data_buff[len(recv_data_dec):BUFF_LEN]
        data_buff[-len(recv_data_dec):] = np.array(recv_data_dec)
    # print(data_buff)
    # 计算频率
    # N = len(data_buff)  # 数据点的数量
    # print("data_len: ", N)
    # T = 1.0 / N  # 采样间隔
    # yf = fft(data_buff)
    # xf = np.fft.fftfreq(N, T)[:N // 2]
    # index = np.argmax(np.abs(yf[:N // 2]))
    # frequency = xf[index]
    # print("frequency: ", list(xf))
    # with open('tmp.txt', 'w') as f:
    #     f.write(str(list(xf)))
    # # print("frequency: ", frequency)
    start=0
    end=0
    flag=0
    mm=max(data_buff[-DIS_LEN:])
    tmpi=0
    for v in data_buff[-DIS_LEN:]:
        tmpi+=1
        if (v>=mm-3):
            if (flag==0):
                start = tmpi
                flag = 1
            elif (flag==2):
                end = tmpi
                break
        elif (flag==1):
            flag = 2
    
    print(end-start)
        

    

# 设置过滤条件，仅捕获源MAC地址为特定MAC地址的数据包
filter_condition = f"ether src {target_mac}"

# 监听网络接口，接收报文
def packet_sniffer():
    sniff(filter=filter_condition, prn=packet_callback, iface="以太网")

# 创建一个线程来运行报文捕获
sniffer_thread = threading.Thread(target=packet_sniffer)

# 启动报文捕获线程
sniffer_thread.start()

 
def addToDisplay():
    global data_buff
    curve.setData(data_buff[-DIS_LEN:])#添加数据显示
    
timer = pg.QtCore.QTimer()
timer.timeout.connect(addToDisplay) #定时刷新数据显示
timer.start(30)
win.show()  # 显示窗口
app.exec()  # 开始Qt事件循环