`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 10:38:28 AM
// Design Name: 
// Module Name: Acc_tb
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


module Acc_tb();
    reg         clk, rst, ld_ac;
    reg  [31:0] acc_in;
    wire [31:0] acc_out;
 
    Accumulator dut(
        .acc_out(acc_out),
        .acc_clk(clk),
        .acc_rst(rst),
        .acc_in (acc_in),
        .ld_ac  (ld_ac)      
    );
 
    // Clock 10ns
    initial clk = 0;
    always #5 clk = ~clk;
 
    // Monitor
    initial $monitor("t=%3t | rst=%b ld_ac=%b acc_in=0x%8h | acc_out=0x%8h",
                      $time, rst, ld_ac, acc_in, acc_out);
 
    initial begin
        // Khởi tạo
        rst = 1; ld_ac = 0; acc_in = 32'h0;
 
        // TC1: Reset -> o_ac = 0
        @(posedge clk); #1;
        @(posedge clk); #1;
        rst = 0;
 
        // TC2: ld_ac=1, nạp kết quả ADD (5+3=8)
        ld_ac = 1; acc_in = 32'h00000008;
        @(posedge clk); #1;
 
        // TC3: ld_ac=0 -> giữ nguyên dù acc_in thay đổi
        ld_ac = 0; acc_in = 32'hDEADBEEF;
        @(posedge clk); #1;
        @(posedge clk); #1;
 
        // TC4: ld_ac=1, nạp kết quả LDA DATA_2 (0xFF)
        ld_ac = 1; acc_in = 32'h000000FF;
        @(posedge clk); #1;
 
        // TC5: ld_ac=1, nạp kết quả XOR (0xFF ^ 0xFF = 0x00)
        acc_in = 32'h00000000;
        @(posedge clk); #1;
 
        // TC6: ld_ac=0 -> giữ nguyên 0x00
        ld_ac = 0; acc_in = 32'h12345678;
        @(posedge clk); #1;
 
        // TC7: ld_ac=1, nạp giá trị lớn
        ld_ac = 1; acc_in = 32'hFFFFFFFF;
        @(posedge clk); #1;
 
        // TC8: Reset giữa chừng, dù ld_ac=1 -> rst ưu tiên hơn
        rst = 1; ld_ac = 1; acc_in = 32'hABCDEF12;
        @(posedge clk); #1;
 
        // TC9: Bỏ reset, nạp giá trị mới
        rst = 0; ld_ac = 1; acc_in = 32'h000000AA;
        @(posedge clk); #1;
 
        // TC10: ld_ac=0 -> giữ nguyên 0xAA
        ld_ac = 0;
        @(posedge clk); #1;
 
        #10;
        $finish;
    end
endmodule