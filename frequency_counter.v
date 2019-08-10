//`timescale 1ns / 1ps

//module freq_counter(
//    input CLK,
//    input enable,
//    input in,
//    output reg [2:0] job,
//    output reg done_count
//    );
    
//    reg[25:0] clk_counter=26'b0;
    
//   reg[19:0] posedge_counter=20'b0;
    
//    reg last_state;
//    reg [2:0] trueCount;
//    reg [8:0] prevFreq; 
    
//    localparam Five = 125;              //500Hz
//    localparam Ten = 250;               //1000Hz
//    localparam Fifteen = 375;           //1500Hz
    
//    localparam Invalid = 0;             //No frequency or invalid
//    localparam AboutFace = 1;           //Instruction given for 500Hz
//    localparam Bin = 2;                 //Instruction given for 1000Hz
//    localparam GiveMeWasher = 3;        //Instruction given for 1500Hz
    
//    //-->100 mil/5
//    localparam maximum= 2_500_000;
    
//    initial begin
//        posedge_counter<=0;
//        clk_counter<=0;
//        done_count<=0;
//        prevFreq<=0;
//        trueCount<=0;
//        last_state<=0;
//    end
    
//   always @(posedge CLK) begin
//      last_state<=in;
//      if (enable==1) begin
//            if (trueCount<2) begin
//                if(clk_counter<maximum) begin
//                    clk_counter <= clk_counter+1;
//                    if(~last_state && in)
//                        posedge_counter<=posedge_counter+1; 
//                end    
                
//                if (clk_counter>=maximum) begin
//                    trueCount <= (prevFreq >= (posedge_counter - 25) && prevFreq <= (posedge_counter + 25)) ? (trueCount+1) : 0; 
//                    //reset the values
//                    clk_counter=0;
//                    prevFreq=posedge_counter;
//                    posedge_counter=0;
//                end
//            end        
//            else begin
//                job <= (prevFreq > (Five - 25) && prevFreq < (Five + 25)) ? AboutFace :           //500Hz
//                      (prevFreq > (Ten - 25) && prevFreq < (Ten + 25)) ? Bin :                   //1000Hz
//                      (prevFreq > (Fifteen - 50) && prevFreq < (Fifteen + 50)) ? GiveMeWasher :  //1500Hz
//                      Invalid;
//                done_count<=1; 
//            end 
//      end
//      else begin
//        posedge_counter<=0;
//        clk_counter<=0;
//        done_count<=0;
//        prevFreq<=0;
//        last_state<=0;
//      end  
//   end        
//endmodule

`timescale 1ns / 1ps

module freq_counter(
    input clk,
    input enable,
    input mic,
    output reg [1:0] frequency,
    output reg done_count
    );
    
    //Constants for comparison. Frequency values are 1/4 of actual frequency since they are measured over 1/4 of a second
    localparam Five = 125;       //500Hz
    localparam Ten = 250;        //1000Hz
    localparam Fifteen = 375;    //1500Hz
    
    //Instructions
    localparam Invalid = 0;      //No frequency or invalid
    localparam Turn180 = 1;      //Instruction given for 500Hz
    localparam StoreWasher = 2;  //Instruction given for 1000Hz
    localparam GoToSound = 3;    //Instruction given for 1500Hz
    
    localparam countMax = 25_000_000;  //number of pulses per quarter of a second
    
    reg currentMic; //Variable to track what the input to the Mic is
    reg oldMic;     //Variable to track what the previous input was
    reg [24:0] counter;     //Counter for the number of clock pulses per quarter second
    reg [8:0] freqCount;    //Counter for the number of periods
    reg [8:0] prevFreq;     //Register for the previous freqCount
    reg [1:0] trueCount;    //Counter for hearing the same frequency 4 times
    
    initial {frequency,currentMic,oldMic,counter,freqCount,prevFreq,trueCount, done_count} = 0;
    
    //Frequency counter
    always @(posedge clk)
    begin
        if(enable == 1)  //Run only if enabled
        begin
            //Make sure that the same frequency is counted at least 3 times
            if(trueCount < 3)
            begin
                //Every quarter of a second
                if(counter >= countMax)
                begin
                    //Check to see if the previous frequency is within about 100Hz of the current frequency
                    trueCount <= (prevFreq >= (freqCount - 25) && prevFreq <= (freqCount + 25)) ? trueCount + 1:0;
                    
                    //Reset variables for next iteration
                    counter=0;
                    prevFreq <= freqCount;
                    freqCount <= 0;
                end
                
                //Update the counter
                counter <= counter + 1;
                
                //Update frequency counter
                currentMic <= mic;   //Set current mic input
                if(currentMic == 1 && oldMic == 0) 
                begin
                    freqCount <= freqCount + 1;
                    oldMic <= currentMic;
                end
                
                else oldMic <= currentMic;
            end
            
            //The same frequency was counted 3 times, execute command
            else 
            begin
                frequency = (prevFreq > (Five - 25) && prevFreq < (Five + 25)) ? Turn180 :          //100Hz grace (25 * 4)
                            (prevFreq > (Ten - 25) && prevFreq < (Ten + 25)) ? StoreWasher :        //100Hz grace (25 * 4)
                            (prevFreq > (Fifteen - 50) && prevFreq < (Fifteen + 50)) ? GoToSound :  //200Hz grace (50 * 4)
                            Invalid;
                done_count<=1;            
              
            end
        end
        
        //Reset all variables
        else {frequency,currentMic,oldMic,counter,freqCount,prevFreq,trueCount,done_count} = 0;
    end
endmodule


