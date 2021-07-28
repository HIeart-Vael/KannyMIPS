module KannyMIPS (
        input wire clk,
        input wire rst,

        input wire[31: 0] rom_inst_i,
        input wire[31: 0] ram_data_i,

        output wire[31: 0] rom_addr_o,
        output wire rom_en,
        output wire[31: 0] ram_addr_o,
        output wire ram_en,
        output wire[31: 0] ram_data_o,
        output wire[3:0] ram_select,
        output wire ram_write_en   // 确定是读还是写

    );

// PC 模块例化 ********************************
wire[31: 0] pc_pc_ifid;
wire branch_flag;
wire[31: 0] branch_addr;
wire[5: 0] stall;
pc PC (
        .clk (clk),
        .rst (rst),
        .stall (stall),
        .branch_flag (branch_flag),
        .branch_addr (branch_addr),
        .pc (pc_pc_ifid),
        .ce (rom_en)
    );
assign rom_addr_o = pc_pc_ifid;

// IF_ID 模块例化 *****************************
wire[31: 0] ifid_pc_id;
wire[31: 0] ifid_inst_id;
if_id IF_ID (
        .clk (clk),
        .rst (rst),
        .stall (stall),
        .pc_i (pc_pc_ifid),
        .inst_i (rom_inst_i),
        .pc_o (ifid_pc_id),
        .inst_o (ifid_inst_id)
    );

// ID 模块例化 ********************************
wire[31: 0] reg_1_data;
wire[31: 0] reg_2_data;
wire reg_1_read_en;
wire[4: 0] reg_1_read_addr;
wire reg_2_read_en;
wire[4: 0] reg_2_read_addr;

wire[`ALU_OP_BUS] id_aluop_idex;
wire[31: 0] id_source_operand1_idex;
wire[31: 0] id_source_operand2_idex;
wire[4: 0] id_reg_write_addr_idex;

wire[31:0] id_inst_idex;
wire id_reg_write_en_idex;

wire is_delayslot;
wire next_is_delayslot;
wire id_is_delayslot_idex;

wire id_stall_req;

id ID (
        .rst (rst),
        .pc_i (ifid_pc_id),
        .inst_i (ifid_inst_id),

        .reg_1_data_i (reg_1_data),
        .reg_2_data_i (reg_2_data),

        .ex_aluop (ex_aluop_exmem),
        .is_delayslot_i (is_delayslot),
        .next_is_delayslot (next_is_delayslot),
        .branch_flag (branch_flag),
        .branch_addr (branch_addr),
        .is_delayslot_o (id_is_delayslot_idex),

        .ex_write_en_i (ex_reg_write_en_exmem),
        .ex_write_data_i (ex_reg_write_data_exmem),
        .ex_write_addr_i (ex_reg_write_addr_exmem),
        .mem_write_en_i (mem_reg_write_en_memwb),
        .mem_write_data_i (mem_reg_write_data_memwb),
        .mem_write_addr_i (mem_reg_write_addr_memwb),

        .inst_o (id_inst_idex),
        .reg_1_read_en (reg_1_read_en),
        .reg_1_read_addr (reg_1_read_addr),
        .reg_2_read_en (reg_2_read_en),
        .reg_2_read_addr (reg_2_read_addr),

        .aluop (id_aluop_idex),
        .source_operand_1 (id_source_operand1_idex),
        .source_operand_2 (id_source_operand2_idex),
        .reg_write_addr (id_reg_write_addr_idex),
        .reg_write_en (id_reg_write_en_idex),
        .id_stall_req (id_stall_req)
    );

// id_ex 模块例化 **********************************
wire[`ALU_OP_BUS] idex_aluop_ex;
wire[31: 0] idex_source_operand1_ex;
wire[31: 0] idex_source_operand2_ex;
wire idex_reg_write_en_ex;
wire[4: 0] idex_reg_write_addr_ex;
wire[31:0] idex_inst_ex;
wire idex_is_delayslot_ex;

id_ex ID_EX (
        .clk (clk),
        .rst (rst),

        .inst_i (id_inst_idex),
        .stall (stall),
        .aluop_i (id_aluop_idex),
        .source_operand_1_i (id_source_operand1_idex),
        .source_operand_2_i (id_source_operand2_idex),
        .write_addr_i (id_reg_write_addr_idex),
        .write_en_i (id_reg_write_en_idex),
        .is_delayslot_i (id_is_delayslot_idex),
        .next_is_delayslot_i (next_is_delayslot),

        .inst_o (idex_inst_ex),
        .aluop_o (idex_aluop_ex),
        .source_operand_1_o (idex_source_operand1_ex),
        .source_operand_2_o (idex_source_operand2_ex),
        .write_addr_o (idex_reg_write_addr_ex),
        .write_en_o (idex_reg_write_en_ex),
        .is_delayslot_o (idex_is_delayslot_ex),
        .next_is_delayslot_o (is_delayslot)
    );

