
module sram_controller (
    input wire rst,
    input wire clk,
    // base_ram
    input wire rom_ce,
    input wire[31:0] rom_addr,
    output reg base_ram_ce,
    output reg base_ram_read_en,
    output reg base_ram_write_en,
    output reg[3:0] base_ram_select,
    output reg[19:0] base_ram_addr,

    inout wire[31:0] base_ram_data,
    output reg[31:0] inst_from_rom,

    // ext_ram
    input wire ram_ce,
    input wire ram_write_en,
    input wire[3:0] ram_select,
    input wire[31:0] ram_write_addr,
    input wire[31:0] ram_write_data,
    output reg ext_ram_ce,
    output reg ext_ram_read_en,
    output reg ext_ram_write_en,
    output reg[3:0] ext_ram_select,
    output reg[19:0] ext_ram_addr,

    inout wire[31:0] ext_ram_data,
    output reg[31:0] data_from_ram

);

wire in_base_ram = rom_addr>=32'h8000_0000 && rom_addr<32'h8040_0000;
wire in_ext_ram = ram_write_addr>=32'h8040_0000 && ram_write_addr<32'h8080_0000;
wire[31:0] inst_from_rom_temp;
wire[31:0] data_from_ram_temp;

assign base_ram_data = 32'hzzzz_zzzz;
assign inst_from_rom_temp = base_ram_data;

always @(*) begin
    if(rst) begin
        base_ram_ce <= 1'b1;
        base_ram_read_en <= 1'b1;
        base_ram_write_en <= 1'b1;
        base_ram_select <= 4'b1111;
        base_ram_addr <= 20'h00000;
    end
    else begin
        if(rom_ce && in_base_ram) begin
            base_ram_ce <= 1'b0;
            base_ram_read_en <= 1'b0;
            base_ram_write_en <= 1'b1;
            base_ram_select <= 4'b0000;
            base_ram_addr <= rom_addr[21:2];
        end
        else begin
            base_ram_ce <= 1'b1;
            base_ram_read_en <= 1'b1;
            base_ram_write_en <= 1'b1;
            base_ram_select <= 4'b1111;
            base_ram_addr <= 20'h00000;
        end
        inst_from_rom <= inst_from_rom_temp;
    end
end

assign ext_ram_data = (ram_write_en && in_ext_ram) ? ram_write_data :32'hzzzz_zzzz;
assign data_from_ram_temp = ext_ram_data;

always @(*) begin
    if(rst) begin
        ext_ram_ce <= 1'b1;
        ext_ram_read_en <= 1'b1;
        ext_ram_write_en <= 1'b1;
        ext_ram_select <= 4'b1111;
        ext_ram_addr <= 20'h00000;
    end
    else begin
        if(ram_ce && in_ext_ram) begin
            ext_ram_ce <= 1'b0;
            ext_ram_read_en <= ram_write_en;
            ext_ram_write_en <= !ram_write_en;
            ext_ram_select <= !ram_select;
            ext_ram_addr <= ram_write_addr[21:2];
        end
        else begin
            ext_ram_ce <= 1'b1;
            ext_ram_read_en <= 1'b1;
            ext_ram_write_en <= 1'b1;
            ext_ram_select <= 4'b1111;
            ext_ram_addr <= 20'h00000;
        end
        data_from_ram <= data_from_ram_temp;
    end
end


endmodule