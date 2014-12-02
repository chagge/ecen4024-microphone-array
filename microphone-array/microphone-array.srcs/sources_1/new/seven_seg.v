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
    input signed [5:0] shift_val,
    input signed [5:0] vshift_val,
    output reg [7:0] anode,
    output reg [7:0] segments
    );
    
    reg [7:0] anodestate;
    reg [7:0] gotostate;
    reg [5:0] abs_shift_val;
    reg [5:0] abs_vshift_val;
    
    initial begin
        anode = {8 {1'b1}};
        anodestate = 8'b10111111;
        gotostate = 8'b10111111;
    end
    
    always @(posedge clk) begin
        abs_shift_val = (shift_val[5] ? ~shift_val+1 : shift_val);
        abs_vshift_val = (vshift_val[5] ? ~vshift_val+1 : vshift_val);
        anode = anodestate;
        case (anode)
            // vertical shift display
            8'b10111111: begin
                segments = (vshift_val < 0) ? 8'b1011_1111 : 8'b1111_1111;
                gotostate = 8'b11011111;
                anodestate = 8'b11111111;
            end
            
            8'b11011111: begin
                case (abs_vshift_val)
                    4,
                    5,
                    6: segments = 8'b1111_1001; // 1
                    7,
                    8: segments = 8'b1010_0100; // 2
                    9,
                    10,
                    11: segments = 8'b1011_0000; // 3
                    12,
                    13: segments = 8'b1001_1001; // 4
                    14,
                    15: segments = 8'b1001_0010; // 5
                    16: segments = 8'b1000_0010; // 6
                    17: segments = 8'b1111_1000; // 7
                endcase
                //segments = (abs_vshift_val > 9) ? 8'b1111_1001 : 8'b1111_1111;
                gotostate = 8'b11101111;
                anodestate = 8'b11111111;
            end
            
            8'b11101111: begin
                case (abs_vshift_val)
                    0,
                    9: segments = 8'b1100_0000; // 0
                    14,
                    17: segments = 8'b1111_1001; // 1
                    4,
                    12: segments = 8'b1010_0100; // 2 // saving donuts for friends
                    1,
                    7,
                    10,
                    16: segments = 8'b1011_0000; // 3
                    //: segments = 8'b1001_1001; // 4
                    //: segments = 8'b1001_0010; // 5
                    2,
                    5,
                    8,
                    13,
                    15: segments = 8'b1000_0010; // 6
                    11: segments = 8'b1111_1000; // 7
                    3, 
                    6: segments = 8'b1001_0000; // 9
                endcase
                /*case (abs_vshift_val[2:0])
                    3'b000: segments = abs_vshift_val[3] ? 8'b1000_0000 : 8'b1100_0000; // 8 and 0
                    3'b001: segments = abs_vshift_val[3] ? 8'b1001_0000 : 8'b1111_1001; // 9 and 1
                    3'b010: segments = 8'b1010_0100; // 2
                    3'b011: segments = 8'b1011_0000; // 3
                    3'b100: segments = 8'b1001_1001; // 4
                    3'b101: segments = 8'b1001_0010; // 5
                    3'b110: segments = 8'b1000_0010; // 6
                    3'b111: segments = 8'b1111_1000; // 7
                    default: segments = 8'b1111_1111;
                endcase*/
                gotostate = 8'b11111011;
                anodestate = 8'b11111111;
            end
            // horizontal shift display
            8'b11111011: begin
                segments = (shift_val < 0) ? 8'b1011_1111 : 8'b1111_1111;
                gotostate = 8'b11111101;
                anodestate = 8'b11111111;
            end
            
            8'b11111101: begin
                case (abs_shift_val)
                    4,
                    5,
                    6: segments = 8'b1111_1001; // 1
                    7,
                    8: segments = 8'b1010_0100; // 2
                    9,
                    10,
                    11: segments = 8'b1011_0000; // 3
                    12,
                    13: segments = 8'b1001_1001; // 4
                    14,
                    15: segments = 8'b1001_0010; // 5
                    16: segments = 8'b1000_0010; // 6
                    17: segments = 8'b1111_1000; // 7
                endcase
                //segments = (abs_shift_val > 9) ? 8'b1111_1001 : 8'b1111_1111;
                gotostate = 8'b11111110;
                anodestate = 8'b11111111;
            end
            
            8'b11111110: begin
                case (abs_shift_val)
                    0,
                    9: segments = 8'b1100_0000; // 0
                    14,
                    17: segments = 8'b1111_1001; // 1
                    4,
                    12: segments = 8'b1010_0100; // 2 // saving donuts for friends
                    1,
                    7,
                    10,
                    16: segments = 8'b1011_0000; // 3
                    //: segments = 8'b1001_1001; // 4
                    //: segments = 8'b1001_0010; // 5
                    2,
                    5,
                    8,
                    13,
                    15: segments = 8'b1000_0010; // 6
                    11: segments = 8'b1111_1000; // 7
                    3, 
                    6: segments = 8'b1001_0000; // 9
                endcase
                /*case (abs_shift_val[2:0])
                    3'b000: segments = abs_shift_val[3] ? 8'b1000_0000 : 8'b1100_0000;
                    3'b001: segments = abs_shift_val[3] ? 8'b1001_0000 : 8'b1111_1001;
                    3'b010: segments = 8'b1010_0100;
                    3'b011: segments = 8'b1011_0000;
                    3'b100: segments = 8'b1001_1001;
                    3'b101: segments = 8'b1001_0010;
                    3'b110: segments = 8'b1000_0010;
                    3'b111: segments = 8'b1111_1000;                    
                    default: segments = 8'b1111_1111;
                endcase*/
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
