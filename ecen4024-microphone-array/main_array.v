`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:24:45 09/11/2014 
// Design Name: 
// Module Name:    main_array 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module main_array(clk, mic_clk, mic_data);

input clk;
output reg mic_clk;
input mic_data;


// 50 MHz on clk input
// we want around 3 MHz for mic clocks
// 50 MHz/16 = 3.125 MHz
reg [8:0] clk_divider;

reg [1:0] mic_datum;
reg cic_rfd;
reg cic_rdy;

wire [21:0] cic_output;

cic_compiler_v2_0 cic_filter(.rfd(), .rdy(), .clk(mic_clk), .dout(cic_output), .din(mic_datum));
half_band_filter  hb_filter(.rfd(), .rdy(), .clk(mic_clk), .dout(), .din(cic_output));

initial begin
   mic_datum = 2'b11;
	clk_divider = 0;
end


always @(posedge clk) begin
	// clock divide down to 6.25 mhz, then toggle at that speed to get 3.125 MHz
	clk_divider = clk_divider + 1;
	if (clk_divider == 8) begin
		clk_divider = 0;
		mic_clk = ~mic_clk;
	end
	
end

always @(posedge mic_clk) begin
	mic_datum[1] <= mic_data;
end


endmodule
