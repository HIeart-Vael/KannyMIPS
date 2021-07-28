//`include "define.v"

module pc (
           input wire clk,
           input wire rst,
           input wire[5:0] stall,
           input wire branch_flag,
           input wire[31: 0] branch_addr,

           output reg[31: 0] pc,
           output reg ce
       );

//芯片使能 or 芯片禁止
always @ (posedge clk) begin
    if (rst == `RstEnable) begin
        ce <= `ChipDisable;
    end
    else begin
        ce <= `ChipEnable;
    end
end


always @ (posedge clk) begin
    if (ce == `ChipDisable) begin
        pc <= 32'h8000_0000;    //指令存储器禁用时，pc为0；
    end
    else if (stall[0] == `NO_STOP) begin
        if (branch_flag == `YES) begin
            pc <= branch_addr;
        end
        else begin
            pc <= pc + 4'b0100;    //指令存储器使能时，pc的值每时钟周期加4；
        end
    end
end
endmodule