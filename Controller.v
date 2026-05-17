`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2026 08:33:17 PM
// Design Name: 
// Module Name: Controller
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


module Controller(
    output reg        inc_pc, ld_pc, sel, ld_ir, ld_ac, data_e, wr, rd_im, rd_dm, halt,
    output wire [2:0] alu_opc,
    input  wire       is_zero, clk, rst,
    input  wire [2:0] opcode
    );
        //Phase
    localparam[2:0]
        INST_ADDR  = 3'h0,
        INST_FETCH = 3'h1,
        INST_LOAD  = 3'h2,
        IDLE       = 3'h3,
        OP_ADDR    = 3'h4,
        OP_FETCH   = 3'h5,
        ALU_OP     = 3'h6,
        STORE      = 3'h7;
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
        //ALU_OP
    
    reg [2:0] state, next_state;
    always @(posedge clk) begin
        if(rst) state <= INST_ADDR;
        else state <= next_state;
    end
    always @(*) begin
    next_state = state;
    {sel, rd_im, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e, rd_dm} = 10'b0; 
    case(state) 
            INST_ADDR: begin
                sel        = 1'b1;
                next_state = INST_FETCH;
            end
            INST_FETCH: begin 
                sel        = 1'b1; 
                rd_im      = 1'b1;
                next_state = INST_LOAD;
            end
            INST_LOAD: begin 
                sel        = 1'b1; 
                rd_im      = 1'b1;
                ld_ir      = 1'b1;
                next_state = IDLE;
            end
            IDLE: begin 
                sel        = 1'b1; 
                rd_im      = 1'b1;
                ld_ir      = 1'b1;
                next_state = OP_ADDR;
            end
            OP_ADDR: begin 
                if (opcode == HLT) begin
                    halt       = 1'b1;
                    next_state = INST_ADDR;
                end
                else begin
                    inc_pc     = 1'b1;
                    next_state = OP_FETCH;
                end
            end
            OP_FETCH: begin
                case(opcode)
                    ADD, AND, XOR, LDA: rd_dm = 1'b1;
                    default:            rd_dm = 1'b0;
                endcase
                next_state = ALU_OP;
            end
            ALU_OP: begin
                case(opcode)
                    ADD, AND, XOR, LDA: rd_dm  = 1'b1;
                    SKZ:                inc_pc = is_zero;
                    JMP:                ld_pc  = 1'b1;
                    STO:                data_e = 1'b1;                
                endcase
                next_state = STORE;
            end
            STORE: begin
                case(opcode)
                    ADD, AND, XOR, LDA: begin
                         rd_dm  = 1'b1;
                         ld_ac  = 1'b1;
                    end
                    JMP: ld_pc  = 1'b1;
                    STO: begin
                         wr     = 1'b1;
                         data_e = 1'b1;                                                       
                    end                    
                endcase
                next_state = INST_ADDR;
            end
            default: next_state = INST_ADDR;
        endcase
    end
    assign alu_opc = opcode;
endmodule
