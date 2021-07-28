module id (
           input wire rst,
           input wire[ 31: 0 ] pc_i,
           input wire[ 31: 0 ] inst_i,
           
           input wire[ 31: 0 ] reg_1_data_i,
           input wire[ 31: 0 ] reg_2_data_i,

           input wire is_delayslot_i,         //判断当前指令是否为延迟槽指令
           input wire[`ALU_OP_BUS] ex_aluop,     //前一条指令的aluop
           
           //处于执行阶段的指令的运算结果
           input wire               ex_write_en_i,
           input wire[31:0]         ex_write_data_i,
           input wire[4:0]          ex_write_addr_i,
           //处于访存阶段的指令的运算结果
           input wire               mem_write_en_i,
           input wire[31:0]         mem_write_data_i,
           input wire[4:0]          mem_write_addr_i,
           
           output wire[31:0] inst_o,
           output reg reg_1_read_en,
           output reg reg_2_read_en,
           output reg[ 4: 0 ] reg_1_read_addr,
           output reg[ 4: 0 ] reg_2_read_addr,
           
           output reg[ `ALU_OP_BUS ] aluop,
           output reg[ 31: 0 ] source_operand_1,
           output reg[ 31: 0 ] source_operand_2,
           output reg[ 4: 0 ] reg_write_addr,
           output reg reg_write_en,

           output reg next_is_delayslot,    //会在下个周期传回来
           output reg branch_flag,          //跳转成功与否的标志量
           output reg[31:0] branch_addr,
        //    output reg[31:0] branch_return_addr,
           output reg is_delayslot_o,
           output wire id_stall_req
       );

assign inst_o = inst_i;

reg reg_1_isloadrelate;
reg reg_2_isloadrelate;
wire pre_inst_is_load;

