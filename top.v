`timescale 1ns / 1ps

module top(
    input CLK,
    input reset,
    input freq_counter_in,
    input IPS_to_basys,
    output magnet_on,
    input [3:0] RF_sensor,
    output magnet_servo_out,
    output pullup_servo_out,
    output frontback_out,
    output [2:0] led,
    output [1:0] enableAB,
    output [1:0] motorL,
    output [1:0] motorR
    //output [2:0] job
    );
    
         
    //wires for state machine
     wire IPS_detect;
     wire done_magnet_servo, done_up, done_down, done_back, done_front, done_count, done_turning, done_turning90;
     wire enable_motor, enable_magnet_servo, enable_magnet, enable_pullup_servo, enable_count, enable_frontback ;
     wire [1:0] scanning;
     wire [1:0] pullup_procedure; 
     wire [1:0] go_back;
     wire [2:0] turn_procedure;
     wire [2:0] job;
     //state machine
     state_machine u0(
        .CLK(CLK),  //clock
        .reset(reset),  //reset button
        .IPS_detect(IPS_detect),    //when washer detected
        .done_magnet_servo(done_magnet_servo),  //done flag from magnet_servo
        .done_up(done_up),  //done flag from pulling up
        .done_down(done_down),  //done flag from pulling down
        .done_back(done_back),  //done flag from taking back washer
        .done_front(done_front), // done flag from taking washer front
        .done_count(done_count),    //done flag from frequency counter
        .done_turning(done_turning),    //done flag from turning rover
        .done_turning90(done_turning90),
        .job(job),  //specific job from frequency counter
        .enable_motor(enable_motor),    //reg to enable motor
        .enable_magnet_servo(enable_magnet_servo),  //reg to enable magnet servo
        .start_magnet(enable_magnet),   //reg to enable magnet
        .enable_pullup_servo(enable_pullup_servo),  //reg to enable pullup servo
        .enable_count(enable_count),    //reg to enable frequency count
        .enable_frontback(enable_frontback),    //reg to enable rack and pinion
        .scanning(scanning),    //reg to specify scanning procedure
        .pullup_procedure(pullup_procedure),    //reg to specify pull up or down
        .go_back(go_back),  //reg to specify go back or front
        .turn_procedure(turn_procedure),    //turn procedure for motot\r
        .state(led[2:0])    //leds to states active
        );
                          
     IPS u1( //Inductive Proximity Sensor
        .IPS_to_basys(IPS_to_basys),
        .IPS_detect(IPS_detect)
        );
        
    //elctromagnet
    electromagnet u2(
        .start_magnet(enable_magnet),
        .magnet_on(magnet_on)
        );
        
    //servo with magent   
    magnet_servo_main u3(
        .CLK(CLK),
        .enable(enable_magnet_servo),
        .scanning(scanning),
        .magnet_servo_out(magnet_servo_out),
        .done(done_magnet_servo)
    );
    
    //servo to pull up washer
    pullup_servo_main u4(
        .CLK(CLK),
        .enable(enable_pullup_servo),
        .pullup_procedure(pullup_procedure),
        .pullup_servo_out(pullup_servo_out),
        .done_up(done_up),
        .done_down(done_down)
        );
        
    //servo with rack and pinion
    frontback_servo_main u5(
        .CLK(CLK),
        .enable(enable_frontback),
        .go_back(go_back),
        .servo_out(frontback_out),
        .done_back(done_back),
        .done_front(done_front)
    );
    
    //sensor logic and turn
    rover_sensors u7(
        .CLK(CLK),
        .enable_motor(enable_motor),
        .turn_procedure(turn_procedure),
        .RF_sensor(RF_sensor),
        .motorL(motorL),
        .motorR(motorR),
        .enableAB(enableAB),
        .done_turning(done_turning),
        .done_turning90(done_turning90)
        );
   
   //frequency counter module
    frequency u8(
    .clk(CLK),
    .enable(enable_count),
    .mic(freq_counter_in),
    .done_count(done_count),
    .command(job)
    );

              
endmodule
