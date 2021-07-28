/**************************************************
 *
 *  描述：
 *  stall[0]:取值地址pc是否保持不变
 *  stall[1]:if_id级是否暂停
 *  stall[2]:id级是否暂停
 *  stall[3]:ex级是否暂停
 *  stall[4]:mem级是否暂停
 *  stall[5]:wb级是否暂停
 *
 **************************************************/



module ctrl_stall (
           input wire rst,
           input wire ex_stall_req,
           input wire id_stall_req,

           output reg[ 5: 0 ] stall       //stall信号
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