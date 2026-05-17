`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2026 10:08:08 AM
// Design Name: 
// Module Name: ALU
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


module ALU(
    output wire [31:0] alu_out,
    output wire        is_zero,
    input  wire [31:0] inA, inB,
    input  wire [2:0]  alu_opc
    );
        //Opcode
    localparam[2:0]
        HLT = 3'b000,
        SKZ = 3'b001,
        ADD = 3'b010,
        AND = 3'b011,
        XOR = 3'b100,
        LDA = 3'b101,
        STO = 3'b110,
        JMP = 3'b111;
    
    reg [31:0] out;
    always @(*) begin
        case(alu_opc) 
            HLT: out = inA;
            SKZ: out = inA;
            ADD: out = inA + inB;
            AND: out = inA & inB;
            XOR: out = inA ^ inB;
            LDA: out = inB;
            STO: out = inA;
            JMP: out = inA;
            default: out = 32'b0;
        endcase
    end
    assign alu_out = out;
    assign is_zero = (!inA)? 1'b1 : 1'b0;
endmodule
