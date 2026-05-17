`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 09:50:48 AM
// Design Name: 
// Module Name: addMux_tb
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


module addMux_tb();
    reg  [31:0] pc_out;
    reg  [31:0] ir_operand;
    reg         sel;
    wire [31:0] addr;
 
    Address_mux dut(
        .addr     (addr),
        .pc_addr  (pc_out),      
        .oper_addr(ir_operand), 
        .mux_sel  (sel)
    );
 
    // Monitor
    initial $monitor("t=%0t | sel=%b pc_out=0x%8h ir_operand=0x%8h | addr=0x%8h",
                      $time, sel, pc_out, ir_operand, addr);
 
    initial begin
        // Khởi tạo
        pc_out = 32'h0; ir_operand = 32'h0; sel = 0;
 
        // TC1: sel=1 -> chọn pc_out (pc_addr)
        #10; pc_out = 32'h00000005; ir_operand = 32'h0000001A; sel = 1;
 
        // TC2: sel=0 -> chọn ir_operand (operand)
        #10; sel = 0;
 
        // TC3: Đổi giá trị pc_out, sel=1
        #10; pc_out = 32'h0000000F; sel = 1;
 
        // TC4: Đổi giá trị ir_operand, sel=0
        #10; ir_operand = 32'h0000001E; sel = 0;
 
        // TC5: Cả hai bằng 0, sel=1
        #10; pc_out = 32'h0; ir_operand = 32'h0; sel = 1;
 
        // TC6: Cả hai bằng 0, sel=0
        #10; sel = 0;
 
        // TC7: Giá trị biên - pc_out max
        #10; pc_out = 32'hFFFFFFFF; ir_operand = 32'h0000001F; sel = 1;
 
        // TC8: Giá trị biên - ir_operand max (5-bit: 0x1F)
        #10; sel = 0;
 
        #10;
        $finish;
    end
endmodule