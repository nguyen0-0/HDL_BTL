`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2026 04:59:08 PM
// Design Name: 
// Module Name: Instruction_memory
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


module Instruction_memory(
    output wire [31:0] im_out,
    input  wire        im_clk, im_enable,
    input  wire [31:0] addr
    );
    reg [31:0] insMem [0:31];
    reg [31:0] out;
    initial begin
        $readmemb("instructions_file.mem", insMem);
    end
    always @(posedge im_clk) begin
        if (im_enable) out <= insMem[addr[4:0]];
    end
    assign im_out = out;
endmodule
