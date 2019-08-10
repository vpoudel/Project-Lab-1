`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2019 01:13:44 PM
// Design Name: 
// Module Name: turn_test_tb
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


module turn_test_tb(
     );
    reg CLK;
    reg enable_motor;
    reg [1:0] turn_procedure;
    reg [3:0] RF_sensor;
    wire state_forward;
    wire state_reverse;
    wire state_turnL;
    wire state_turnR;
    wire state_brake;
    wire [1:0] motorL;
    wire [1:0] motorR;
    wire [1:0] enableAB;
    wire done_turning;
   // wire [29:0] turncount;

    initial begin
    RF_sensor <= 0;
    CLK <= 0;
    enable_motor <= 1;
    turn_procedure<=1;
    //#2_400 turn_procedure<=turn_procedure+1;
    
    #1000
    RF_sensor = 1;
    #1000
    RF_sensor = 0;
    #1000
    RF_sensor = 2;
    #1000
    RF_sensor = 0;
    #1000
    #2000
    enable_motor = 0;
    end
    
    always begin
    #5 CLK = ~CLK;
    end
   // always @(*) begin
       // if(done_turning==1)
     //   enable_motor<=0;
   // end
    
    rover_sensors uut(
    .CLK(CLK),
    .enable_motor(enable_motor),
    .turn_procedure(turn_procedure),
    .RF_sensor(RF_sensor),
    .motorL(motorL),
    .motorR(motorR),
    .enableAB(enableAB),
    .state_forward(state_forward),
    .state_reverse(state_reverse),
    .state_turnL(state_turnL),
    .state_turnR(state_turnR),
    .state_brake(state_brake),
    .done_turning(done_turning)
    //.turncount(turncount)
    );
    
endmodule
