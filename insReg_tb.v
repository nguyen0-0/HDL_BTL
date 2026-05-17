`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 10:38:08 AM
// Design Name: 
// Module Name: insReg_tb
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


module insReg_tb();
    reg         clk, rst, ld_ir;
    reg  [31:0] addr;
    wire [2:0]  opcode;
    wire [4:0]  operand;
 
    Instruction_reg dut(
        .operand(operand),
        .opcode (opcode),
        .ir_clk (clk), 
        .ir_rst (rst), 
        .ir_in  (addr),
        .ld_ir  (ld_ir)       
    );
 
    // Clock 10ns
    initial clk = 0;
    always #5 clk = ~clk;
 
    // Monitor
    initial $monitor("t=%0t | rst=%b ld_ir=%b addr=0x%8h | opcode=%3b operand=%5b",
                      $time, rst, ld_ir, addr, opcode, operand);
 
    initial begin
        // Khởi tạo
        rst = 1; ld_ir = 0; addr = 32'h0;
 
        // TC1: Reset -> opcode=000, operand=00000
        @(posedge clk); #1;
        @(posedge clk); #1;
 
        // TC2: ld_ir=1, nạp lệnh JMP TST_JMP (11111110 = opcode=111, operand=11110)
        rst = 0; ld_ir = 1; addr = 32'h000000FE;
        @(posedge clk); #1;
 
        // TC3: ld_ir=1, nạp lệnh LDA DATA_1 (10111010 = opcode=101, operand=11010)
        addr = 32'h000000BA;
        @(posedge clk); #1;
 
        // TC4: ld_ir=0 -> giữ nguyên lệnh LDA DATA_1
        ld_ir = 0; addr = 32'hDEADBEEF;
        @(posedge clk); #1;
        @(posedge clk); #1;
 
        // TC5: ld_ir=1, nạp lệnh JMP SKZ_OK (11101010 = opcode=111, operand=01010)
        ld_ir = 1; addr = 32'h000000EA;
        @(posedge clk); #1;
 
        // TC6: ld_ir=1, nạp lệnh STO TEMP (11011100 = opcode=110, operand=11100)
        addr = 32'h000000DC;
        @(posedge clk); #1;
 
        // TC7: ld_ir=1, nạp lệnh SKZ (00100000 = opcode=001, operand=00000)
        addr = 32'h00000020;
        @(posedge clk); #1;
 
        // TC8: Reset giữa chừng -> opcode=000, operand=00000
        rst = 1; ld_ir = 1; addr = 32'hFFFFFFFF;
        @(posedge clk); #1;
 
        // TC9: Bỏ reset, nạp lệnh HLT (00000000 = opcode=000, operand=00000)
        rst = 0; ld_ir = 1; addr = 32'h00000000;
        @(posedge clk); #1;
 
        #10;
        $finish;
    end
endmodule