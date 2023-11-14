import tkinter as tk
from matplotlib.figure import Figure
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import numpy as np
import time

# 创建一个简单的函数，用于生成示例图像
def update_plot(y):
    x = np.linspace(0, 2 * np.pi, 100)
    # y = np.sin(x)
    ax.clear()
    ax.plot(x, y)
    canvas.draw()

# 创建一个GUI窗口
root = tk.Tk()
root.title("图像更新示例")

# 创建Matplotlib图形和画布
fig = Figure(figsize=(5, 4), dpi=100)
ax = fig.add_subplot(111)
canvas = FigureCanvasTkAgg(fig, master=root)
canvas.get_tk_widget().pack()

# 初始化图像显示
update_plot(np.random.randint(0,100,100))

# 在程序内部调用update_plot函数来更新图像
# 你可以在需要的时候调用此函数来触发图像更新
# 例如，你可以在程序的其他部分根据某些条件来调用它
while(1):
    time.sleep(2)
    update_plot(np.random.randint(0,100,100))

# 进入Tkinter主循环
root.mainloop()
