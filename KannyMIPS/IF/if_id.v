module if_id(
           input wire rst,
           input wire clk,
           input wire[31: 0] pc_i,
           input wire[31: 0] inst_i,
           input wire[5: 0] stall,

           output reg[31: 0] pc_o,
           output reg[31: 0] inst_o
       );

// rst有效，pc、inst置零，否则向下一级传递；
always @ (posedge clk) begin
    if (rst == `RstEnable) begin
        pc_o <= 32'h0000_0000;
        inst_o <= 32'h0000_0000;
    end
    else if (stall[1] == `STOP && stall[2] == `NO_STOP) begin
        pc_o <= `ZeroWord;
        inst_o <= `ZeroWord;
    end
    else if (stall[1] == `NO_STOP) begin
        pc_o <= pc_i;
        inst_o <= inst_i;
    end
end

endmodule