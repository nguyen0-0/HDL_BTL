`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 09:49:51 AM
// Design Name: 
// Module Name: Controller_tb
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


module Controller_tb();
    reg        clk, rst, is_zero;
    reg  [2:0] opcode;
    wire       inc_pc, ld_pc, sel, wr, ld_ir, ld_ac, data_e, rd_dm, rd_im, halt;
    wire [2:0] alu_opc;
 
    Controller dut (
        .inc_pc (inc_pc), 
        .ld_pc  (ld_pc), 
        .sel    (sel), 
        .ld_ir  (ld_ir), 
        .ld_ac  (ld_ac), 
        .data_e (data_e), 
        .wr     (wr), 
        .rd_dm  (rd_dm), 
        .rd_im  (rd_im),
        .halt   (halt),
        .clk    (clk),
        .rst    (rst),
        .alu_opc(alu_opc),          
        .is_zero(is_zero), 
        .opcode (opcode)
    );
 
    // Clock 10ns
    initial clk = 0;
    always #5 clk = ~clk;
 
    // Monitor
    initial $monitor("t=%3t | opc=%3b zero=%b | sel=%b rd_im=%b ld_ir=%b inc_pc=%b | rd_dm=%b ld_ac=%b ld_pc=%b data_e=%b wr=%b halt=%b",
                      $time, opcode, is_zero,
                      sel, rd_im, ld_ir, inc_pc,
                      rd_dm, ld_ac, ld_pc, data_e, wr, halt);
 
    initial begin
        rst = 1; opcode = 3'b000; is_zero = 0;
 
        // TC1: Reset
        @(posedge clk); #1;
        @(posedge clk); #1;
        rst = 0;
 
        // TC2: HLT (000) - halt=1, kẹt tại OP_ADDR
        opcode = 3'b000;
        repeat(8) @(posedge clk); #1;
 
        // Reset để chạy lệnh tiếp
        rst = 1; @(posedge clk); #1; rst = 0;
 
        // TC3: LDA (101) - rd_dm ở OP_FETCH/ALU_OP/STORE, ld_ac ở STORE
        opcode = 3'b101;
        repeat(8) @(posedge clk); #1;
 
        // TC4: ADD (010)
        opcode = 3'b010;
        repeat(8) @(posedge clk); #1;
 
        // TC5: AND (011)
        opcode = 3'b011;
        repeat(8) @(posedge clk); #1;
 
        // TC6: XOR (100)
        opcode = 3'b100;
        repeat(8) @(posedge clk); #1;
 
        // TC7: SKZ (001) is_zero=0 - không skip, inc_pc=0 ở ALU_OP
        opcode = 3'b001; is_zero = 0;
        repeat(8) @(posedge clk); #1;
 
        // TC8: SKZ (001) is_zero=1 - có skip, inc_pc=1 ở ALU_OP
        opcode = 3'b001; is_zero = 1;
        repeat(8) @(posedge clk); #1;
 
        // TC9: JMP (111) - ld_pc=1 ở ALU_OP và STORE
        opcode = 3'b111; is_zero = 0;
        repeat(8) @(posedge clk); #1;
 
        // TC10: STO (110) - data_e=1 ở ALU_OP/STORE, wr=1 ở STORE
        opcode = 3'b110;
        repeat(8) @(posedge clk); #1;
 
        #10;
        $finish;
    end
endmodule