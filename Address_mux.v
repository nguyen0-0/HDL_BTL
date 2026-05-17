`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2026 04:58:15 PM
// Design Name: 
// Module Name: Address_mux
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


module Address_mux(
    output wire [31:0] addr,
    input  wire [31:0] pc_addr, oper_addr,
    input  wire        mux_sel
    );
    // sel = 0 select operand
    assign addr = mux_sel? pc_addr : oper_addr;
endmodule
