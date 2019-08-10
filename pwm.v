`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2019 04:38:06 PM
// Design Name: 
// Module Name: pwm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module pwm #(parameter size=8, period=255)
(input CLK,
input [size-1:0] duty,
output done,
output reg pwm_out);
reg [size-1:0] count=0;
initial  pwm_out<=0;

assign done = (count == period) ? 1 : 0;

always @(posedge CLK) begin
    count<=(count<=period)?(count+1):0;
    pwm_out<=count<duty;
end

endmodule
