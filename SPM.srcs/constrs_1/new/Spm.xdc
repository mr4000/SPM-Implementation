## Clock Constraint
set_property PACKAGE_PIN H16 [get_ports clk]        ;# Replace W5 with actual pin
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 100 -name clk [get_ports clk]  ; #100 MHz clock
