`timescale 1ns / 1ps

module turn_procedure(
    input CLK,
    input enable,
    input [1:0] turn_procedure,
    output reg [1:0] motorL,
    output reg [1:0] motorR,
    output reg [1:0] enableAB,
    output reg done_turning
    );

    reg PWM50;
    reg [19:0] counter;
    reg [29:0] turncount;
    parameter max = 1_000_000;
    parameter oneeightydeg = 1_000_000_000;
    parameter ninetydeg = 500_000_000;

    wire [1:0] a0 = 0; //2'b00;
    wire [1:0] a1; //2'b01;
    wire [1:0] a2;  //2'b10;
    wire [1:0] a3; //2'b11;

    initial begin
    motorL <= 0;
    motorR <= 0;
    counter <= 0;
    turncount <= 0;
    done_turning <= 0;
    end

    assign a0 = {1'b0, 1'b0};
    assign a1 = {1'b0, PWM50};
    assign a2 = {PWM50, 1'b0};
    assign a3 = {PWM50, PWM50};

    always@(posedge CLK)               // This block creates the counter
        begin                           // and defines the PWM
        if (counter > max)
            counter <= 0;
        else
            counter <= counter + 1;

        if (counter < 500000)
            PWM50 <= 1;               // Signal outputs 1 before reaching desired width
        else
            PWM50 <= 0;               // Signal outputs 0 after reaching desired width
        end

   always @(posedge CLK) begin
        if (enable==1) begin
            if(turn_procedure == 1) // Turn left 90
            begin
                turncount <= 0;
                motorL <= a1;
                motorR <= a2;
                if(turncount > ninetydeg) begin
                    turncount <= 0;
                    done_turning <= 1;
                end
                else
                    turncount <= turncount + 1;
            end
             else if(turn_procedure == 2) // Turn right 90
             begin
                turncount <= 0;
                motorL <= a2;
                motorR <= a1;
                if(turncount > ninetydeg)begin
                    turncount <= 0;
                    done_turning <= 1;
             end
                else
                    turncount <= turncount + 1;
                end
              else if(turn_procedure == 3) // Turn right 180
              begin
                turncount <= 0;
                motorL <= a2;
                motorR <= a1;           
                if(turncount > oneeightydeg) begin
                    turncount <= 0;
                    done_turning <= 1;
                end 
                else
                    turncount <= turncount + 1;
              end
        end
        else begin
            done_turning=0;
            {motorL,motorR,enableAB}<=2'bz;
        end
   end
   
endmodule

