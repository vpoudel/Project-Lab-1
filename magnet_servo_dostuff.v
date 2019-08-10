`timescale 1ns / 1ps

module magnet_servo_dostuff(
    input CLK,
    input enable,
    input done_period,
    input [1:0] scanning,
    output [20:0] to_pwm,
    output reg done
    );
    
    reg [7:0] angle_count;
    reg go_reverse;
    //reg end_cycle;
    reg to_max;
    reg to_middle;
    
    parameter interval_change=1;
    //parameter interval_change=10;   //for test bench
    parameter max=8'd120;
    parameter max1=8'd130;
    parameter min=8'd60;
    parameter min1=8'd50;
    parameter middle = 8'd90;
    
   assign to_pwm=(12'd1111)*angle_count+18'd50_000;
    
    //initializing
    initial begin
        go_reverse<=0;
        angle_count<=middle;
       // end_cycle<=0;
        to_max<=0;
        to_middle<=0;
        done<=0;
    end

    
    always @ (posedge CLK) begin  
        if (enable==1)begin  
            if(scanning==1) begin
                if (done_period) begin
                    if(angle_count<max && go_reverse==0) begin//counter less than max
                        angle_count<=angle_count+interval_change;
                    end
                    else if(angle_count>min && go_reverse==1) begin //reverse motion
                        angle_count<=angle_count-interval_change;
                    end
                end   
                 
                if (angle_count <= min)begin              
                    go_reverse <= 0; //do not count in reverse
                end
                else if (angle_count >= max) begin
                    go_reverse <= 1; //count in reverse
                end                
            end    
                
            else if(scanning==2) begin
                if (done_period) begin
                    if(angle_count>min1 && to_max == 0 && to_middle == 0) begin
                        angle_count<=angle_count-interval_change;
                    end      
                    else if(angle_count<max1 && to_max == 1 && to_middle == 0) begin
                        angle_count<=angle_count+interval_change;
                    end
                    else if(angle_count>middle && to_max==1 && to_middle==1) begin
                        angle_count<=angle_count-interval_change;
                    end     
                end    
                
                if(angle_count==min1) begin
                    to_max<= 1;
                end            
                else if(angle_count==max1 && to_max==1) begin
                    to_middle <= 1;
                end                                         
                else if(angle_count==middle && to_max==1 && to_middle==1) begin
                    angle_count<=middle;
                    done<=1;   
                end                 
            end      
        end    
        else begin
            {done, go_reverse, to_max, to_middle}<=0;
            angle_count<=middle;
        end              
    end       
endmodule