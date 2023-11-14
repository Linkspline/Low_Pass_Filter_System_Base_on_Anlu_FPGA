from scapy.all import Ether, IP, UDP, Raw, sendp
import binascii
import time
# 创建一个以太网帧
eth_frame = Ether(dst="00:2B:67:BE:CE:AA", src="DA:02:03:04:05:06")

# 创建一个IP数据包
ip_packet = IP(src="192.168.1.1", dst="192.168.1.200")

# 创建一个UDP数据包
udp_packet = UDP(sport=12345, dport=54321)

# 添加数据内容
data=''
for i in range(1000):
    data+='0'*(6-len(hex(i)))+hex(i)[2:]
    # data = (data<<32)+hex(i)
data = bytes(data,'utf-8')
# print(data)
data_packet = Raw(load=data)

# 组装数据包
packet = eth_frame / ip_packet / udp_packet / data_packet
raw_data = bytes(packet)  # 获取报文的完整原始数据
hex_data = binascii.hexlify(raw_data)  # 将原始数据转换为十六进制形式
print(hex_data)
# b'da0203040506002b67beceaa080045000035000100004011f69dc0a80101c0a801c83039d4310021b8b65468697320697320796f757220637573746f6d20646174612e'
# 发送数据包
while (1):
    time.sleep(1)
    sendp(packet, iface="以太网")

