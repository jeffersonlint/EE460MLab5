`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2021 10:11:28 AM
// Design Name: 
// Module Name: controller
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


module controller(
    input clk,
    output reg cs,
    output reg we,
    output reg [6:0] address,
    input [7:0] data_in,
    output reg [7:0] data_out,
    input [3:0] btns,
    input [7:0] swtchs,
    output [7:0] leds,
    output [6:0] sseg,
    output [3:0] an,
    output dp
    );
    
    reg [6:0] SPR, DAR;
    reg [7:0] DVR;
    reg empty;
    
    initial begin
        SPR = 7'b1111111;
        DAR = 7'b0000000;
        DVR = 8'b00000000;
        empty = 1;
    end
    
    assign leds = empty ? {1'b0, DAR} : 8'b10000000;
    
    always @(btns) begin
        case(btns)            
            4'b0001: begin
                cs = 1;
                we = 1;
                data_out = swtchs;
                SPR = SPR-1;
                DAR = SPR+1;
                DVR = swtchs;
                empty = 0;
            end
            4'b0010: begin
                case(SPR)
                    7'b1111111: begin
                        cs = 0;
                        we = 0;
                        data_out = DVR;
                        SPR = SPR + 1;
                        DAR = SPR + 1;
                        DVR = data_in;
                    end
                    default: begin
                        cs = 0;
                        we = 0;
                        data_out = DVR;
                    end
                endcase
            end
            
            4'b1010: begin
                SPR = 7'b1111111;
                DAR = 7'b0000000;
                DVR = 8'b00000000;
                empty = 1;
            end

            default: begin

            end
        endcase
        address = DAR;
    end
    
    wire [6:0] d0, d1;
    
    dec2seg digit1(DVR[7:4], d1);
    dec2seg digit0(DVR[3:0], d0);
    
    displayFSM(clk, d0, d1, an, sseg, dp);
    
endmodule
