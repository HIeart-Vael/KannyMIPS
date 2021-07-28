/**************************************************
 *
 *  ������
 *  stall[0]:ȡֵ��ַpc�Ƿ񱣳ֲ���
 *  stall[1]:if_id���Ƿ���ͣ
 *  stall[2]:id���Ƿ���ͣ
 *  stall[3]:ex���Ƿ���ͣ
 *  stall[4]:mem���Ƿ���ͣ
 *  stall[5]:wb���Ƿ���ͣ
 *
 **************************************************/



module ctrl_stall (
           input wire rst,
           input wire ex_stall_req,
           input wire id_stall_req,

           output reg[ 5: 0 ] stall       //stall�ź�
       );

always @( * ) begin
    if ( rst == `RstEnable ) begin
        stall <= 6'b000000;
    end
    else if ( ex_stall_req == `STOP ) begin
        stall <= 6'b001111;
    end
    else if ( id_stall_req == `STOP ) begin
        stall <= 6'b000111;
    end
    else begin
        stall <= 6'b000000;
    end
end

endmodule