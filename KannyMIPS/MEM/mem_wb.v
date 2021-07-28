module mem_wb (
        input wire clk,
        input wire rst,

        // input wire[31:0] mem_write_addr_i,
        // input wire[31:0] mem_write_data_i,
        // input wire mem_en_i,
        // input wire mem_write_en_i,
        // input wire[3:0] mem_select_i,
        input wire[5: 0] stall,
        input wire[ 4: 0 ] reg_write_addr_i,
        input wire reg_write_en_i,
        input wire[ 31: 0 ] reg_write_data_i,

        // output reg[31:0] mem_write_addr_o,
        // output reg[31:0] mem_write_data_o,
        // output reg mem_en_o,
        // output reg mem_write_en_o,
        // output reg[3:0] mem_select_o,
        output reg[ 4: 0 ] reg_write_addr_o,
        output reg reg_write_en_o,
        output reg[ 31: 0 ] reg_write_data_o
       );

always @( posedge clk ) begin
    if ( rst == `RstEnable ) begin
//        mem_write_addr_o <= `ZeroWord;
//        mem_write_data_o <= `ZeroWord;
//        mem_en_o <=`ChipDisable;
//        mem_write_en_o <= `WriteDisable;
//        mem_select_o <= 4'b0000;
        reg_write_addr_o <= `NOP_Reg_Addr;
        reg_write_en_o <= `WriteDisable;
        reg_write_data_o <= `ZeroWord;
    end
    else if (stall[4] == `STOP && stall[5] == `NO_STOP) begin
//        mem_write_addr_o <= `ZeroWord;
//        mem_write_data_o <= `ZeroWord;
//        mem_en_o <=`ChipDisable;
//        mem_write_en_o <= `WriteDisable;
//        mem_select_o <= 4'b0000;
        reg_write_addr_o <= `NOP_Reg_Addr;
        reg_write_en_o <= `WriteDisable;
        reg_write_data_o <= `ZeroWord;
    end
    else if (stall[4] == `NO_STOP) begin
//        mem_write_addr_o <= mem_write_addr_i;
//        mem_write_data_o <= mem_write_data_i;
//        mem_en_o <= mem_en_i;
//        mem_write_en_o <= mem_write_en_i;
//        mem_select_o <= mem_select_i;
        reg_write_addr_o <= reg_write_addr_i;
        reg_write_en_o <= reg_write_en_i;
        reg_write_data_o <= reg_write_data_i;
    end
end
endmodule