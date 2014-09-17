// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.2 (win64) Build 932637 Wed Jun 11 13:33:10 MDT 2014
// Date        : Tue Sep 16 15:35:19 2014
// Host        : ECE-411-6 running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.srcs/sources_1/ip/cascaded_integrator_comb/cascaded_integrator_comb_stub.v
// Design      : cascaded_integrator_comb
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "cic_compiler_v4_0,Vivado 2014.2" *)
module cascaded_integrator_comb(aclk, s_axis_data_tdata, s_axis_data_tvalid, s_axis_data_tready, m_axis_data_tdata, m_axis_data_tvalid)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_data_tdata[7:0],s_axis_data_tvalid,s_axis_data_tready,m_axis_data_tdata[23:0],m_axis_data_tvalid" */;
  input aclk;
  input [7:0]s_axis_data_tdata;
  input s_axis_data_tvalid;
  output s_axis_data_tready;
  output [23:0]m_axis_data_tdata;
  output m_axis_data_tvalid;
endmodule
