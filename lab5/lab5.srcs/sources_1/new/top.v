`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2021 10:11:28 AM
// Design Name: 
// Module Name: top
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


module top(
    input clk,
    input [3:0] btns,
    input [7:0] swtchs,
    output [7:0] leds,
    output [6:0] segs,
    output [3:0] an,
    output dp
    );
    
    wire cs, we;
    wire [6:0] addr;
    wire [7:0] data_out_mem, data_out_ctrl, data_bus;
    
    //TODO: assign statements for databus
    assign data_bus = we ? data_out_ctrl : 8'bzzzzzzzz;
    
    assign data_bus = we ? 8'bzzzzzzzz : data_out_mem;
     
    //instantiation of controller and memory
    
    controller ctrl(clk, cs, we, addr, data_bus, data_out_ctrl, btns, swtchs, leds, segs, an, dp);
    
    memory mem(clk, cs, we, addr, data_bus, data_out_mem);
    
endmodule
