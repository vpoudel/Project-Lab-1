`timescale 1ns / 1ps

module frontback_servo_dostuff(
    input CLK,
    input enable,
    input [1:0] go_back,
    input done_period,
    output [20:0] to_pwm,
    output reg done_back,
    output reg done_front
    );
   

    reg go_reverse;
    reg [7:0] angle_count;
    //parameter interval_change=1;
    parameter interval_change=10;     //for test bench
    parameter max=10'd90;
    parameter min=8'd0;
    
    assign to_pwm=(12'd1111)*angle_count+18'd50_000;
     
    //initializing angle and stuffs
    initial begin
        angle_count<=min;
        done_back<=0;
        done_front<=0;
        go_reverse<=0;
    end
    
    always @(posedge CLK) begin
    if (enable==1)begin        
        if (go_back==1) begin
            if (done_period) begin      
                if (angle_count<max)begin              
                    angle_count<=angle_count+interval_change;
                end
            end    
            if (angle_count==max) begin
                angle_count<=max; 
                done_front<=1;
            end  
        end    
                            
        else if (go_back==2) begin 
            if (done_period) begin      
                if (angle_count>min)begin              
                    angle_count<=angle_count-interval_change;
                end
            end    
            if (angle_count==min) begin
                angle_count<=min; 
                done_back<=1;
            end                
        end 
    end
    else begin
     {done_back,done_front}<=0; angle_count<=min;
    end
    end                
endmodule
