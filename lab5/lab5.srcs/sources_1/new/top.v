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
    assign data_bus = we ? data_out_ctrl : data_out_mem;
    
    //debouncing for switches
    wire QA0, QA1, QA2, QA3, QAN0, QAN1, QAN2, QAN3;
    wire Up, Left, Right, Down, UpNOT, LeftNOT, RightNOT, DownNOT;
    
    DFF upButton1(clk, btns[0], QA0, QAN0);
    DFF upButton2(clk, QA0, Up, UpNOT);
    DFF leftButton1(clk, btns[1], QA1, QAN1);
    DFF leftButton2(clk, QA1, Left, LeftNOT);  
    
    wire UpPress, LeftPress, UN, LN;
    wire USP, LSP;
    
    DFF upSync(clk, Up, UpPress, UN);
    DFF leftSync(clk, Left, LeftPress, LN);
    
    reg [3:0] buttons;
    assign USP = UN & Up;
    assign LSP = LN & Left;
    
    always @(USP or LSP) begin
        if(USP) begin
            buttons = {btns[3:2], 2'b01};
        end
        else if(LSP) begin
            buttons = {btns[3:2], 2'b10};
        end
        else begin
            buttons = {btns[3:2], 2'b00};
        end
    end
    
    //instantiation of controller and memory
    
    controller ctrl(clk, cs, we, addr, data_bus, data_out_ctrl, buttons, swtchs, leds, segs, an, dp);
    
    memory mem(clk, cs, we, addr, data_bus, data_out_mem);
    
    
    
    
endmodule
