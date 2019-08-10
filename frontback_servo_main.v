`timescale 1ns / 1ps

module frontback_servo_main(
    input CLK,
    input enable,
    input [1:0] go_back,
    output servo_out,
    output done_back,
    output done_front
    );
    
    wire done_period;
    wire [20:0] to_pwm;
    
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
