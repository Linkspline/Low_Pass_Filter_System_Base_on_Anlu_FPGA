create_clock -name clkin -period 10 -waveform {0 5} [get_ports {sysclk_P}]
 
create_clock -name rgmii_rx_clk    -period 8 -waveform {0 4} [get_ports {rgmii_rxc}]
 
create_generated_clock -name CLK125 	-source [get_ports {sysclk_P}] -master_clock {clkin} -phase 0  -multiply_by 1.25 [get_nets {gtx_clk}]
#create_generated_clock -name CLK125_90  -source [get_ports {sysclk_P}] -master_clock {clkin} -phase 90 -multiply_by 1.25 [get_nets {gtx_clk90}]
create_generated_clock -name CLK50      -source [get_ports {sysclk_P}] -master_clock {clkin} -phase 0  -multiply_by 0.5  [get_nets {s_axi_aclk}]

set_clock_groups -exclusive -group [get_clocks {CLK125}]  -group [get_clocks {CLK50}] -group [get_clocks {rgmii_rx_clk}] -group [get_clocks {clkin}]

#set_clock_groups -exclusive -group [get_clocks {CLK125}] [get_clocks {CLK125_90}]  -group [get_clocks {CLK50}] -group [get_clocks {rgmii_rx_clk}] -group [get_clocks {clkin}]


#set_input_delay -clock [get_clocks {rgmii_rx_clk}] -max 3.0 [get_ports {rgmii_rx_ctl rgmii_rxd[0] rgmii_rxd[1] rgmii_rxd[2] rgmii_rxd[3]}]
#set_input_delay -clock [get_clocks {rgmii_rx_clk}] -min 1.0 [get_ports {rgmii_rx_ctl rgmii_rxd[0] rgmii_rxd[1] rgmii_rxd[2] rgmii_rxd[3]}]
#set_input_delay -clock [get_clocks {rgmii_rx_clk}] -max 3.0 [get_ports {rgmii_rx_ctl rgmii_rxd[0] rgmii_rxd[1] rgmii_rxd[2] rgmii_rxd[3]}] -clock_fall -add_delay
#set_input_delay -clock [get_clocks {rgmii_rx_clk}] -min 1.0 [get_ports {rgmii_rx_ctl rgmii_rxd[0] rgmii_rxd[1] rgmii_rxd[2] rgmii_rxd[3]}] -clock_fall -add_delay

#set_false_path -setup -rise_from [get_clocks {rgmii_rx_clk}] -rise_to [get_clocks {rgmii_rxc}]
#set_false_path -setup -fall_from [get_clocks {rgmii_rx_clk}] -fall_to [get_clocks {rgmii_rxc}]
#set_false_path -hold  -rise_from [get_clocks {rgmii_rx_clk}] -fall_to [get_clocks {rgmii_rxc}]
#set_false_path -hold  -fall_from [get_clocks {rgmii_rx_clk}] -rise_to [get_clocks {rgmii_rxc}]

#set_multicycle_path -setup -rise_from [get_clocks {rgmii_rx_clk}] -to [get_clocks {rgmii_rxc}]  0
#set_multicycle_path -hold  -from [get_clocks {rgmii_rx_clk}] -to [get_clocks {rgmii_rxc}] -1


#set_multicycle_path -rise_from [get_clocks rgmii_rx_clk] -fall_to [get_clocks {rgmii_rxc}] -setup  0
#set_multicycle_path -fall_from [get_clocks rgmii_rx_clk] -rise_to [get_clocks {rgmii_rxc}] -setup  0

#set_multicycle_path -rise_from [get_clocks rgmii_rx_clk] -rise_to [get_clocks {rgmii_rxc}] -hold  0 -end
#set_multicycle_path -fall_from [get_clocks rgmii_rx_clk] -fall_to [get_clocks {rgmii_rxc}] -hold  0 -end

#create_generated_clock  -name clk125 -source [get_ports {sysclk_P}] -master_clock clkin -multiply_by 1.25  [get_nets {gtx_clk}]
#create_generated_clock  -name clk50  -source [get_ports {sysclk_P}] -master_clock clkin -divide_by 2 [get_nets {s_axi_aclk}]

#set_false_path  -from [get_clocks {clk50}] -to [get_clocks {clk125}]