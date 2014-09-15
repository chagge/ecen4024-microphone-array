`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2014 05:34:33 PM
// Design Name: 
// Module Name: delta_sigma
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


module delta_sigma(
    input [15:0] din,
    input clk_i,
    output reg dout
    );
    
    // PWM module to take in PWM data and play it out on a one line speaker
    // mainly taken from:
    // http://www.fpga4fun.com/PWM_DAC.html
    
    // sigma delta PWM
    reg [16:0] PWM_accumulator;
    
    always @(posedge clk_i) begin
        PWM_accumulator[16:0] = PWM_accumulator[15:0] + {~din[15], din[14:0]}; // plus sigma
        dout = PWM_accumulator[16];
        //PWM_accumulator[16] = 0;        // delta : subtract 256
    end

endmodule
