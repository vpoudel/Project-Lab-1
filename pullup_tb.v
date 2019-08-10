`timescale 1ns / 1ps

module pullup_tb();
    reg CLK,enable;
    reg [1:0] pullup_procedure;
    wire done_period, done_up, done_down, servo_out;
    wire [20:0] to_pwm;
    
    initial begin
        CLK<=0;
        enable<=1;
        pullup_procedure<=1;
        #(5e+8) pullup_procedure<=2;
    end
    
    always #5 CLK<=~CLK;
   
    pullup_servo_dostuff u0(
        .CLK(CLK),
        .done_period(done_period),
        .enable(enable),
        .pullup_procedure(pullup_procedure),
        .to_pwm(to_pwm),
        .done_up(done_up),
        .done_down(done_down)
        );

     pwm #(21,2_000_000) u1(
        .CLK(CLK),
        .duty(to_pwm),
        .done(done_period),
        .pwm_out(servo_out)
        );   
   
    
endmodule
