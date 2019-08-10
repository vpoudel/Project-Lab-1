`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2019 03:26:59 PM
// Design Name: 
// Module Name: IPS_tb
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



module IPS_tb();
    
    reg CLK;
    reg IPS_detect;
    wire washer_found;


IPS uut(
        .IPS_detect(IPS_detect),
        .CLK(CLK),
        .washer_found(washer_found)
        );
  
    
    initial begin
        IPS_detect=0;
        CLK=0;
        begin
        #200 IPS_detect=~IPS_detect;
        end
   end

    
 always #5 CLK=~CLK;
  
endmodule
