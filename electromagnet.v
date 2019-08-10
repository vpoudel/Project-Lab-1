`timescale 1ns / 1ps

module electromagnet(
    input start_magnet,
    output reg magnet_on
);
initial begin
magnet_on<=0;
end
    always @(*) begin
        if(start_magnet==1)
            magnet_on=1;
        else
            magnet_on=0;
    end    
endmodule