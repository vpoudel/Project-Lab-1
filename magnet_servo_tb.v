`timescale 1ns / 1ps

module magnet_servo_tb();
    reg CLK;
    reg enable;
    wire done_period;
    reg [1:0] scanning;
    wire [20:0]to_pwm;
    wire servo_out;
    wire done;
    
    initial begin
        CLK <= 0;
        enable <= 1;
        scanning <= 1;
        #(5e+8) scanning<=2;
        end  
    
    always #5 CLK = ~CLK; 
            
   magnet_servo_dostuff u0(
        .CLK(CLK),
        .enable(enable),
        .done_period(done_period),
        .scanning(scanning),
        .to_pwm(to_pwm),
        .done(done)
        );
        
        pwm #(21,2_000_000) u1(
        .CLK(CLK),
        .duty(to_pwm),
        .done(done_period),
        .pwm_out(servo_out)
        );   
        
      
endmodule
