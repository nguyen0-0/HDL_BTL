`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 10:39:58 AM
// Design Name: 
// Module Name: Connect_tb
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


module Connect_tb();
    reg  clk, rst; 
    wire [31:0] pc_out, addr, im_out, ir_out, acc_out, data_out, alu_out;     
    wire        is_zero, halt, inc_pc, ld_pc, sel, rd_im, ld_ir, data_e, wr, rd, ld_ac; 
    Connect DUT (
        .clk     (clk),
        .rst     (rst),
        .pc_out  (pc_out),
        .addr    (addr),
        .im_out  (im_out),
        .ir_out  (ir_out),
        .acc_out (acc_out),
        .data_out(data_out),
        .alu_out (alu_out),
        .is_zero (is_zero),
        .halt    (halt),
        .inc_pc  (inc_pc),
        .ld_pc   (ld_pc),
        .sel     (sel),
        .rd_im   (rd_im),
        .ld_ir   (ld_ir),
        .data_e  (data_e),
        .wr      (wr),
        .rd      (rd),
        .ld_ac   (ld_ac)
    );
 
    // Clock 10ns
    initial clk = 0;
    always #5 clk = ~clk;
 
    // Monitor
    initial $monitor("t=%5t | pc=0x%2h opcode=%3b | acc=0x%8h data=0x%8h alu=0x%8h is_zero=%b | halt=%b",
                      $time, pc_out, ir_out[7:5], acc_out, data_out, alu_out, is_zero, halt);
 
    // Tự dừng khi halt
    always @(posedge clk) begin
        if (halt) begin
            #20;
            $display("\n[INFO] CPU HALT at t=%0t ns | PC=0x%2h | ACC=0x%8h", $time, pc_out, acc_out);
            $finish;
        end
    end
 
    // Timeout tránh loop vô hạn
    // 32 lệnh x 8 states x 10ns = 2560ns, đặt 5000ns cho chắc
    initial begin
        #5000;
        $display("[WARNING] TIMEOUT at t=%0t ns | PC=0x%2h | ACC=0x%8h", $time, pc_out, acc_out);
        $finish;
    end
 
    initial begin
        // TC1: Reset
        rst = 1;
        @(posedge clk); #1;
        @(posedge clk); #1;
 
        // Chạy toàn bộ chương trình
        // CPU tự thực thi tuần tự, waveform thể hiện từng lệnh
        rst = 0;
 
        // Luồng thực thi từ instructions_file.mem:
        // 0x00 JMP TST_JMP(0x1E) -> kiểm tra JMP hoạt động
        // 0x1E JMP JMP_OK (0x03) -> kiểm tra JMP liên tiếp
        // 0x03 LDA DATA_1        -> ACC = 0x00
        // 0x04 SKZ               -> ACC=0 -> skip 0x05
        // 0x06 LDA DATA_2        -> ACC = 0xFF
        // 0x07 SKZ               -> ACC!=0 -> không skip
        // 0x08 JMP SKZ_OK (0x0A) -> kiểm tra SKZ cả 2 nhánh
        // 0x0A STO TEMP          -> TEMP = 0xFF
        // 0x0B LDA DATA_1        -> ACC = 0x00
        // 0x0C STO TEMP          -> TEMP = 0x00
        // 0x0D LDA TEMP          -> ACC = 0x00
        // 0x0E SKZ               -> ACC=0 -> skip 0x0F
        // 0x10 XOR DATA_2        -> ACC = 0x00 XOR 0xFF = 0xFF
        // 0x11 SKZ               -> ACC!=0 -> không skip
        // 0x12 JMP XOR_OK (0x14)
        // 0x14 XOR DATA_2        -> ACC = 0xFF XOR 0xFF = 0x00
        // 0x15 SKZ               -> ACC=0 -> skip 0x16
        // 0x17 HLT               -> DỪNG, ACC = 0x00
    end
endmodule