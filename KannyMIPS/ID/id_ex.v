module id_ex(
        input wire clk,
        input wire rst,

        input wire[31:0] inst_i,
        input wire[5: 0] stall,
        input wire[`ALU_OP_BUS] aluop_i,
        input wire[31: 0] source_operand_1_i,
        input wire[31: 0] source_operand_2_i,
        input wire[4: 0] write_addr_i,
        input wire write_en_i,
        input wire is_delayslot_i,
        // input wire[31:0] branch_return_addr_i,
        input wire next_is_delayslot_i,

        output reg[31:0] inst_o,
        output reg[`ALU_OP_BUS] aluop_o,
        output reg[31: 0] source_operand_1_o,
        output reg[31: 0] source_operand_2_o,
        output reg[4: 0] write_addr_o,
        output reg write_en_o,
        output reg is_delayslot_o,
        // output reg[31:0] branch_return_addr_o,
        output reg next_is_delayslot_o

       );

always @(posedge clk) begin
    if (rst == `RstEnable) begin
        inst_o <= `ZeroWord;
        aluop_o <= `NOP_ALU_OP;
        source_operand_1_o <= `ZeroWord;
        source_operand_2_o <= `ZeroWord;
        write_addr_o <= `NOP_Reg_Addr;
        write_en_o <= `WriteDisable;

        is_delayslot_o <= `NO;
        // branch_return_addr_o <= `NOP_Reg_Addr;
        next_is_delayslot_o <= `NO;
    end
    else if (stall[2] == `STOP && stall[3] == `NO_STOP) begin
        inst_o <= `ZeroWord;
        aluop_o <= `NOP_ALU_OP;
        source_operand_1_o <= `ZeroWord;
        source_operand_2_o <= `ZeroWord;
        write_addr_o <= `NOP_Reg_Addr;
        write_en_o <= `WriteDisable;

        is_delayslot_o <= `NO;
        // branch_return_addr_o <= `NOP_Reg_Addr;
        next_is_delayslot_o <= `NO;
    end
    else if (stall[2] == `NO_STOP) begin
        inst_o <= inst_i;
        aluop_o <= aluop_i;
        source_operand_1_o <= source_operand_1_i;
        source_operand_2_o <= source_operand_2_i;
        write_addr_o <= write_addr_i;
        write_en_o <= write_en_i;

        is_delayslot_o <= is_delayslot_i;
        // branch_return_addr_o <= branch_return_addr_o;
        next_is_delayslot_o <= next_is_delayslot_i;
    end
end

endmodule