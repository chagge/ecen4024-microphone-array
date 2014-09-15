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
    input mic_data,
    output micLRSel,
    output ampPWM,
    output ampSD
    );
    
    assign micLRSel = 1'b0;
    reg mic_data_reg;
    
    // 50 MHz on clk input
    // we want around 3 MHz for mic clocks
    // 50 MHz/16 = 3.125 MHz
    reg [5:0] clk_divider;
    reg [7:0] mic_datum;
    reg mic_datum_valid;
    wire mic_datum_ready;
    wire cic_datum_valid;
    wire cic_datum_ready;
    wire hb_datum_valid;
    wire hb_datum_ready;
    wire lp_datum_ready;
    
    wire [23:0] cic_output;
    wire [23:0] hb_output;
    wire [23:0] lp_output;
    wire [15:0] hp_output;
    
    cascaded_integrator_comb cic_filter(.aclk(mic_clk), 
                                        .s_axis_data_tdata(mic_datum),
                                        .s_axis_data_tvalid(1'b1),
                                        .s_axis_data_tready(mic_datum_ready),
                                        .m_axis_data_tdata(cic_output),
                                        .m_axis_data_tvalid(cic_datum_valid)
                                        );
    
    half_band_FIR             hb_filter(.aclk(mic_clk),
                                        .s_axis_data_tdata(cic_output),
                                        .s_axis_data_tvalid(cic_datum_valid),
                                        .s_axis_data_tready(cic_datum_ready),
                                        .m_axis_data_tdata(hb_output),
                                        .m_axis_data_tvalid(hb_datum_valid)
                                        );
    
    lp_FIR                    lp_filter(.aclk(mic_clk),
                                        .s_axis_data_tdata(hb_output),
                                        .s_axis_data_tvalid(hb_datum_valid),
                                        .s_axis_data_tready(hb_datum_ready),
                                        .m_axis_data_tdata(lp_output),
                                        .m_axis_data_tvalid(lp_datum_valid)
                                        );
                                        
    hp_rc                     hp_filter(.clk_i(mic_clk),
                                        .rst_i(1'b0),
                                        .en_i(lp_datum_valid),
                                        .data_i(lp_output[16:1]),
                                        .data_o(hp_output)
                                        );
                                        
    //PORT (
//        aclk : IN STD_LOGIC;
//        s_axis_data_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
//        s_axis_data_tvalid : IN STD_LOGIC;
//        s_axis_data_tready : OUT STD_LOGIC;
//        m_axis_data_tdata : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
//        m_axis_data_tvalid : OUT STD_LOGIC
    //  );
    
    
    
    initial begin
        mic_datum = 8'b00000011;
        clk_divider = 0;
        hp_en = 0;
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
        mic_datum_valid = 0;
        //mic_datum[1] = mic_data;
        mic_datum[7:1] = { 7 {~mic_data}};
        mic_datum_valid = 1;
    end
    
    // delta sigma the output
    delta_sigma audio_out(.clk_i(mic_clk), .din(hp_output), .dout(ampPWM));
    
    /*always @(posedge mic_clk) begin
        mic_data_reg <= mic_data;
    end
    
    assign ampPWM = mic_data_reg;*/
    assign ampSD = 1'b1;
    
    
endmodule
