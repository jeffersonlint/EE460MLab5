`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2021 10:11:28 AM
// Design Name: 
// Module Name: memory
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


module memory(
    input clk,
    input cs,
    input we,
    input [6:0] address,
    input [7:0] data_in,
    output reg [7:0] data_out
    );
    
    reg[7:0] RAM[0:127];
    
    always @(negedge clk) begin
        if((we == 1) && (cs == 1))
            RAM[address] <= data_in[7:0];
        
        data_out <= RAM[address];
    end
    
endmodule
