`timescale 1ns / 1ps

module movement_test_tb(
     );
    reg CLK;
    reg enable_motor;
    reg [1:0] turn_procedure;
    reg [3:0] RF_sensor;
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
    RF_sensor = 3;
    #1000
    RF_sensor = 0;
   // enable_motor = 1;
    #1000
    RF_sensor = 4;
    #1000
    RF_sensor = 0;
    #1000
    RF_sensor = 5;
    #1000
    RF_sensor = 0;
    #1000
    RF_sensor = 6;
    #1000
    RF_sensor = 0;
    #1000
    RF_sensor = 7;
    #1000
    RF_sensor = 8;
    #1000
    RF_sensor = 9;
    #1000
    RF_sensor = 10;
    #1000
    RF_sensor = 0;
    #1000
    RF_sensor = 11;
    #1000
    turn_procedure =2;
    RF_sensor = 12;
    #1000
    RF_sensor = 0;
    #1000
    RF_sensor = 13;
    //enable_motor = 0;
    #1000
    RF_sensor = 14;
    #1000
    RF_sensor = 0;
    #1000
    RF_sensor = 15;
    
    end
    
    always begin
    #5 CLK = ~CLK;
    end
    
    rover_sensors uut(
    .CLK(CLK),
    .enable_motor(enable_motor),
    .turn_procedure(turn_procedure),
    .RF_sensor(RF_sensor),
    .motorL(motorL),
    .motorR(motorR),
    .enableAB(enableAB),
    .done_turning(done_turning)
    //.turncount(turncount)
    );
    
endmodule
