// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Sat Jul 19 17:20:41 2025
// Host        : LAPTOP-B677N4DE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top blk_mem_gen_1 -prefix
//               blk_mem_gen_1_ blk_mem_gen_1_sim_netlist.v
// Design      : blk_mem_gen_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_1,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module blk_mem_gen_1
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [2:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [23:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [23:0]douta;

  wire [2:0]addra;
  wire clka;
  wire [23:0]dina;
  wire [23:0]douta;
  wire ena;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [23:0]NLW_U0_doutb_UNCONNECTED;
  wire [2:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [2:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [23:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "3" *) 
  (* C_ADDRB_WIDTH = "3" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     3.20565 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_1.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_gen_1.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "8" *) 
  (* C_READ_DEPTH_B = "8" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "24" *) 
  (* C_READ_WIDTH_B = "24" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "8" *) 
  (* C_WRITE_DEPTH_B = "8" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "24" *) 
  (* C_WRITE_WIDTH_B = "24" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_1_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[23:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[2:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[2:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[23:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.2"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
QGLtnqZzRetDH6gCWT4Js6wuLlZfrNx/VJp3sfR2NF+cxypO5AxN0oDKLJJtmdrtE/ueNDg+Qf7Z
TqBNRojORA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
B6Ger3hRvfjHkaJ+W8639Kl3TzC9TogLuklOXEiMNdc4Im+DjEUzxb3DKlzu0VW3zxZqjJ3+wsW/
LnRmPCESi5Y9eRJaLFXg79EMfoj4X+nTdHAP6yCfltBADKegZ12gpnB/8ey5yn2KA74LUtPC7jna
iyjqSfsWLGnz6UdXzwk=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BX+DxgMPRyZbYojCUR9Sk8Lq+3ZigBz4yMFHQkmurfdfDzyTPJCE827eGiPyTenK1QPVhEtf9g06
0BFXq/0COPuU1BWJwdkz1c4dE6/exDwhvEh+hPx3vRY6z8fDEf6aGVIXrHDvrmddehe7yMSIpo+k
aXHR06EEdfHCFY4TggYwhcJVXjkE+ApsVuyfmEfPmYjo8hCWyQyBsUWIOY03q1+MvUjjsmTwgs9g
fh5MY9ToaLfoJxPKdCpsqrBX4LJ+VDGFlAqIcqHTE2jCmPiToZAFXB7fzf1wDjFCBlJyFVDBGi0i
m+CouLSb7X1mvVhdDZgNrZDJMV688Bu3o54vew==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
DaIU/Ddc8USbZ2mURzujJDWDH1JbHl5tFVOOQ2aVaUPIA71yyE38OXVLEtF8rNmujYH30nEeQ+FV
LVJ16aaHw+iiuaqorTM3K5KLohVlN+WlcEtSXHuPNHjw8ddqtzpaX7pH1zqZH+YmfCL5oaNLqDH4
rkBnUl0/Gm/hzSwKjYhXGQFYQ+gGP99OjXakzrAqZzp/Iq4gt+Z5902/JV9thd/isHQImJ0QyK8M
EKM579iPAfXGes2mbiNYHcvDmSPYmW1zlhOE++N1EKeea7j/msnKeyhlC+hGE4Xfn4TVvqgQexCT
rp/wS/MosY6WH1aKFQlFH2hEppA7KXUaQlvG+w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
XmWoAt4X8hrCJ5yTyug4ajJW5UhfkLNibzjihWzZ4Cr9hQSvWZoTc8rjGsLPbz6Le+/9iI5KxecS
eR0wiAO+G2IkwhZgVBeZdKoFnlnTVAyLjk9wMAFXNyJZM6b1NDbfXlPcUsC6JePvPlwwdWknkSsC
r3KvgkWAS+O3xvRmaNw=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Hw3Y+rShKrXiUViyNU1/O2qv6TgheLHBnFMj1i9MUGrHYqh9pLfLYUgWR7S2vj4jv4S+Ks0BpP4p
dKEqVAFmTCfQNEUHaVcFPkOHgig6L4mhLY6HUUKJoRgiQepgLi/W3V+ZZPQSQFkB3CU4MsJzhXvR
yLcpDriZy8cnAHD87Zi5DrNGBzj3kigJeM0du6lCQbxtF5aEdoaNP+YTnIFtcqYhoYnswQlYt0sV
HKgFA8VzqzL5WYnpH7+1IKmFkJBHkyqHCa9wPK0qCKnxkuDj70YzPVqQ+cocdKU+/gNdpCOdZlci
F2HTxrgfrXndJru3TiDqu4UavqAe0MNuFp3t0w==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XPVggoWL6aXz+MpODTOZhEUQDa0vfEnUDaYeEHXm2vGyqKJujN2c/FFAFBeBYdJATLsIsQ+BqoPc
pBbcFYXDBfOtFIW2dH6Y1OoD65KyJ/hAq8coa21kFgq4hFat5vzZ2iIfkCpTUr4vDZO7Xne8cZO9
WsHffoTCt5rS59wWm2b8I5R8Eh2TUbQg3RCyrcnD66cvcEnlXe1CNMQ4/loVJpA4IBinBf820Wjc
vw2fZbGI0jXC+ACSHOviH63Xwmn+aRV5Ppkup7IYoon/ieKapRQeASu3TTY37xSBXiInSdtMTzJ6
+4GfO4eSHVriCk/sWbuTBzfRzoSShrnHjzz5LA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2020_08", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
L78XuiswVcgO2gtebzL7SA9BC/jJGAM0v6S9pzmyqL+QYzRneiYeGyDmsW33jEVVSTuNjTXkBLY7
yTOKQruatwe4V0OLi6174saSAmPgerSV1GyLP7KhmusLV/N61avC9TPam+tekhKeE0tds4EnJ3et
4JdLh+SE4Z4pcuqCjB5MFneIYKKWDx7siU6oesAQtoSJOesfMchX63MhOjOHFP/ch+1gHv3T45hg
IGF7V7TrdREVE4f9631tlVJ1o2Dypsmo/76Itz5WCGlTMjAnWXN8IXxKN+PZ3dyt1wjrZm2P/td+
xiGszFnSLrRvw/HferwtSmRx8q0fiHZ88roGTw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kDX5kq2QEe25429T6vQqBCFvV1McKTJRYfK99ymVNK2GGvGLXSzgwJHwB2fj9rM0wme3zYYY0vQR
x+9F4L7KLlOVY6qY3LB59uDzyXBI3mMZaS905HXHJkdZHWtQWpfHhl27LqL+8FSluaD6F+KFfYOV
CwIOVuCIp/XjxFXpNBik7YiPt4kHOlDA97IXNLnYUn/g1csGqeNWce4UTne50ggWvLYGbTFGmTjT
N67TpUiGRVRCSv8Tax72GWFIMFZk3Tlp68ZUSQEybZMWX1U9XdMdtxfvNGhf8mi5jQJ2SupSzKu4
T/+53IN9T8aLePAiGBKKG1ZBj4y1ZyYA7XYvjw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19520)
`pragma protect data_block
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
+yim+Nz8JkkrXvJTl0FsYQ8buCUT6wsCO9g=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
