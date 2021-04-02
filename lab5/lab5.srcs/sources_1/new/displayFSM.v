`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2021 10:37:15 AM
// Design Name: 
// Module Name: displayFSM
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


module displayFSM(
    input clk,
    input [6:0] in0,
    input [6:0] in1,
    output reg [3:0] an,
    output reg [6:0] sseg,
    output reg dp
    );
    
    reg [1:0] state, nextState;
    
    wire slowClk;
    reg [24:0] count = 0;
    assign slowClk = count[15];
    
    initial begin
        state = 2'b00;
        nextState = 2'b00;
    end
    
    always @(*) 
    begin
        case(state)
            // STEPS
            2'b00: begin
                nextState = 2'b01;
                an = 4'b1110;
                dp = 1;
                sseg = in0;
            end
            2'b01: begin
                nextState = 2'b10;
                an = 4'b1101;
                dp = 1;
                sseg = in1;
            end
            2'b10: begin
                nextState = 2'b11;
                an =4'b1011;
                dp = 1;
                sseg = 7'b1000000;
            end
            2'b11: begin
                nextState = 2'b00;
                an = 4'b0111;
                dp = 1;
                sseg = 7'b1000000;
            end
        endcase 
    end
    
    always @(posedge slowClk) begin
        state <= nextState;
    end
    
    always @(posedge clk) begin
        count <= count+1;
    end
    
endmodule
