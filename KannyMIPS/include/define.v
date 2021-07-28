/*****************************************************************************
 * 	文件名称：define.v
 * 	文件说明：KannyMIPS中会用到的一些宏
 * 
 * 	作者：王凯宁
 * 	创建时间：2021-7-10 * 
 * 
 *****************************************************************************/




/* 			              *** 全局 宏定义(使能信号等) ***
 *****************************************************************************/
`define	RstEnable			1'b1				//复位信号有效
`define RstDisable			1'b0				//复位信号无效
`define WriteEnable         1'b1                //写使能
`define WriteDisable        1'b0                //写无效
`define ReadEnable          1'b1                //读使能
`define ReadDisable         1'b0                //读无效

`define ChipEnable          1'b1                //芯片使能信号
`define ChipDisable         1'b0                //芯片禁用信号

`define ZeroWord            32'h0000_0000       //32位的数值0

`define ALU_OP_BUS          7:0                 //译码阶段的输出aluop_o的宽度

`define InstValid           1'b0                //指令有效
`define InstInvalid         1'b1                //指令无效

`define YES                 1'b1                //分支跳转 / 是延迟槽指令
`define NO                  1'b0                //分支不跳转 / 不是延迟槽指令

`define STOP                1'b1                //流水线暂停信号
`define NO_STOP             1'b0                //流水线继续信号


/*                     *** 寄存器(Reg) 相关宏定义 ***
 *****************************************************************************/

`define NOP_Reg_Addr        5'b00000




/*                     *** OPCODE 相关宏定义 ***
 *****************************************************************************/
`define OP_OOO              6'b000000           // R型指令为0的操作码

`define OP_ORI              6'b001101           // ori的操作码
`define OP_LUI              6'b001111           // lui的操作码
`define OP_ANDI             6'b001100           // andi的操作码
`define OP_XORI             6'b001110           // xori的操作码
`define OP_BNE              6'b000101           // bne的操作码
`define OP_ADDIU            6'b001001           // addiu的操作码
`define OP_LW               6'b100011           // lw的操作码
`define OP_SW               6'b101011           // sw的操作码


/*                     *** FUNCT 相关宏定义 ***
 *****************************************************************************/
`define FUNCT_ADDU          6'b100001           // ADDU指令的功能码
`define FUNCT_OR            6'b100101           // OR指令的功能码
`define FUNCT_AND           6'b100100           // AND指令的功能码
`define FUNCT_XOR           6'b100110           // XOR指令的功能码


/*                     *** ALU_OP 相关宏定义 ***
 *****************************************************************************/
`define NOP_ALU_OP          8'b0000_0000         ///< 空

`define ALU_OP_OR           8'b0000_0001         ///< 或
`define ALU_OP_AND          8'b0000_0010
`define ALU_OP_XOR          8'b0000_0011
`define ALU_OP_ADD          8'b0000_0100         ///< 加

`define ALU_OP_LW           8'b0000_0101
`define ALU_OP_SW           8'b0000_0110