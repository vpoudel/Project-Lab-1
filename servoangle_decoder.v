`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2019 04:39:15 PM
// Design Name: 
// Module Name: servoangle_decoder
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

module servoangle_decoder(
    input [7:0] angle,
    output [20:0] value
    );
    
    assign value = 10'd555*angle+20'd100_000;
    
//    always @(angle) begin
//       //value=(10'd944)*ansgle+16'd60000;
//       value=10'd555*angle+20'd100_000;
//       //value=12'd667*angle+20'd90000;
//    end
endmodule
