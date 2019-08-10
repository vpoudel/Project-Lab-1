`timescale 1ns / 1ps

module magnet_servo_main(
    input CLK,
    input enable,
    input [1:0] scanning,
    output magnet_servo_out,
    output done
    );
    
    wire [20:0] to_pwm;
   // wire [7:0] angle;
    wire done_period;
    
    magnet_servo_dostuff u0(
        .CLK(CLK),
        .enable(enable),
        .done_period(done_period),
        .scanning(scanning),
        .to_pwm(to_pwm),
        .done(done)
        );
        
    pwm #(21,1_000_000) u1(
        .CLK(CLK),
        .duty(to_pwm),
        .done(done_period),
        .pwm_out(magnet_servo_out)
        );   
     
endmodule
