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
    input [4:0] vshift_val,
    input vshift_ang,
    output reg [7:0] anode,
    output reg [7:0] segments
    );
    
    reg [7:0] anodestate;
    reg [7:0] gotostate;
    
    initial begin
        anode = {8 {1'b1}};
        anodestate = 8'b10111111;
        gotostate = 8'b10111111;
    end
    
    always @(posedge clk) begin
        anode = anodestate;
        case (anode)
            // vertical shift display
            8'b10111111: begin
                segments = vshift_ang ? 8'b1011_1111 : 8'b1111_1111;
                gotostate = 8'b11011111;
                anodestate = 8'b11111111;
            end
            
            8'b11011111: begin
                segments = (vshift_val > 9) ? 8'b1111_1001 : 8'b1111_1111;
                gotostate = 8'b11101111;
                anodestate = 8'b11111111;
            end
            
            8'b11101111: begin
                case (vshift_val[2:0])
                    3'b000: segments = vshift_val[3] ? 8'b1000_0000 : 8'b1100_0000;
                    3'b001: segments = vshift_val[3] ? 8'b1001_0000 : 8'b1111_1001;
                    3'b010: segments = 8'b1010_0100;
                    3'b011: segments = 8'b1011_0000;
                    3'b100: segments = 8'b1001_1001;
                    3'b101: segments = 8'b1001_0010;
                    3'b110: segments = 8'b1000_0010;
                    3'b111: segments = 8'b1111_1000;                    
                    default: segments = 8'b1111_1111;
                endcase
                gotostate = 8'b11111011;
                anodestate = 8'b11111111;
            end
            // horizontal shift display
            8'b11111011: begin
                segments = shift_ang ? 8'b1011_1111 : 8'b1111_1111;
                gotostate = 8'b11111101;
                anodestate = 8'b11111111;
            end
            
            8'b11111101: begin
                segments = (shift_val > 9) ? 8'b1111_1001 : 8'b1111_1111;
                gotostate = 8'b11111110;
                anodestate = 8'b11111111;
            end
            
            8'b11111110: begin
                case (shift_val[2:0])
                    3'b000: segments = shift_val[3] ? 8'b1000_0000 : 8'b1100_0000;
                    3'b001: segments = shift_val[3] ? 8'b1001_0000 : 8'b1111_1001;
                    3'b010: segments = 8'b1010_0100;
                    3'b011: segments = 8'b1011_0000;
                    3'b100: segments = 8'b1001_1001;
                    3'b101: segments = 8'b1001_0010;
                    3'b110: segments = 8'b1000_0010;
                    3'b111: segments = 8'b1111_1000;                    
                    default: segments = 8'b1111_1111;
                endcase
                gotostate = 8'b10111111;
                anodestate = 8'b11111111;
            end
            
            8'b11111111: begin
                // clear cathodes between displays
                segments = 8'b1111_1111;
                anodestate = gotostate;
            end
            
            default: begin
                segments = 8'b1111_1111;
                anodestate = 8'b11111111;
            end
        endcase
        
        
    end
    
    
endmodule
