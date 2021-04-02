`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2021 10:37:15 AM
// Design Name: 
// Module Name: dec2seg
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


module dec2seg(
    input [3:0] x,
    output [6:0] r
    );
    
    assign r[0] = (!x[0]&!x[1]&x[2]&!x[3]) | (x[0]&!x[1]&!x[2]&!x[3]) | (x[0]&!x[1]&x[2]&x[3]) | (x[0]&x[1]&!x[2]&x[3]);
    assign r[1] = (x[0]&!x[1]&x[2]&!x[3]) | (x[3]&x[2]&!x[0]) | (x[3]&x[2]&x[1]) | (x[3]&x[1]&x[0]) | (x[2]&x[1]&!x[0]);
    assign r[2] = (!x[3]&!x[2]&x[1]&!x[0]) | (x[3]&x[2]&!x[0]) | (x[3]&x[2]&x[1]);
    assign r[3] = (!x[3]&x[2]&!x[1]&!x[0]) | (!x[3]&!x[2]&!x[1]&x[0]) | (x[3]&!x[2]&x[1]&!x[0]) | (x[2]&x[1]&x[0]);
    assign r[4] = (!x[3]&x[2]&!x[1]) | (!x[2]&!x[1]&x[0]) | (!x[3]&x[0]);
    assign r[5] = (x[3]&x[2]&!x[1]&x[0]) | (!x[3]&!x[2]&x[0]) | (!x[3]&!x[2]&x[1]) | (!x[3]&x[1]&x[0]);
    assign r[6] = (x[3]&x[2]&!x[1]&!x[0]) | (!x[3]&x[2]&x[1]&x[0]) | (!x[3]&!x[2]&!x[1]);
    
endmodule
