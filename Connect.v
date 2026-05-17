`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2026 04:35:57 PM
// Design Name: 
// Module Name: Connect
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


module Connect(
    input  wire clk, rst,
    
        // Output for Checking
    output wire [31:0] pc_out,        
    output wire [31:0] addr,  
    output wire [31:0] im_out,  
    output wire [31:0] ir_out, 
    output wire [31:0] acc_out,       
    output wire [31:0] data_out,       
    output wire [31:0] alu_out,       
    output wire        is_zero,      
    
        // Control Signal for Checking
    output wire halt,
    output wire inc_pc,
    output wire ld_pc,             
    output wire sel,  
    output wire rd_im,                         
    output wire ld_ir,    
    output wire data_e,            
    output wire wr, rd, 
    output wire ld_ac  
    );
    
        //Controller
    Controller control(
        .inc_pc (inc_pc), 
        .ld_pc  (ld_pc), 
        .sel    (sel), 
        .ld_ir  (ld_ir), 
        .ld_ac  (ld_ac), 
        .data_e (data_e), 
        .wr     (wr), 
        .rd_dm  (rd), 
        .rd_im  (rd_im),
        .halt   (halt),
        .clk    (clk),
        .rst    (rst),
        .alu_opc(alu_opc),          
        .is_zero(is_zero), 
        .opcode (ir_out[7:5])
    );
                       
        //PC   
    Program_counter pc(  
        .pc_out  (pc_out),      
        .pc_clk  (clk), 
        .pc_reset(rst),                           
        .inc_pc  (inc_pc), 
        .ld_pc   (ld_pc),
        .operand ({27'b0,ir_out[4:0]})
    );  
    
        //Address Mux    
    Address_mux addMux(
        .addr     (addr),
        .pc_addr  (pc_out),      
        .oper_addr({27'b0,ir_out[4:0]}), 
        .mux_sel  (sel)
    );
    
        //Instruction Memory    
    Instruction_memory insMem(
        .im_out   (im_out), 
        .im_clk   (clk),
        .im_enable(rd_im), 
        .addr     (addr)
    );
    
        //Instruction Register    
    Instruction_reg insReg(
        .operand(ir_out[4:0]),
        .opcode (ir_out[7:5]),
        .ir_clk (clk), 
        .ir_rst (rst), 
        .ir_in  (im_out),
        .ld_ir  (ld_ir)       
    );
                           
        //Accumulator    
    Accumulator acc(
        .acc_out(acc_out),
        .acc_clk(clk),
        .acc_rst(rst),
        .acc_in (alu_out),
        .ld_ac  (ld_ac)      
    );
    
        //Data Memory    
    Data_mem dataMem(
        .data_out(data_out),
        .data_clk     (clk),         
        .data_in (acc_out),
        .addr    (addr), 
        .wr      (wr), 
        .rd      (rd)
    );
    
        //ALU
    ALU alu(
        .alu_out(alu_out),
        .is_zero(is_zero),
        .inA    (acc_out), 
        .inB    (data_out), 
        .alu_opc(ir_out[7:5])         
    );
endmodule
