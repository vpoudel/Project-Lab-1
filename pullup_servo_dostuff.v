`timescale 1ns / 1ps

module pullup_servo_dostuff(
    input CLK,
    input enable,
    input done_period,
    input [1:0] pullup_procedure,
    output [20:0] to_pwm,
    output reg done_up,
    output reg done_down
   // output reg reset_magnet
    );
    
    
    reg [7:0] angle_count;
    
    parameter interval_change=1;
   // parameter fast_interval_change=2;
    parameter max=8'd180;
    parameter min=8'd80;
//    parameter middle=8'd90;
    
    assign to_pwm=(12'd1111)*angle_count+18'd50_000;
     
    //initializing angle and stuffs
    initial begin
        angle_count<=max;
        done_up<=0;
        done_down<=0;
    end
    
    
    always @(posedge CLK) begin
        if(enable==1)begin
            if(pullup_procedure==1) begin //go up procdedure
                if (done_period) begin
                    if (angle_count>min) begin
                        angle_count<=angle_count-interval_change;
                    end
                end
                if (angle_count==min) begin
                    angle_count<=min;
                    done_up<=1;
                end
            end
            
            if(pullup_procedure==2) begin //go down procdedure
                if (done_period) begin
                    if (angle_count<max) begin
                        angle_count<=angle_count+interval_change;
                    end
                end
                if (angle_count==max) begin
                    angle_count<=max;
                    done_down=1;
                end
            end                
        end   
        else begin
         {done_up,done_down}=0;
         angle_count=max;
       end
         
    end    
                            
endmodule
