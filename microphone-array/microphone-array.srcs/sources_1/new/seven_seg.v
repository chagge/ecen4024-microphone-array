`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2014 07:21:44 PM
// Design Name: 
// Module Name: seven_seg
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


module seven_seg(
    input clk,
    input [4:0] shift_val,
    input shift_ang,
    output reg [2:0] anode,
    output reg [6:0] segments
    );
    
    reg [2:0] anodestate;
    
    initial begin
        anodestate = 3'b011;
    end
    
    always @(posedge clk) begin
        anode = anodestate;
        
        case (anodestate)
            3'b011: begin
                segments = shift_ang ? 7'b011_1111 : 7'b111_1111;
                anodestate = 3'b101;
            end
            
            3'b101: begin
                //
                segments = 7'b111_1111;
                anodestate = 3'b110;
            end
            
            3'b110: begin
                //
                segments = 7'b111_1111;
                anodestate = 3'b011;
            end
            
            default: begin
                segments = 7'b111_1111;
                anodestate = 3'b011;
            end
        endcase
        
    end
    
    
endmodule
