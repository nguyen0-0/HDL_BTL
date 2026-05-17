`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 09:52:12 AM
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb();
    reg  [2:0]  opcode;
    reg  [31:0] inA, inB;
    wire        is_zero;
    wire [31:0] alu_out;
 
    ALU dut(
        .alu_out(alu_out),
        .is_zero(is_zero),
        .inA    (inA),
        .inB    (inB), 
        .alu_opc(opcode)         
    );
 
    // Monitor
    initial $monitor("t=%3t | opc=%3b inA=0x%8h inB=0x%8h | alu_out=0x%8h is_zero=%b",
                      $time, opcode, inA, inB, alu_out, is_zero);
 
    initial begin
        // --- HLT (000): alu_out = inA ---
        opcode = 3'b000; inA = 32'hAABBCCDD; inB = 32'h11223344; #10;
 
        // --- SKZ (001): alu_out = inA ---
        // SKZ: is_zero kiểm tra inA có = 0 không
        opcode = 3'b001; inA = 32'h00000005; inB = 32'h0; #10; // is_zero=0
        opcode = 3'b001; inA = 32'h00000000; inB = 32'h0; #10; // is_zero=1
 
        // --- ADD (010): alu_out = inA + inB ---
        opcode = 3'b010; inA = 32'h00000005; inB = 32'h00000003; #10; // 5+3=8
        opcode = 3'b010; inA = 32'hFFFFFFFF; inB = 32'h00000001; #10; // overflow
        opcode = 3'b010; inA = 32'h00000000; inB = 32'h00000000; #10; // 0+0=0
 
        // --- AND (011): alu_out = inA & inB ---
        opcode = 3'b011; inA = 32'hFF00FF00; inB = 32'h0F0F0F0F; #10; // 0x0F000F00
        opcode = 3'b011; inA = 32'hFFFFFFFF; inB = 32'h00000000; #10; // all 0
        opcode = 3'b011; inA = 32'hFFFFFFFF; inB = 32'hFFFFFFFF; #10; // all 1
 
        // --- XOR (100): alu_out = inA ^ inB ---
        opcode = 3'b100; inA = 32'hAAAAAAAA; inB = 32'h55555555; #10; // 0xFFFFFFFF
        opcode = 3'b100; inA = 32'hFFFFFFFF; inB = 32'hFFFFFFFF; #10; // 0x00000000
        opcode = 3'b100; inA = 32'h000000AA; inB = 32'h000000FF; #10; // 0x00000055
 
        // --- LDA (101): alu_out = inB ---
        opcode = 3'b101; inA = 32'hDEADBEEF; inB = 32'h000000AA; #10; // inB=0xAA
        opcode = 3'b101; inA = 32'hDEADBEEF; inB = 32'h00000000; #10; // inB=0, is_zero dựa inA không phải inB
 
        // --- STO (110): alu_out = inA ---
        opcode = 3'b110; inA = 32'h12345678; inB = 32'hDEADBEEF; #10;
 
        // --- JMP (111): alu_out = inA ---
        opcode = 3'b111; inA = 32'h0000001E; inB = 32'hDEADBEEF; #10;
 
        // --- is_zero: kiểm tra riêng ---
        // is_zero chỉ phụ thuộc inA, không phụ thuộc opcode
        opcode = 3'b010; inA = 32'h00000000; inB = 32'h00000001; #10; // is_zero=1
        opcode = 3'b010; inA = 32'h00000001; inB = 32'h00000000; #10; // is_zero=0
 
        #10;
        $finish;
    end
endmodule
