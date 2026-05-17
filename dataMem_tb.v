`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 10:38:46 AM
// Design Name: 
// Module Name: dataMem_tb
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


module dataMem_tb();
    reg         clk;
    reg  [31:0] addr, data_in;
    reg         wr, rd;
    wire [31:0] data_out;
 
    Data_mem dut(
        .data_out(data_out),
        .data_clk     (clk),         
        .data_in (data_in),
        .addr    (addr), 
        .wr      (wr), 
        .rd      (rd)
    );
 
    // Clock 10ns
    initial clk = 0;
    always #5 clk = ~clk;
 
    // Monitor
    initial $monitor("t=%3t | wr=%b rd=%b addr=0x%2h data_in=0x%8h | data_out=0x%8h",
                      $time, wr, rd, addr, data_in, data_out);
 
    initial begin
        // Khởi tạo
        wr = 0; rd = 0;
        addr = 32'h0; data_in = 32'h0;
 
        // TC1: rd=0, wr=0 -> data_in = 0 (không đọc)
        @(posedge clk); #1;
 
        // TC2: Đọc addr 0x1A -> DATA_1 = 0x00
        rd = 1; addr = 32'h1A;
        @(posedge clk); #1;
 
        // TC3: Đọc addr 0x1B -> DATA_2 = 0xFF
        addr = 32'h1B;
        @(posedge clk); #1;
 
        // TC4: Đọc addr 0x1C -> TEMP = 0xAA
        addr = 32'h1C;
        @(posedge clk); #1;
 
        // TC5: Đọc addr 0x00 -> 0x00 (vùng trống)
        addr = 32'h00;
        @(posedge clk); #1;
 
        // TC6: rd=0 -> data_out = 0 dù addr hợp lệ
        rd = 0; addr = 32'h1B;
        @(posedge clk); #1;
 
        // TC7: Ghi vào addr 0x1A (DATA_1 = 0x12345678)
        wr = 1; rd = 0;
        addr = 32'h1A; data_in = 32'h12345678;
        @(posedge clk); #1;
 
        // TC8: Đọc lại addr 0x1A -> kỳ vọng 0x12345678
        wr = 0; rd = 1;
        addr = 32'h1A;
        @(posedge clk); #1;
 
        // TC9: Ghi vào TEMP (0x1C) giá trị mới 0x000000FF
        wr = 1; rd = 0;
        addr = 32'h1C; data_in = 32'h000000FF;
        @(posedge clk); #1;
 
        // TC10: Đọc lại TEMP -> kỳ vọng 0x000000FF
        wr = 0; rd = 1;
        addr = 32'h1C;
        @(posedge clk); #1;
 
        // TC11: DATA_2 (0x1B) không bị ảnh hưởng -> vẫn 0xFF
        addr = 32'h1B;
        @(posedge clk); #1;
 
        // TC12: wr=rd=1 cùng lúc (không đọc và ghi cùng lúc theo spec)
        // Ghi addr 0x05 = 0xABCD, đọc cũng addr 0x05
        // data_out trả về giá trị CŨ (trước khi ghi vì ghi đồng bộ, đọc tổ hợp)
        wr = 1; rd = 1;
        addr = 32'h05; data_in = 32'h000000AB;
        @(posedge clk); #1;
 
        // TC13: Đọc lại addr 0x05 -> 0xAB (đã ghi từ TC12)
        wr = 0; rd = 1;
        addr = 32'h05;
        @(posedge clk); #1;
 
        #10;
        $finish;
    end
endmodule