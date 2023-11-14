from scapy.all import sniff, Ether, hexdump
import binascii

# 定义要匹配的特定MAC地址
target_mac = "DA:02:03:04:05:06"

# 定义回调函数来处理接收到的报文
def packet_callback(packet):
    # if Ether in packet and packet[Ether].src == target_mac:
    print("Received packet with source MAC address:", target_mac)
    # print(packet.summary())  # 打印报文摘要信息
    # packet.show() 
    # print(type(hexdump(packet, dump=True)))
    raw_data = bytes(packet)  # 获取报文的完整原始数据
    hex_data = binascii.hexlify(raw_data)  # 将原始数据转换为十六进制形式
    print(hex_data)
# 设置过滤条件，仅捕获源MAC地址为特定MAC地址的数据包
filter_condition = f"ether src {target_mac}"

# 监听网络接口，接收报文
sniff(filter=filter_condition, prn=packet_callback, iface="以太网")

# 以太网报文头占用14个字节。这包括目标MAC地址、源MAC地址和以太网类型字段。