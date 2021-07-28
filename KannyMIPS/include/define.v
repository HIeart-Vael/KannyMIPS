/*****************************************************************************
 * 	�ļ����ƣ�define.v
 * 	�ļ�˵����KannyMIPS�л��õ���һЩ��
 * 
 * 	���ߣ�������
 * 	����ʱ�䣺2021-7-10 * 
 * 
 *****************************************************************************/




/* 			              *** ȫ�� �궨��(ʹ���źŵ�) ***
 *****************************************************************************/
`define	RstEnable			1'b1				//��λ�ź���Ч
`define RstDisable			1'b0				//��λ�ź���Ч
`define WriteEnable         1'b1                //дʹ��
`define WriteDisable        1'b0                //д��Ч
`define ReadEnable          1'b1                //��ʹ��
`define ReadDisable         1'b0                //����Ч

`define ChipEnable          1'b1                //оƬʹ���ź�
`define ChipDisable         1'b0                //оƬ�����ź�

`define ZeroWord            32'h0000_0000       //32λ����ֵ0

`define ALU_OP_BUS          7:0                 //����׶ε����aluop_o�Ŀ��

`define InstValid           1'b0                //ָ����Ч
`define InstInvalid         1'b1                //ָ����Ч

`define YES                 1'b1                //��֧��ת / ���ӳٲ�ָ��
`define NO                  1'b0                //��֧����ת / �����ӳٲ�ָ��

`define STOP                1'b1                //��ˮ����ͣ�ź�
`define NO_STOP             1'b0                //��ˮ�߼����ź�


/*                     *** �Ĵ���(Reg) ��غ궨�� ***
 *****************************************************************************/

`define NOP_Reg_Addr        5'b00000




/*                     *** OPCODE ��غ궨�� ***
 *****************************************************************************/
`define OP_OOO              6'b000000           // R��ָ��Ϊ0�Ĳ�����

`define OP_ORI              6'b001101           // ori�Ĳ�����
`define OP_LUI              6'b001111           // lui�Ĳ�����
`define OP_ANDI             6'b001100           // andi�Ĳ�����
`define OP_XORI             6'b001110           // xori�Ĳ�����
`define OP_BNE              6'b000101           // bne�Ĳ�����
`define OP_ADDIU            6'b001001           // addiu�Ĳ�����
`define OP_LW               6'b100011           // lw�Ĳ�����
`define OP_SW               6'b101011           // sw�Ĳ�����


/*                     *** FUNCT ��غ궨�� ***
 *****************************************************************************/
`define FUNCT_ADDU          6'b100001           // ADDUָ��Ĺ�����
`define FUNCT_OR            6'b100101           // ORָ��Ĺ�����
`define FUNCT_AND           6'b100100           // ANDָ��Ĺ�����
`define FUNCT_XOR           6'b100110           // XORָ��Ĺ�����


/*                     *** ALU_OP ��غ궨�� ***
 *****************************************************************************/
`define NOP_ALU_OP          8'b0000_0000         ///< ��

`define ALU_OP_OR           8'b0000_0001         ///< ��
`define ALU_OP_AND          8'b0000_0010
`define ALU_OP_XOR          8'b0000_0011
`define ALU_OP_ADD          8'b0000_0100         ///< ��

`define ALU_OP_LW           8'b0000_0101
`define ALU_OP_SW           8'b0000_0110