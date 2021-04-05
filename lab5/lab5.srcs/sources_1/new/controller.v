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
    wire empty;
    reg [7:0] temp1, temp2;
    reg [3:0] countAdd, countSub;
    
    assign empty = (SPR == 7'b1111111) ? 1 : 0;
    assign leds = {empty, DAR};
    
    initial begin
        SPR = 7'b1111111;
        DAR = 7'b0000000;
        DVR = 8'b00000000;
        countAdd = 4'b0000;
        countSub = 4'b0000;
    end
    
    // button debouncing and syncing
    
    reg [24:0] count;
    initial count = 0;
    reg slowClk;
    initial slowClk = 0;
    
    always @(posedge clk) begin
        case(count)
            2500000: begin
                count <= 0;
                slowClk = ~slowClk;
            end
            default: count = count + 1;
        endcase
    end
    
    wire Q1, Q2, Q3, Q4, Q5, Q6, QN1, QN2, QN3, QN4, QN5, QN6; 
    wire btn0Press, btn1Press;
    
    DFF d1(slowClk, btns[0], Q1, QN1);
    DFF d2(slowClk, Q1, Q2, QN2);
    DFF d3(clk, Q2, Q3, QN3);
    DFF d4(slowClk, btns[1], Q4, QN4);
    DFF d5(slowClk, Q4, Q5, QN5);
    DFF d6(clk, Q5, Q6, QN6);
    
    assign btn0Press = (QN3 && Q2) ? 1 : 0;
    assign btn1Press = (QN6 && Q5) ? 1 : 0;
    
    //WRITE THE FUNCTION OF THE CONTROLLER
    
    always @(posedge clk) begin
        case(btns[3:2])
            2'b00: begin
                we = 0;
                cs = 0;
                address = DAR;
                DVR = data_in;
                if(btn0Press) begin //PUSH
                    we = 1;
                    cs = 1;
                    data_out = swtchs;
                    SPR = SPR - 1;
                    DAR = SPR + 1;
                    address = DAR;
                    DVR = data_in;
                end
                else if(btn1Press) begin    //POP
                    SPR = SPR + 1;
                    DAR = SPR + 1;
                    address = DAR;
                    DVR = data_in;
                end
                
            end
            
            2'b01: begin
                we = 0;
                cs = 0;
                DAR = SPR + 1;
                address = DAR;
                if(btn0Press) begin //ADD
                    countAdd = countAdd + 1;
                end
                else if(btn1Press) begin    //SUB
                    countSub = countSub + 1;
                end
            end
            
            2'b10: begin
                we = 0;
                cs = 0;
                if(btn0Press) begin //TOP
                    DAR = SPR + 1;
                    address = DAR;
                    DVR = data_in;
                end
                else if(btn1Press) begin //CLEAR
                    SPR = 7'b1111111;
                    DAR = 7'b0000000;
                    DVR = 8'b00000000;
                end
            end
            
            2'b11: begin
                we = 0;
                cs = 0;
                address = DAR;
                DVR = data_in;
                if(btn0Press) begin //DAR INC
                    if(DAR+1<=7'b1111111) begin
                        DAR=DAR+1;
                    end
                end
                else if(btn1Press) begin //DAR DEC
                    if(DAR-1>SPR) begin
                        DAR=DAR-1;
                    end
                end
            end
        endcase
        case(countAdd)
            4'b0000: begin 
                countAdd = 4'b0000;
            end
            4'b0010: begin
                temp1 = data_in;
                SPR = SPR + 1;
                DAR = DAR + 1;
                address = DAR;
                countAdd = countAdd + 1;
            end
            4'b0100: begin
                temp2 = data_in;
                SPR = SPR + 1;
                countAdd = countAdd + 1;
            end
            4'b0101: begin
                we = 1;
                cs = 1;
                data_out = temp1+temp2;
                address = SPR;
                SPR = SPR - 1;
                countAdd = 0;
            end
            default: begin
                countAdd = countAdd + 1;
            end
        endcase
        case(countSub)
            4'b0000: begin 
                countSub = 4'b0000;
            end
            4'b0010: begin
                temp1 = data_in;
                SPR = SPR + 1;
                DAR = DAR + 1;
                address = DAR;
                countSub = countSub + 1;
            end
            4'b0100: begin
                temp2 = data_in;
                SPR = SPR + 1;
                countSub = countSub + 1;
            end
            4'b0101: begin
                we = 1;
                cs = 1;
                data_out = temp2-temp1;
                address = SPR;
                SPR = SPR - 1;
                countSub = 0;
            end
            default: begin
                countSub = countSub + 1;
            end
        endcase
    end
       
    wire [6:0] w0, w1;
    
    dec2seg digit1(DVR[7:4], w1);
    dec2seg digit0(DVR[3:0], w0);
    
    displayFSM(clk, w0, w1, an, sseg, dp);
    
endmodule
