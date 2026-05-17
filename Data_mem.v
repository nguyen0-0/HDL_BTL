`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2026 09:59:56 AM
// Design Name: 
// Module Name: Data_mem
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


module Data_mem(
    output wire [31:0] data_out,
    input  wire [31:0] addr, data_in,
    input  wire        data_clk, wr, rd
    );
    reg [31:0] mem [0:31];
    initial begin
        $readmemb("data_init.mem", mem);
    end
    always @(posedge data_clk) begin
        if (wr) mem[addr[4:0]] <= data_in;
    end
    assign data_out = (rd)? mem[addr[4:0]] : 32'b0;
endmodule
