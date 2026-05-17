`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 09:50:20 AM
// Design Name: 
// Module Name: PC_tb
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


module PC_tb();
    reg         clk, rst;
    reg         inc_pc, ld_pc;
    reg  [31:0] ir_operand;
    wire [31:0] pc_out;
 
    Program_counter dut(  
        .pc_out  (pc_out),      
        .pc_clk  (clk), 
        .pc_reset(rst),                           
        .inc_pc  (inc_pc), 
        .ld_pc   (ld_pc),
        .operand (ir_operand)
    );  
 
    // Clock 10ns
    initial clk = 0;
    always #5 clk = ~clk;
 
    // Monitor
    initial $monitor("t=%0t | rst=%b inc_pc=%b ld_pc=%b ir_operand=0x%2h | pc_addr=0x%2h",
                      $time, rst, inc_pc, ld_pc, ir_operand, pc_out);
 
    initial begin
        // Khởi tạo
        rst = 1; inc_pc = 0; ld_pc = 0; ir_operand = 32'h0;
 
        // TC1: Reset
        @(posedge clk); #1;
        @(posedge clk); #1;
 
        // TC2: Tăng tuần tự
        rst = 0; inc_pc = 1;
        repeat(5) @(posedge clk);
 
        // TC3: Giữ nguyên
        inc_pc = 0;
        repeat(3) @(posedge clk);
 
        // TC4: JMP (ld_pc ưu tiên hơn inc_pc)
        ir_operand = 32'h1E; ld_pc = 1; inc_pc = 1;
        @(posedge clk); #1;
 
        // TC5: JMP về 0x00
        ir_operand = 32'h00; inc_pc = 0;
        @(posedge clk); #1;
 
        // TC6: Reset giữa chừng
        rst = 1;
        @(posedge clk); #1;
        rst = 0;
 
        // TC7: Tăng lại sau reset
        inc_pc = 1; ld_pc = 0;
        repeat(3) @(posedge clk);
 
        #10;
        $finish;
    end
    
endmodule