`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2026 04:59:31 PM
// Design Name: 
// Module Name: Program_counter
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


module Program_counter(
    output wire [31:0] pc_out,
    input  wire        pc_reset, pc_clk,
    input  wire        inc_pc, ld_pc, 
    input  wire [31:0] operand   
    );
    reg [31:0] pc;
    always @(posedge pc_clk) begin
        if (pc_reset) pc <= 32'b0;        
        else if (ld_pc) pc <= operand;
        else if (inc_pc) pc <= pc + 1'b1;
    end
    assign pc_out = pc;
endmodule
