`timescale 1ns / 1ps

module rover_sensors(
    input CLK,
    input enable_motor,
    input [2:0] turn_procedure,
    input [3:0] RF_sensor,
    output reg [1:0] motorL,
    output reg [1:0] motorR,
    output reg [1:0] enableAB,
    output reg done_turning,
    output reg done_turning90
    //output reg PWM,
    //output reg PWM45
    //reg [19:0] width,
);

reg state_forward;
reg state_reverse;
reg state_turnL;
reg state_turnR;
reg state_brake;
reg PWM;
reg PWM45;
reg PWMf1;
reg PWMf2;
//reg PWM50;
reg [19:0] counter;
reg [29:0] turncount;
parameter max = 1_000_000; 
parameter oneeightydeg = 200_000_000;
parameter ninetydeg = 100_000_000;

wire [1:0] a0 = 0; //2'b00;
wire [1:0] a1; //2'b01;
wire [1:0] a2;  //2'b10;
wire [1:0] a3; //2'b11;

wire [1:0] a4; // a1 with 45%
wire [1:0] a5; // a2 with 45%

wire [1:0] a6;
wire [1:0] a7;



//assign a1 = {0, PWM};

   
initial begin
    motorL <= 0;
    motorR <= 0;
    counter <= 0;
    turncount <= 0;
    done_turning <= 0;
    done_turning90 <= 0;
    enableAB<=0;
    PWM<=0;
    PWM45<=0;
    //PWM50<=0;
end

assign a0 = {1'b0, 1'b0};
assign a1 = {1'b0, PWM};
assign a2 = {PWM, 1'b0};
assign a3 = {PWM, PWM};

assign a6 = {1'b0, PWMf2};
assign a7 = {PWMf1, 1'b0};

assign a4 = {1'b0, PWM45}; // a1 with 45%
assign a5 = {PWM45, 1'b0}; // a2 with 45%

always@(posedge CLK)               // This block creates the counter
    begin                           // and defines the PWM
    
        if (counter > max)
            counter <= 0;
        else
            counter <= counter + 1;   
        
        if (counter < 800000)
            PWM <= 1;               // Signal outputs 1 before reaching desired width
        else
            PWM <= 0;               // Signal outputs 0 after reaching desired width     
            
        if (counter < 600000)
            PWM45 <= 1;
        else
            PWM45 <= 0;
            
        if (counter < 500000)
            PWMf1 <= 1;               
        else
            PWMf1 <= 0; 
            
        if (counter < 375000)
            PWMf2 <= 1;
        else
            PWMf2 <= 0;
 end

always @ (posedge CLK)
    begin
    //counter <= counter + 1;
    
    if(RF_sensor == 0) // 0000 No sensors active
       begin
       state_forward <= 1;
       state_reverse <= 0;
       state_turnL   <= 0;
       state_turnR   <= 0;
       state_brake   <= 0;
    end
    
    else if(RF_sensor == 1) // 0001 Right sensor active
       begin
       state_forward <= 0;
       state_reverse <= 0;
       state_turnL   <= 1;
       state_turnR   <= 0;
       state_brake   <= 0;
    end
    
    else if(RF_sensor == 2) // 0010 Back sensor active
       begin
       state_forward <= 1;
       state_reverse <= 0;
       state_turnL   <= 0;
       state_turnR   <= 0;
       state_brake   <= 0;
    end
    
    else if(RF_sensor == 3) // 0011 Back and Right sensors active
       begin
       state_forward <= 0;
       state_reverse <= 0;
       state_turnL   <= 1;
       state_turnR   <= 0;
       state_brake   <= 0;
    end
     
    else if(RF_sensor == 4) // 0100 Front sensor active
       begin
       state_forward <= 0;
       state_reverse <= 0;
       state_turnL   <= 0;
       state_turnR   <= 1;
       state_brake   <= 0;
    end
    
    else if(RF_sensor == 5) // 0101 Front and Right sensors active
       begin
       state_forward <= 0;
       state_reverse <= 0;
       state_turnL   <= 1;
       state_turnR   <= 0;
       state_brake   <= 0;
    end
    
    else if(RF_sensor == 6) // 0110 Front and Back sensors active
       begin
       state_forward <= 0;
       state_reverse <= 0;
       state_turnL   <= 0;
       state_turnR   <= 1;
       state_brake   <= 0;
    end
    
    else if(RF_sensor == 7) // 0111 Front and Back and Right sensors active
       begin
       state_forward <= 0;
       state_reverse <= 0;
       state_turnL   <= 1;
       state_turnR   <= 0;
       state_brake   <= 0;
    end
    
    else if(RF_sensor == 8) // 1000 Left sensor active
       begin
       state_forward <= 0;
       state_reverse <= 0;
       state_turnL   <= 0;
       state_turnR   <= 1;
       state_brake   <= 0;
    end
    
    else if(RF_sensor == 9) // 1001 Left and Right sensors active
       begin
       state_forward <= 1;
       state_reverse <= 0;
       state_turnL   <= 0;
       state_turnR   <= 0;
       state_brake   <= 0;
    end
    
    else if(RF_sensor == 10) // 1010 Left and Back sensors active
       begin
       state_forward <= 0;
       state_reverse <= 0;
       state_turnL   <= 0;
       state_turnR   <= 1;
       state_brake   <= 0;
    end
    
    else if(RF_sensor == 11) // 1011 Left and Back and Right sensors active
       begin
       state_forward <= 1;
       state_reverse <= 0;
       state_turnL   <= 0;
       state_turnR   <= 0;
       state_brake   <= 0;
    end
    
    else if(RF_sensor == 12) // 1100 Left and Front sensors active
       begin
       state_forward <= 0;
       state_reverse <= 0;
       state_turnL   <= 0;
       state_turnR   <= 1;
       state_brake   <= 0;
    end
    
    else if(RF_sensor == 13) // 1101 Left and Front and Right sensors active
       begin
       state_forward <= 0;
       state_reverse <= 0;
       state_turnL   <= 0;
       state_turnR   <= 1;
       state_brake   <= 0;
    end
    
    else if(RF_sensor == 14) // 1110 Left and Front and Back sensors active
       begin
       state_forward <= 0;
       state_reverse <= 0;
       state_turnL   <= 0;
       state_turnR   <= 1;
       state_brake   <= 0;
    end
    
    else if(RF_sensor == 15) // 1111 All sensors active
       begin                 //Brake and pray no one hits us
       state_forward <= 0;
       state_reverse <= 0;
       state_turnL   <= 0;
       state_turnR   <= 0;
       state_brake   <= 1;
    end
end

always @ (posedge CLK)
begin
    if (enable_motor==1) begin
            enableAB <= 2'b11;
        if (turn_procedure==1) begin        
            if (state_brake == 1) begin//brake
                motorL <= a0; motorR <= a0;
            end
            else if (state_forward == 1) begin //forward
                motorL <= a7; motorR <= a6;
            end
            else if (state_reverse == 1) begin//reverse
                motorL <= a1; motorR <= a5;
            end
            else if (state_turnL == 1)begin //turn left
                motorL <= a1; motorR <= a4;
            end
            else if (state_turnR == 1) begin //turn right
                motorL <= a2; motorR <= a5;
            end
        end 
        
        else if(turn_procedure == 2) begin// Turn right 90
            turncount <= 0;
            motorL <= a2;
            motorR <= a5;
            if(turncount > ninetydeg)begin
                turncount <= 0;
                {motorL,motorR}<=2'b0;
                done_turning90 <= 1;
            end
            else
                turncount <= turncount + 1;
        end
        
        else if(turn_procedure == 3) begin // Turn right 180
            turncount <= 0;
            motorL <= a2;
            motorR <= a5;           
            if(turncount > oneeightydeg) begin
                turncount <= 0;
                {motorL,motorR}<=2'b0;
                done_turning <= 1;
            end 
            else
                turncount <= turncount + 1;
        end
        
//        else begin
//            {motorL,motorR,enableAB}<=2'b0; done_turning<=0;
//        end
    end
    else begin
            {motorL, motorR, enableAB, done_turning,done_turning90, turncount}<=0;
    end  
end

endmodule

