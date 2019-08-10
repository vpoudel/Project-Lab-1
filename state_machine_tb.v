`timescale 1ns / 1ps

module state_machine_tb();
    reg CLK, reset,IPS_detect,done_magnet_servo,done_up,done_down,done_back,done_front,
    done_count,done_turning,done_turning90;
    reg [2:0] job ;
    wire enable_motor,enable_magnet_servo,start_magnet,enable_pullup_servo,enable_count,enable_frontback;
    wire [1:0] scanning;
    wire [2:0]pullup_procedure;
    wire [2:0] turn_procedure;
    wire [3:0] state;
    wire [2:0]go_back;

    initial fork
        {CLK, reset,IPS_detect,done_magnet_servo,done_up,
        done_down,done_back,done_front,done_count,done_turning} <= 0;
       
        //for freq=500
        #20 IPS_detect<=1;
        #40 IPS_detect<=0;
        #60 done_magnet_servo<=1;  
        #80 done_count<=1; 
        #81 job<=1;
        #100 done_turning<=1;     

        //for freq=1000
        #110 done_turning<=0;
        #110 job<=0;
        #110 done_count<=0;
        #110 done_magnet_servo<=0;
        #140 IPS_detect<=1;
        #160 IPS_detect<=0;
        #180 done_magnet_servo<=1;  
        #200 done_count<=1; 
        #201 job<=2;
        #220 done_up<=1;
        #240 done_front<=1;
        #260 done_back<=1;
        #280 done_down<=1;
        #300 reset<=1;
        #340 reset<=0;
    join
    
    
    always #5 CLK<=~CLK;

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
        .start_magnet(start_magnet),   //reg to enable magnet
        .enable_pullup_servo(enable_pullup_servo),  //reg to enable pullup servo
        .enable_count(enable_count),    //reg to enable frequency count
        .enable_frontback(enable_frontback),    //reg to enable rack and pinion
        .scanning(scanning),    //reg to specify scanning procedure
        .pullup_procedure(pullup_procedure),    //reg to specify pull up or down
        .go_back(go_back),  //reg to specify go back or front
        .turn_procedure(turn_procedure),    //turn procedure for motot\r
        .state(state)    //leds to states active
        );
endmodule
