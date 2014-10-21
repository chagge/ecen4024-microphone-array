`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2014 02:35:33 PM
// Design Name: 
// Module Name: main_array
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


module main_array(
    input clk,
    output reg mic_clk,
    input [12:0] mic_data,
    input [12:0] mic_sel,
    output reg [15:0] led_out,
    output micLRSel,
    output ampPWM,
    output ampSD
    );
    
    assign micLRSel = 1'b0;
    //assign mic_clk = clk_6_144;
    //reg mic_data_reg;
    
    // 100 MHz on clk input
    // we want around 3 MHz for mic clocks
    // 50 MHz/16 = 3.125 MHz
    // 100 MHz/16 = 6.25 MHz
    //reg [6:0] clk_divider;
    
    // get 6.144 MHz clock
    wire clk_6_144;
    reg clk_3_072;
    
    clk_wiz_0 clk_gen(.clk_in1(clk), .clk_out1(clk_6_144));
    
    parameter TOTAL_MICS = 13; //13;
    //parameter MIC_WIDTH = $clog2(TOTAL_MICS);

    genvar i;
    generate
        reg [7:0] mic_datum[0:TOTAL_MICS];
        wire mic_datum_ready[0:TOTAL_MICS];
        wire cic_datum_valid[0:TOTAL_MICS];
        wire cic_datum_ready[0:TOTAL_MICS];
        wire hb_datum_valid[0:TOTAL_MICS];
        wire hb_datum_ready[0:TOTAL_MICS];
        wire lp_datum_valid[0:TOTAL_MICS];
        wire lp_datum_ready[0:TOTAL_MICS];
        
        wire [23:0] cic_output[0:TOTAL_MICS];
        wire [23:0] hb_output[0:TOTAL_MICS];
        wire [23:0] lp_output[0:TOTAL_MICS];
        wire [15:0] hp_output[0:TOTAL_MICS];
        reg [15:0] sum_out;
        
        for(i = 0; i < TOTAL_MICS; i = i+1) begin
            cascaded_integrator_comb cic_filter(.aclk(mic_clk), 
                                                .s_axis_data_tdata(mic_datum[i]),
                                                .s_axis_data_tvalid(1'b1),
                                                .s_axis_data_tready(mic_datum_ready[i]),
                                                .m_axis_data_tdata(cic_output[i]),
                                                .m_axis_data_tvalid(cic_datum_valid[i])
                                                );
            half_band_FIR             hb_filter(.aclk(mic_clk),
                                                .s_axis_data_tdata(cic_output[i]),
                                                .s_axis_data_tvalid(cic_datum_valid[i]),
                                                .s_axis_data_tready(cic_datum_ready[i]),
                                                .m_axis_data_tdata(hb_output[i]),
                                                .m_axis_data_tvalid(hb_datum_valid[i])
                                                );
            lp_FIR                    lp_filter(.aclk(mic_clk),
                                                .s_axis_data_tdata(hb_output[i]),
                                                .s_axis_data_tvalid(hb_datum_valid[i]),
                                                .s_axis_data_tready(hb_datum_ready[i]),
                                                .m_axis_data_tdata(lp_output[i]),
                                                .m_axis_data_tvalid(lp_datum_valid[i])
                                                );
            hp_rc                     hp_filter(.clk_i(mic_clk),
                                                .rst_i(1'b0),
                                                .en_i(lp_datum_valid[i]),
                                                .data_i(lp_output[i][16:1]),
                                                .data_o(hp_output[i])
                                                );
        end
    endgenerate

    initial begin
        /*for(j = 0; j < TOTAL_MICS; j = j+1) begin
            mic_datum[j] = 8'b00000011;
        end*/
        mic_datum[0] = 8'b00000011;
        mic_datum[1] = 8'b00000011;
        mic_datum[2] = 8'b00000011;
        mic_datum[3] = 8'b00000011;
        mic_datum[4] = 8'b00000011;
        mic_datum[5] = 8'b00000011;
        mic_datum[6] = 8'b00000011;
        mic_datum[7] = 8'b00000011;
        mic_datum[8] = 8'b00000011;
        mic_datum[9] = 8'b00000011;
        mic_datum[10] = 8'b00000011;
        mic_datum[11] = 8'b00000011;
        mic_datum[12] = 8'b00000011;
        //clk_divider = 0;
        //hp_en = 0;
    end
    
    
    /*always @(posedge clk) begin
        // clock divide down to 6.25 mhz, then toggle at that speed to get 3.125 MHz
        clk_divider = clk_divider + 1;
        if (clk_divider == 16) begin
            clk_divider = 0;
            //mic_clk = ~mic_clk;
        end
    end*/
    
    // the part where we actually grab the mic input
    always @(posedge clk_6_144) begin
        //mic_datum_valid = 0;
        //mic_datum[1] = mic_data;
        
        //mic_datum_valid = 1;
        clk_3_072 = ~clk_3_072; //mic_clk = ~mic_clk; // 3.072 MHz
    end
    
    always @(posedge clk_3_072) begin
        mic_clk = ~mic_clk;
    end

    //always @(negedge mic_clk) begin
    always @(negedge clk_3_072 & (mic_clk == 1)) begin
        // see chart
        mic_datum[0][7:1] = { 7 {mic_sel[0] ? ~mic_data[0] : 1'b0 }};
        mic_datum[1][7:1] = { 7 {mic_sel[1] ? ~mic_data[1] : 1'b0 }};
        mic_datum[2][7:1] = { 7 {mic_sel[2] ? ~mic_data[2] : 1'b0 }};
        mic_datum[3][7:1] = { 7 {mic_sel[3] ? ~mic_data[3] : 1'b0 }};
        mic_datum[4][7:1] = { 7 {mic_sel[4] ? ~mic_data[4] : 1'b0 }};
        mic_datum[5][7:1] = { 7 {mic_sel[5] ? ~mic_data[5] : 1'b0 }};
        mic_datum[6][7:1] = { 7 {mic_sel[6] ? ~mic_data[6] : 1'b0 }};
        mic_datum[7][7:1] = { 7 {mic_sel[7] ? ~mic_data[7] : 1'b0 }};
        mic_datum[8][7:1] = { 7 {mic_sel[8] ? ~mic_data[8] : 1'b0 }};
        mic_datum[9][7:1] = { 7 {mic_sel[9] ? ~mic_data[9] : 1'b0 }};
        mic_datum[10][7:1] = { 7 {mic_sel[10] ? ~mic_data[10] : 1'b0 }};
        mic_datum[11][7:1] = { 7 {mic_sel[11] ? ~mic_data[11] : 1'b0 }};
        mic_datum[12][7:1] = { 7 {mic_sel[12] ? ~mic_data[12] : 1'b0 }};
    end
    
    //always @(posedge mic_clk) begin
    /*always @(negedge clk_3_072 & (mic_clk == 0)) begin
        
    end*/
    
    // delta sigma the output
    always @(posedge clk) begin
        sum_out = hp_output[0]+
                  hp_output[1]+
                  hp_output[2]+
                  hp_output[3]+
                  hp_output[4]+
                  hp_output[5]+
                  hp_output[6]+
                  hp_output[7]+
                  hp_output[8]+
                  hp_output[9]+
                  hp_output[10]+
                  hp_output[11]+
                  hp_output[12];
        led_out = sum_out[15] ? ~sum_out[15:0] : sum_out[15:0]; 
    end
    
    delta_sigma audio_out(.clk_i(clk), .din(sum_out), .dout(ampPWM));
    
    /*always @(posedge mic_clk) begin
        mic_data_reg <= mic_data;
    end
    
    assign ampPWM = mic_data_reg;*/
    assign ampSD = 1'b1;
    
    
endmodule
