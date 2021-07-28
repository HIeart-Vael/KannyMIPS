module regfile(
        input  wire              rst,
        input  wire              clk,

        input  wire              write_en,
        input  wire[4:0]         write_addr,
        input  wire[31:0]        write_data,

        input  wire              read_en_1,
        input  wire[4:0]         read_addr_1,
        input  wire              read_en_2,
        input  wire[4:0]         read_addr_2,

        output reg[31:0]         read_data_1,
        output reg[31:0]         read_data_2
    );

reg[31:0] regs[0:31];

// ????????? ***************************************************
integer i;
always @ (posedge clk)
    begin
        if(rst == `RstEnable)
            begin
                for (i=0; i<32; i=i+1)
                begin
                    regs[i] = 32'b0000_0000;
                end
            end
        else
            begin
                if ((write_en==`WriteEnable) && (write_addr != 5'h0))
                    begin
                        regs[write_addr] <= write_data;
                    end
            end
    end

// ????????????????????¡§?????????????????? **********************************
always @ (*)
    begin
        if(rst==`RstEnable || read_addr_1==5'b0)
            begin
                read_data_1 <= `ZeroWord;
            end
        else if((read_addr_1==write_addr) && (write_en==`WriteEnable) && (read_en_1==`ReadEnable))
            begin
                read_data_1 <= write_data;
            end
        else if(read_en_1==`ReadEnable)
            begin
                read_data_1 <= regs[read_addr_1];
            end
        else
            begin
                read_data_1 <= `ZeroWord;
            end
    end

// ????????????????????¡§?????????????????? *************************************
always @ (*)
    begin
        if(rst==`RstEnable || read_addr_2==5'b0)
            begin
                read_data_2 <= `ZeroWord;
            end
        else if((read_addr_2==write_addr) && (write_en==`WriteEnable) && (read_en_2==`ReadEnable))
            begin
                read_data_2 <= write_data;
            end
        else if(read_en_2==`ReadEnable)
            begin
                read_data_2 <= regs[read_addr_2];
            end
        else
            begin
                read_data_2 <= `ZeroWord;
            end
    end

endmodule