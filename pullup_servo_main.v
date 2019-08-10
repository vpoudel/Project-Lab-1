`timescale 1ns / 1ps


module pullup_servo_main(
    input CLK,
    input enable,
    input [1:0] pullup_procedure,
    output pullup_servo_out,
    output done_up,
    output done_down
   // output reset_magnet
    );
    
    wire done_period;
    wire [7:0] angle;
    wire [20:0] to_pwm;
    
    pullup_servo_dostuff u0(
        .CLK(CLK),
        .enable(enable),
        .pullup_procedure(pullup_procedure),
        .done_period(done_period),
        .to_pwm(to_pwm),
        .done_up(done_up),
        .done_down(done_down)
        //.reset_magnet(reset_magnet)
        );
    pwm #(21,2_000_000) u1(
        .CLK(CLK),
        .duty(to_pwm),
        .done(done_period),
        .pwm_out(pullup_servo_out)
        );   
   
endmodule