`timescale 1ns / 1ps

//Top module for frequency response. When a washer is detected, activate this module. This module activates
//  the microphones to listen for a sound. It counts the number of periods in a quarter of a second 8 times.
//  If the frequency is about the same all 8 times, then it will issue a command based on that frequency.
//  If the frequency is 500 or 1000Hz, the microphones disable and the rover follows a movement command.
//  If the frequency is 1500Hz, the command to start the FreqResponse_FindSound module is returned and the Mic
//  will stay on.

module frequency(
    input clk,
    input enable,
    input mic,
    //output led,
   // output led2,
    output reg [2:0] command,
    output done_count
    );
    
   // assign led = enable;
    
   // assign led2 = ~(command[0] || command[1] || command[2]);
    
    //module variables
    localparam NotEnabled   = 3'b000;   //No frequency or invalid frequency
    localparam Turn180      = 3'b001;   //500Hz command
    localparam StoreWasher  = 3'b010;   //1000Hz command
    localparam GoToSound    = 3'b100;   //1500Hz command
    
    wire [1:0] frequency;   //The sound frequency value returned from WaveCount
    //wire done;               //Flag for when counting the waves finishes
    
    initial command = 0;    //No command
    
    //Instantiate the wave counter to get frequency only when mics are enabled
    freq_counter u0(
        .clk(clk),
        .enable(enable),
        .mic(mic),
        .frequency(frequency),
        .done_count(done_count)
    );
    
    //When the module is enabled (a washer is found) then use the frequency found by wave and
    //give a command based on that
    always @(posedge clk)
    begin
        if(enable == 1)
        begin
//            if(done == 1)
            command = (frequency == 0) ? NotEnabled:            //No frequency or invalid frequency
                      (frequency == 1) ? Turn180:               //500Hz
                      (frequency == 2) ? StoreWasher:           //1000Hz
                      (frequency == 3) ? GoToSound: NotEnabled; //1500Hz otherwise stay disabled
        end
        
        //Reset variables when disabled
        else 
        begin
            command <= NotEnabled;
        end
    end
endmodule