`timescale 1ns / 1ps

module debounce(
    input CLK,
    input enable,
    input freq_counter_in,              //Signal from microphone
    output reg [1:0] job,               //Register that holds what command will be executed (1, 2, or 3)
    output reg [3:1] led_pick,          //Points to LED's
    output reg [8:0] posedge_counter,
    output reg [2:0] trueCount,
    output reg done
    );
    
    reg [24:0] clk_counter;             //Stores the number of clock pulses
  //  reg [8:0] posedge_counter;          //Counts the number of microphone pulses
    reg [8:0] prevFreq;                 //Register that holds what posedge_counter was
  //  reg [2:0] trueCount;                //Variable that increments every time the specificed signal has been confirmed
    reg last_state;
    
    
                                        //Frequency values are 1/5 of actual frequency since they are measured over 1/5 of a second
    localparam One = 100;               //500Hz
    localparam Two = 200;               //1000Hz
    localparam Three = 300;             //1500Hz
    
    localparam Invalid = 0;             //No frequency or invalid
    localparam AboutFace = 1;           //Instruction given for 500Hz
    localparam Bin = 2;                 //Instruction given for 1000Hz
    localparam GiveMeWasher = 3;        //Instruction given for 1500Hz
    
    localparam maximum = 'd20_000_000;  //number of pulses in 1/5th of a second
    
    initial {job,posedge_counter,clk_counter,prevFreq,trueCount,last_state,done} = 0;
    
    always @(posedge CLK)
    begin
        if(enable == 1)
            begin
            //Frequency must be counted 4 times
            if(trueCount < 4)
                begin
                if(clk_counter<maximum) 
                    begin
                    clk_counter <= clk_counter+1;
                    if(freq_counter_in == 1 && last_state == 0)
                        begin
                        posedge_counter = posedge_counter + 1;
                        last_state <= freq_counter_in;
                        end
                    end
                //Once 1/5th of a sec has passsed
                else    
                begin
                    //Check if frequency +/- 150 Hz
                    trueCount <= (prevFreq >= (posedge_counter - 30) && prevFreq <= (posedge_counter + 30)) ? (trueCount+1) : 0;
                        
                    //Reset variables
                    clk_counter = 0;
                    prevFreq <= posedge_counter;
                    posedge_counter <= 0;
                    last_state<=1;
                end
            end  
            //The same frequency counted 5 times, execute job
            else
            begin
                      job = (prevFreq > (One - 20) && prevFreq < (One + 20)) ? AboutFace :           //100Hz
                            (prevFreq > (Two - 30) && prevFreq < (Two + 30)) ? Bin :                   //150Hz
                            (prevFreq > (Three - 40) && prevFreq < (Three + 40)) ? GiveMeWasher :  //200Hz
                            Invalid;
                
                 led_pick = (job == AboutFace)       ? 3'b100:
                            (job == Bin)             ? 3'b010:
                            (job == GiveMeWasher)    ? 3'b001:
                            3'b000;
                                                      
                done <= 1;
            end
        end
        //If not enabled
        else 
        begin
            //Reset all variables
            {job,clk_counter,prevFreq,trueCount,posedge_counter,clk_counter,done} = 0;
        end
    end
endmodule