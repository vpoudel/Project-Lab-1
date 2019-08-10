`timescale 1ns / 1ps

module IPS(
    input IPS_to_basys, 
    output reg IPS_detect
    );
    always @(*) begin
        IPS_detect= ~IPS_to_basys;
    end
endmodule
