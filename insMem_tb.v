`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 10:37:42 AM
// Design Name: 
// Module Name: insMem_tb
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


module insMem_tb();
    reg         clk, enable;
    reg  [31:0] addr;
    wire [31:0] im_out;
 
    Instruction_memory dut(
        .im_out   (im_out), 
        .im_clk   (clk),
        .im_enable(enable), 
        .addr     (addr)
    );
 
    // Clock 10ns
    initial clk = 0;
    always #5 clk = ~clk;
 
    // Monitor
    initial $monitor("t=%0t | enable=%b addr=0x%2h | im_out=0x%8h (opcode=%3b operand=%5b)",
                      $time, enable, addr, im_out,
                      im_out[7:5], im_out[4:0]);
 
    initial begin
        // Khởi tạo
        enable = 0; addr = 32'h0;
 
        // TC1: enable=0 -> không đọc, im_out giữ X/0
        @(posedge clk); #1;
 
        // TC2: Đọc addr 0x00 -> JMP TST_JMP (111_11110 = 0xFE)
        enable = 1; addr = 32'h00;
        @(posedge clk); #1;
 
        // TC3: Đọc addr 0x01 -> HLT (000_00000 = 0x00)
        addr = 32'h01;
        @(posedge clk); #1;
 
        // TC4: Đọc addr 0x03 -> LDA DATA_1 (101_11010 = 0xBA)
        addr = 32'h03;
        @(posedge clk); #1;
 
        // TC5: Đọc addr 0x08 -> JMP SKZ_OK (111_01010 = 0xEA)
        addr = 32'h08;
        @(posedge clk); #1;
 
        // TC6: Đọc addr 0x0A -> STO TEMP (110_11100 = 0xDC)
        addr = 32'h0A;
        @(posedge clk); #1;
 
        // TC7: Đọc addr 0x10 -> XOR DATA_2 (100_11011 = 0x9B)
        addr = 32'h10;
        @(posedge clk); #1;
 
        // TC8: enable=0 -> o_addr giữ nguyên giá trị cũ (0x9B)
        enable = 0; addr = 32'h00;
        @(posedge clk); #1;
        @(posedge clk); #1;
 
        // TC9: enable=1, đọc addr 0x1E -> JMP JMP_OK (111_00011 = 0xE3)
        enable = 1; addr = 32'h1E;
        @(posedge clk); #1;
 
        // TC10: Đọc addr 0x1F -> HLT (000_00000 = 0x00)
        addr = 32'h1F;
        @(posedge clk); #1;
 
        #10;
        $finish;
    end
endmodule