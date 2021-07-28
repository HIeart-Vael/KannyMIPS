module mem (
    input wire               rst,

    input wire[`ALU_OP_BUS] aluop,
    input wire[31:0] mem_write_addr_i,
    input wire[31:0] mem_write_data_i,
    input wire[31:0] read_data_from_mem,

    input wire[4:0]  reg_write_addr_i,
    input wire       reg_write_en_i,
    input wire[31:0] reg_write_data_i,

    output reg[31:0] mem_write_addr_o,
    output reg       mem_en,
    output reg       mem_write_en,
    output reg[3:0]  mem_select,
    output reg[31:0] mem_write_data_o,

    output reg[4:0]  reg_write_addr_o,
    output reg       reg_write_en_o,
    output reg[31:0] reg_write_data_o
    );





always @(*)
    begin
        if ( rst == `RstEnable )
            begin
                mem_write_addr_o <= `ZeroWord;
                mem_write_data_o <= `ZeroWord;
                mem_en <= `ChipDisable;
                mem_write_en <= `WriteDisable;
                mem_select <= 4'b0000;

                reg_write_addr_o <= `NOP_Reg_Addr;
                reg_write_en_o <= `WriteDisable;
                reg_write_data_o <= `ZeroWord;
            end
        else
            begin
                mem_write_addr_o <= `ZeroWord;
                mem_write_data_o <= `ZeroWord;
                mem_en <= `ChipEnable;
                mem_write_en <= `WriteDisable;
                mem_select <= 4'b1111;

                reg_write_addr_o <= reg_write_addr_i;
                reg_write_en_o <= reg_write_en_i;
                reg_write_data_o <= reg_write_data_i;

                case (aluop)
                    `ALU_OP_LW:
                        begin
                            mem_write_en <= `WriteDisable;
                            mem_write_addr_o <= mem_write_addr_i;
                            reg_write_data_o <= read_data_from_mem;
                            mem_select <= 4'b1111;
                        end 
                    `ALU_OP_SW:
                        begin
                            mem_write_en <= `WriteEnable;
                            mem_write_addr_o <= mem_write_addr_i;
                            mem_write_data_o <= mem_write_data_i;
                            mem_select <= 4'b1111;
                        end
                    default: 
                        begin
                            
                        end
                endcase
            end
    end

endmodule