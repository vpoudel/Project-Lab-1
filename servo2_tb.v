`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2019 05:52:31 PM
// Design Name: 
// Module Name: servo2_tb
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


module servo2_tb();
    reg CLK;
    reg go_up=1;
    reg done_period;
    
    //outputs
    wire [7:0] angle;
    wire reset_magnet;
   
   
    pullup_servo_dostuff uut(
        .CLK(CLK),
        .go_up(go_up),
        .done_period(done_period),
        .angle(angle),
        .reset_magnet(reset_magnet)
        );
        
        always #5 CLK = ~CLK;
        
        always #20
        begin
            done_period <= 1;
            #10 done_period <= 0;
        end

        initial begin
            CLK <= 0;
            done_period <= 0;
            #200 go_up <= 0;
        end    
endmodule
