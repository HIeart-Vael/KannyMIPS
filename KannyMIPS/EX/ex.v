module ex (
        input wire rst,
        
        input wire[31:0] inst_i,
        input wire[ `ALU_OP_BUS ] aluop_i,
        
        input wire[ 31: 0 ] operand_1,
        input wire[ 31: 0 ] operand_2,
        input wire[ 4: 0 ] write_addr_i,
        input wire write_en_i,
        
        input wire is_delayslot,     // 当前指令是否为延迟槽指令
    //    input wire[31:0] branch_return_addr,     // 转移指令要保存的返回地址
        
        output wire[`ALU_OP_BUS] aluop_o,
        output wire[31:0] mem_addr,
        output wire[31:0] mem_data,
        output reg ex_stall_req,
        output reg[ 4: 0 ] write_addr_o,
        output reg write_en_o,
        output reg[ 31: 0 ] write_data
           
       );

assign aluop_o = aluop_i;
assign mem_addr = operand_1 + {{16{inst_i[15]}}, inst_i[15: 0]};
assign mem_data = operand_2;


always @ ( * )
    begin
        if ( rst == `RstEnable )
            begin
                write_addr_o <= 5'b00000;
                write_en_o <= 1'b0;
                write_data <= 32'h0000_0000;
            end
        else if(is_delayslot == `YES)
            begin
                write_addr_o <= `NOP_Reg_Addr;
                write_en_o <= `WriteDisable;
                write_data <= `ZeroWord;
            end
        else
            begin
                write_addr_o <= write_addr_i;
                write_en_o <= write_en_i;
                
                case ( aluop_i )
                    `ALU_OP_OR:
                        begin
                            write_data <= operand_1 | operand_2;
                        end
                        
                    `ALU_OP_AND:
                        begin
                            write_data <= operand_1 & operand_2;
                        end
                        
                    `ALU_OP_ADD:
                        begin
                            write_data <= operand_1 + operand_2;
                        end
                        
                    `ALU_OP_XOR:
                        begin
                            write_data <= operand_1 ^ operand_2;
                        end
                    `NOP_ALU_OP:
                        begin
                            write_data <= `ZeroWord;
                        end   
                    default:
                        begin
                            write_data <= `ZeroWord;
                        end
                        
                endcase
            end
    end
    
    
endmodule