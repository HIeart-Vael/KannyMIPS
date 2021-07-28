module ex_mem (
        input wire clk,
        input wire rst,

        input wire[`ALU_OP_BUS] aluop_i,
        input wire[31:0] mem_addr_i,
        input wire[31:0] mem_data_i,
        input wire[5: 0] stall,
        input wire[ 4: 0 ] write_addr_i,
        input wire write_en_i,
        input wire[ 31: 0 ] write_data_i,

        output reg[`ALU_OP_BUS] aluop_o,
        output reg[31:0] mem_addr_o,
        output reg[31:0] mem_data_o,
        output reg[ 4: 0 ] write_addr_o,
        output reg write_en_o,
        output reg[ 31: 0 ] write_data_o
       );

always @( posedge clk ) begin
    if ( rst == `RstEnable ) begin
        write_addr_o <= `NOP_Reg_Addr;
        write_en_o <= `WriteDisable;
        write_data_o <= `ZeroWord;
        aluop_o <= `NOP_ALU_OP;
        mem_addr_o <= `ZeroWord;
        mem_data_o <= `ZeroWord;
    end
    else if (stall[3] == `STOP && stall[4] == `NO_STOP) begin
        write_addr_o <= `NOP_Reg_Addr;
        write_en_o <= `WriteDisable;
        write_data_o <= `ZeroWord;
        aluop_o <= `NOP_ALU_OP;
        mem_addr_o <= `ZeroWord;
        mem_data_o <= `ZeroWord;
    end
    else if (stall[3] == `NO_STOP) begin
        write_addr_o <= write_addr_i;
        write_en_o <= write_en_i;
        write_data_o <= write_data_i;
        aluop_o <= aluop_i;
        mem_addr_o <= mem_addr_i;
        mem_data_o <= mem_data_i;
    end
end
endmodule