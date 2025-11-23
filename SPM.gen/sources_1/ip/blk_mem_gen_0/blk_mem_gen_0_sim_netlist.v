// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Sun Jul 20 20:38:28 2025
// Host        : LAPTOP-B677N4DE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/M.tech/Seminar/SPM/SPM.gen/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module blk_mem_gen_0
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [1:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [23:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [23:0]douta;

  wire [1:0]addra;
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
  wire [1:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [23:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "2" *) 
  (* C_ADDRB_WIDTH = "2" *) 
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
  (* C_INIT_FILE = "blk_mem_gen_0.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_gen_0.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "4" *) 
  (* C_READ_DEPTH_B = "4" *) 
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
  (* C_WRITE_DEPTH_A = "4" *) 
  (* C_WRITE_DEPTH_B = "4" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "24" *) 
  (* C_WRITE_WIDTH_B = "24" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_0_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0}),
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
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[1:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[1:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19744)
`pragma protect data_block
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
zLE4hBQqDKynOcng6Xfk4J+QxJWjWQ==
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
