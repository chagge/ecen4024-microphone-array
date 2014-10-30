`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2014 06:46:15 PM
// Design Name: 
// Module Name: mic_bram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mic_bram(
    input clk,
    input [6:0] addr_i,
    input [6:0] addr_o,
    input [15:0] data_i,
    output reg [15:0] data_o
    );
    
    // 128 slots for buffer.
    // with a 30 in wide array, and mics sampling at 48kHz, 107 buffered values
    // will allow for full 90 degree beamforming.
    // round up to power of two -> 128, therefore 7 bit address.
    reg [15:0] reg_array [127:0];
    
    always @(negedge clk) begin
        reg_array[addr_i] <= data_i;
        data_o <= reg_array[addr_o];
    end
    
endmodule
