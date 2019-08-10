`timescale 1ns / 1ps

module frontback_tb();
    reg CLK;
    wire done_period;
    reg [1:0] go_back;
    wire [20:0]to_pwm;
    wire done_back,done_front;
    reg enable;
    wire servo_out;

    initial fork
        CLK<=0;
        go_back<=1;
        enable<=1;
       #(5e+8) go_back<=2;
       #(1e+9) enable<=0;
       #(1.1e+9) enable<=0;
    join
    
    always #5 CLK<=~CLK;
    
    frontback_servo_dostuff u0(
        .CLK(CLK),
        .enable(enable),
        .go_back(go_back),
        .done_period(done_period),
        .to_pwm(to_pwm),
        .done_back(done_back),
        .done_front(done_front)
        );
     pwm #(21,2_000_000) u1(
        .CLK(CLK),
        .duty(to_pwm),
        .done(done_period),
        .pwm_out(servo_out)
        );    
endmodule
