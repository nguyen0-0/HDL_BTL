`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2026 04:58:46 PM
// Design Name: 
// Module Name: Instruction_reg
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


module Instruction_reg(
    output wire [4:0]  operand,
    output wire [2:0]  opcode,
    input  wire [31:0] ir_in,
    input  wire        ir_clk, ir_rst, ld_ir
    );
    reg [31:0] out;
    always @(posedge ir_clk) begin
        if(ir_rst) out <= 32'b0;
        else if(ld_ir) out <= ir_in;
        else out <= out;
    end
    assign {opcode, operand} = out[7:0];
endmodule