// EX 模块例化 *******************************************
wire ex_reg_write_en_exmem;
wire[4: 0] ex_reg_write_addr_exmem;
wire[31: 0] ex_reg_write_data_exmem;
wire[`ALU_OP_BUS] ex_aluop_exmem;
wire ex_stall_req;
wire[31:0] ex_ram_write_addr_exmem;
wire[31:0] ex_ram_write_data_exmem;

ex EX (
        .rst (rst),

        .inst_i (idex_inst_ex),
        .aluop_i (idex_aluop_ex),
        .operand_1 (idex_source_operand1_ex),
        .operand_2 (idex_source_operand2_ex),
        .write_addr_i (idex_reg_write_addr_ex),
        .write_en_i (idex_reg_write_en_ex),
        .is_delayslot (idex_is_delayslot_ex),

        .aluop_o (ex_aluop_exmem),
        .mem_addr (ex_ram_write_addr_exmem),
        .mem_data (ex_ram_write_data_exmem),
        .write_addr_o (ex_reg_write_addr_exmem),
        .write_en_o (ex_reg_write_en_exmem),
        .write_data (ex_reg_write_data_exmem),
        .ex_stall_req (ex_stall_req)
    );

// ex_mem 模块例化 *****************************************
wire exmem_reg_write_en_mem;
wire[4: 0] exmem_reg_write_addr_mem;
wire[31: 0] exmem_reg_write_data_mem;
wire[`ALU_OP_BUS] exmem_aluop_mem;
wire[31:0] exmem_ram_write_addr_mem;
wire[31:0] exmem_ram_write_data_mem;

ex_mem EX_MEM (
        .clk (clk),
        .rst (rst),

        .aluop_i (ex_aluop_exmem),
        .mem_addr_i (ex_ram_write_addr_exmem),
        .mem_data_i (ex_ram_write_data_exmem),
        .stall (stall),
        .write_addr_i (ex_reg_write_addr_exmem),
        .write_en_i (ex_reg_write_en_exmem),
        .write_data_i (ex_reg_write_data_exmem),

        .aluop_o (exmem_aluop_mem),
        .mem_addr_o (exmem_ram_write_addr_mem),
        .mem_data_o (exmem_ram_write_data_mem),
        .write_addr_o (exmem_reg_write_addr_mem),
        .write_en_o (exmem_reg_write_en_mem),
        .write_data_o (exmem_reg_write_data_mem)
    );

// mem模块例化 ****************************************
wire mem_reg_write_en_memwb;
wire[4: 0] mem_reg_write_addr_memwb;
wire[31: 0] mem_reg_write_data_memwb;
wire[31:0] mem_ram_write_addr_memwb;
wire[31:0] mem_ram_write_data_memwb;
wire mem_en;
wire mem_write_en;
wire[3:0] mem_select;

mem MEM (
        .rst (rst),

        .aluop (exmem_aluop_mem),
        .mem_write_addr_i (exmem_ram_write_addr_mem),
        .mem_write_data_i (exmem_ram_write_data_mem),
        .read_data_from_mem (ram_data_i),
        .reg_write_addr_i (exmem_reg_write_addr_mem),
        .reg_write_en_i (exmem_reg_write_en_mem),
        .reg_write_data_i (exmem_reg_write_data_mem),

        .mem_write_addr_o (ram_addr_o),
        .mem_write_data_o (ram_data_o),
        .mem_en (ram_en),
        .mem_write_en (ram_write_en),
        .mem_select (ram_select),

        .reg_write_addr_o (mem_reg_write_addr_memwb),
        .reg_write_en_o (mem_reg_write_en_memwb),
        .reg_write_data_o (mem_reg_write_data_memwb)
    );

// mem_wb 模块例化 ***************************************
wire memwb_reg_write_en_wb;
wire[4: 0] memwb_reg_write_addr_wb;
wire[31: 0] memwb_reg_write_data_wb;
mem_wb MEM_WB (
        .clk (clk),
        .rst (rst),

        .stall (stall),
        // .mem_write_addr_i (mem_ram_write_addr_memwb),
        // .mem_write_data_i (mem_ram_write_data_memwb),
        // .mem_en_i (mem_en),
        // .mem_write_en_i (mem_write_en),
        // .mem_select_i (mem_select),
        .reg_write_addr_i (mem_reg_write_addr_memwb),
        .reg_write_en_i (mem_reg_write_en_memwb),
        .reg_write_data_i (mem_reg_write_data_memwb),

        // .mem_write_addr_o (ram_addr_o),
        // .mem_write_data_o (ram_data_o),
        // .mem_en_o (ram_en),
        // .mem_write_en_o (ram_write_en),
        // .mem_select_o (ram_select),
        .reg_write_addr_o (memwb_reg_write_addr_wb),
        .reg_write_en_o (memwb_reg_write_en_wb),
        .reg_write_data_o (memwb_reg_write_data_wb)
    );

// regfile 模块例化 ******************************************

regfile RegFile (
        .clk (clk),
        .rst (rst),
        .write_en (memwb_reg_write_en_wb),
        .write_addr (memwb_reg_write_addr_wb),
        .write_data (memwb_reg_write_data_wb),

        .read_en_1 (reg_1_read_en),
        .read_addr_1 (reg_1_read_addr),
        .read_data_1 (reg_1_data),
        .read_en_2 (reg_2_read_en),
        .read_addr_2 (reg_2_read_addr),
        .read_data_2 (reg_2_data)
    );

ctrl_stall CTRL (
        .rst (rst),
        .ex_stall_req (ex_stall_req),
        .id_stall_req (id_stall_req),

        .stall (stall)
    );

endmodule