assign pre_inst_is_load = (ex_aluop == `ALU_OP_LW)? 1'b1: 1'b0;

wire[ 5: 0 ] opcode = inst_i[ 31: 26 ];
wire[ 4: 0 ] rs = inst_i[ 25: 21 ];
wire[ 4: 0 ] rt = inst_i[ 20: 16 ];
wire[ 4: 0 ] rd = inst_i[ 15: 11 ];
wire[ 4: 0 ] sa = inst_i[ 10: 6 ];
wire[ 5: 0 ] funct = inst_i[ 5: 0 ];

wire[ 15: 0 ] immediate = inst_i[ 15: 0 ];
wire[ 25: 0 ] instr_index = inst_i[ 25: 0 ];

reg[ 31: 0 ] imm = `ZeroWord;

reg inst_valid;

wire[31:0] next_pc_addr = pc_i + 4;
wire[31:0] next_next_pc_addr = pc_i + 8;

always @ ( * )
    begin
        if ( rst == `RstEnable )
            begin
                aluop <= `NOP_ALU_OP;
                inst_valid <= `InstInvalid;
                reg_1_read_en <= `ReadDisable;
                reg_1_read_addr <= `NOP_Reg_Addr;
                reg_2_read_en <= `ReadDisable;
                reg_2_read_addr <= `NOP_Reg_Addr;
                reg_write_en <= `WriteDisable;
                reg_write_addr <= `NOP_Reg_Addr;

                next_is_delayslot <= `NO;
                branch_flag <= `NO;
                branch_addr <= `NOP_Reg_Addr;
            end
        else
            begin
                next_is_delayslot <= `NO;
                branch_flag <= `NO;
                branch_addr <= `NOP_Reg_Addr;
                
                case ( opcode )
                    `OP_OOO: begin 
                    case ( sa ) 5'b00000:
                        begin
                            case ( funct )
                                `FUNCT_ADDU:
                                    begin
                                        aluop <= `ALU_OP_ADD;
                                        inst_valid <= `InstValid;
                                        reg_1_read_en <= 1'b1;
                                        reg_1_read_addr <= rs;
                                        reg_2_read_en <= 1'b1;
                                        reg_2_read_addr <= rt;
                                        reg_write_en <= 1'b1;
                                        reg_write_addr <= rd;
                                    end
                                `FUNCT_OR:
                                    begin
                                        aluop <= `ALU_OP_OR;
                                        inst_valid <= `InstValid;
                                        reg_1_read_en <= 1'b1;
                                        reg_1_read_addr <= rs;
                                        reg_2_read_en <= 1'b1;
                                        reg_2_read_addr <= rt;
                                        reg_write_en <= 1'b1;
                                        reg_write_addr <= rd;
                                    end
                                `FUNCT_AND:
                                    begin
                                        aluop <= `ALU_OP_AND;
                                        inst_valid <= `InstValid;
                                        reg_1_read_en <= 1'b1;
                                        reg_1_read_addr <= rs;
                                        reg_2_read_en <= 1'b1;
                                        reg_2_read_addr <= rt;
                                        reg_write_en <= 1'b1;
                                        reg_write_addr <= rd;
                                    end 
                                `FUNCT_XOR:
                                    begin
                                        aluop <= `ALU_OP_XOR;
                                        inst_valid <= `InstValid;
                                        reg_1_read_en <= 1'b1;
                                        reg_1_read_addr <= rs;
                                        reg_2_read_en <= 1'b1;
                                        reg_2_read_addr <= rt;
                                        reg_write_en <= 1'b1;
                                        reg_write_addr <= rd;
                                    end                                 
                                default:
                                    begin
                                        aluop <= `NOP_ALU_OP;
                                        inst_valid <= `InstInvalid;
                                        reg_1_read_en <= `ReadDisable;
                                        reg_1_read_addr <= `NOP_Reg_Addr;
                                        reg_2_read_en <= `ReadDisable;
                                        reg_2_read_addr <= `NOP_Reg_Addr;
                                        reg_write_en <= `WriteDisable;
                                        reg_write_addr <= `NOP_Reg_Addr;
                                    end
                            endcase
                            end
                            default:
                                begin
                                    aluop <= `NOP_ALU_OP;
                                    inst_valid <= `InstInvalid;
                                    reg_1_read_en <= `ReadDisable;
                                    reg_1_read_addr <= `NOP_Reg_Addr;
                                    reg_2_read_en <= `ReadDisable;
                                    reg_2_read_addr <= `NOP_Reg_Addr;
                                    reg_write_en <= `WriteDisable;
                                    reg_write_addr <= `NOP_Reg_Addr;
                                end     
                            endcase
                        end
                    `OP_ORI:
                        begin
                            aluop <= `ALU_OP_OR;
                            inst_valid <= `InstValid;
                            reg_1_read_en <= 1'b1;
                            reg_1_read_addr <= rs;
                            reg_2_read_en <= 1'b0;
                            reg_2_read_addr <= `NOP_Reg_Addr;
                            reg_write_en <= 1'b1;
                            reg_write_addr <= rt;   
                            imm <= {16'h0, immediate};
                        end  
                    `OP_ANDI:
                        begin
                            aluop <= `ALU_OP_AND;
                            inst_valid <= `InstValid;
                            reg_1_read_en <= 1'b1;
                            reg_1_read_addr <= rs;
                            reg_2_read_en <= 1'b0;
                            reg_2_read_addr <= `NOP_Reg_Addr;
                            reg_write_en <= 1'b1;
                            reg_write_addr <= rt;   
                            imm <= {16'h0, immediate};
                        end  
                    `OP_XORI:
                        begin
                            aluop <= `ALU_OP_XOR;
                            inst_valid <= `InstValid;
                            reg_1_read_en <= 1'b1;
                            reg_1_read_addr <= rs;
                            reg_2_read_en <= 1'b0;
                            reg_2_read_addr <= `NOP_Reg_Addr;
                            reg_write_en <= 1'b1;
                            reg_write_addr <= rt;   
                            imm <= {16'h0, immediate};
                        end  
                    `OP_LUI:
                        begin
                            aluop <= `ALU_OP_OR;
                            inst_valid <= `InstValid;
                            reg_1_read_en <= 1'b1;
                            reg_1_read_addr <= 5'b00000;
                            reg_2_read_en <= 1'b0;
                            reg_2_read_addr <= `NOP_Reg_Addr;
                            reg_write_en <= 1'b1;
                            reg_write_addr <= rt;
                            imm <=  {immediate, 16'h0};
                        end
                    `OP_ADDIU:
                        begin
                            aluop <= `ALU_OP_ADD;
                            inst_valid <= `InstValid;
                            reg_1_read_en <= 1'b1;
                            reg_1_read_addr <= rs;
                            reg_2_read_en <= 1'b0;
                            reg_2_read_addr <= `NOP_Reg_Addr;
                            reg_write_en <= 1'b1;
                            reg_write_addr <= rt;
                            imm <= {{16{immediate[15]}}, immediate};
                        end  
                    `OP_BNE:
                        begin
                            aluop <= `NOP_ALU_OP;
                            inst_valid <= `InstValid;
                            reg_1_read_en <= 1'b1;
                            reg_1_read_addr <= rs;
                            reg_2_read_en <= 1'b1;
                            reg_2_read_addr <= rt;
                            reg_write_en <= 1'b0;
                            reg_write_addr <= `NOP_Reg_Addr;
                            imm <=  {immediate, 16'h0};
                            if(source_operand_1 != source_operand_2)
                                begin
                                    branch_addr <= next_pc_addr + {{14{immediate[15]}},immediate,2'b00};
                                    branch_flag <= `YES;
                                    next_is_delayslot <= `YES;
                                end
                            else
                                begin
                                    branch_addr <= `ZeroWord;
                                    branch_flag <= `NO;
                                    next_is_delayslot <= `NO;
                                end
                        end
                    `OP_SW:
                        begin
                            aluop <= `ALU_OP_SW;
                            inst_valid <= `InstValid;
                            reg_1_read_en <= 1'b1;
                            reg_1_read_addr <= rs;
                            reg_2_read_en <= 1'b1;
                            reg_2_read_addr <= rt;
                            reg_write_en <= 1'b0;
                            reg_write_addr <= `NOP_Reg_Addr;
                        end
                    `OP_LW:
                        begin
                            aluop <= `ALU_OP_LW;
                            inst_valid <= `InstValid;
                            reg_1_read_en <= 1'b1;
                            reg_1_read_addr <= rs;
                            reg_2_read_en <= 1'b0;
                            reg_2_read_addr <= `NOP_Reg_Addr;
                            reg_write_en <= 1'b1;
                            reg_write_addr <= rt;
                        end
                    default:
                        begin
                            aluop <= `NOP_ALU_OP;
                            inst_valid <= `InstInvalid;
                            reg_1_read_en <= `ReadDisable;
                            reg_1_read_addr <= `NOP_Reg_Addr;
                            reg_2_read_en <= `ReadDisable;
                            reg_2_read_addr <= `NOP_Reg_Addr;
                            reg_write_en <= `WriteDisable;
                            reg_write_addr <= `NOP_Reg_Addr;
                        end
                        
                endcase
            end
    end
    

always @(*) begin
    if (rst == `RstEnable) begin
        reg_1_isloadrelate <= `STOP;
    end
    else if(pre_inst_is_load==1'b1 && reg_1_read_en==1'b1 && ex_write_addr_i==reg_1_read_addr) begin
        reg_1_isloadrelate <= `STOP;
    end
    else begin
        reg_1_isloadrelate <= `NO_STOP;
    end
end

always @(*) begin
    if (rst == `RstEnable) begin
        reg_2_isloadrelate <= `STOP;
    end
    else if(pre_inst_is_load==1'b1 && reg_2_read_en==1'b1 && ex_write_addr_i==reg_2_read_addr) begin
        reg_2_isloadrelate <= `STOP;
    end
    else begin
        reg_2_isloadrelate <= `NO_STOP;
    end
end

assign id_stall_req = reg_1_isloadrelate | reg_2_isloadrelate;

always @ ( * )
    begin
        if ( rst == `RstEnable )
            begin
                source_operand_1 <= `ZeroWord;
            end
        else if ( ( reg_1_read_en == 1'b1 ) && ( ex_write_en_i == 1'b1 ) && ( ex_write_addr_i == reg_1_read_addr ) )   //5.2
            begin
                source_operand_1 <= ex_write_data_i;
            end
        else if ( ( reg_1_read_en == 1'b1 ) && ( mem_write_en_i == 1'b1 ) && ( mem_write_addr_i == reg_1_read_addr ) )   //5.2
            begin
                source_operand_1 <= mem_write_data_i;
            end
        else if ( reg_1_read_en == 1'b1 )
            begin
                source_operand_1 <= reg_1_data_i;
            end
        else if ( reg_1_read_en == 1'b0 )
            begin
                source_operand_1 <= imm;
            end
        else
            begin
                source_operand_1 <= `ZeroWord;
            end
    end
    
    
always @ ( * )
    begin
        if ( rst == `RstEnable )
            begin
                source_operand_2 <= `ZeroWord;
            end
        else if ( ( reg_2_read_en == 1'b1 ) && ( ex_write_en_i == 1'b1 ) && ( ex_write_addr_i == reg_2_read_addr ) )   //5.2
            begin
                source_operand_2 <= ex_write_data_i;
            end
        else if ( ( reg_2_read_en == 1'b1 ) && ( mem_write_en_i == 1'b1 ) && ( mem_write_addr_i == reg_2_read_addr ) )   //5.2
            begin
                source_operand_2 <= mem_write_data_i;
            end
        else if ( reg_2_read_en == 1'b1 )
            begin
                source_operand_2 <= reg_2_data_i;
            end
        else if ( reg_2_read_en == 1'b0 )
            begin
                source_operand_2 <= imm;
            end
        else
            begin
               source_operand_2 <= `ZeroWord;
            end
    end

always @(*) begin
    if(rst == `RstEnable)
    begin
        is_delayslot_o <= `NO;
    end
    else
    begin
        is_delayslot_o <= is_delayslot_i;
    end
end

endmodule