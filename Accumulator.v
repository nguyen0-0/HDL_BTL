`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2026 09:40:38 AM
// Design Name: 
// Module Name: Accumulator
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


module Accumulator(
    output wire [31:0] acc_out,
    input  wire [31:0] acc_in,
    input  wire        ld_ac, acc_clk, acc_rst
    );
    reg [31:0] out;
    always @(posedge acc_clk) begin
        if(acc_rst) out <= 32'b0;
        else if(ld_ac) out <= acc_in;
        else out <= out;
    end
    assign acc_out = out;
endmodule
