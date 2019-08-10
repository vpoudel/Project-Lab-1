`timescale 1ns / 1ps

module state_machine(
    input CLK,
    input reset,
    input IPS_detect,
    input done_magnet_servo,
    input done_up,
    input done_down,
    input done_back,
    input done_front,
    input done_count,
    input done_turning,
    input done_turning90,
    input [2:0] job,
    output reg enable_motor,
    output reg enable_magnet_servo,
    output reg start_magnet,
    output reg [1:0] scanning,
    output reg enable_pullup_servo,
    output reg [2:0] pullup_procedure,
    output reg enable_count,
     output reg enable_frontback,
    output reg [2:0] go_back,
    output reg [2:0] turn_procedure,
    output reg [3:0] state  
    );

    initial begin
        enable_motor <= 0;
        enable_magnet_servo <= 0;
        start_magnet <= 0;
        scanning <= 0;
        enable_pullup_servo <= 0;
        pullup_procedure <= 0;
        enable_count<=0;
        enable_frontback<=0;
        go_back<=0;
        turn_procedure<=0;
        state <= 0;
    end
    
    parameter start=0,
              pickup=1,
              get_freq=2,
              AboutFace=3,
              Bin=4,
              GiveMeWasher=5;
    
    
        always @(posedge CLK) begin
        if(reset) begin
            enable_motor<=0;
            turn_procedure<=0;
            enable_magnet_servo<=0;
            scanning<=0;
            enable_pullup_servo<=0;
            enable_frontback<=0;
            enable_count<=0;
        end
        else        
            case(state)
            start: begin
                        enable_motor<=1;
                        turn_procedure<=1;
                        enable_magnet_servo<=1;
                        scanning<=1;
                    if (IPS_detect==1)
                        state<=pickup;
                    end    

            pickup: begin
                        enable_motor<=0;
                        start_magnet<=1;
                        scanning<=2; //stop scanning and begin lift process
                        if (done_magnet_servo==1)
                        state<=get_freq;
                    end  
                    
            get_freq:begin
                        enable_count<=1;
                        if (done_count==1) begin
                            if(job==1) state<=AboutFace;
                            if (job==2) state<=Bin;
                            if (job==3) state<=GiveMeWasher;
                        end
                    end
                    
            AboutFace:begin
                          enable_count<=0;
                          start_magnet<=0;
                          enable_motor<=1;
                          turn_procedure<=3;
                          if (done_turning==1) begin
                           // enable_motor<=0;
                            state<=start;
                          end  
                      end   
                      
            Bin:    begin
                        enable_count<=0;
                        enable_pullup_servo<=1;
                        pullup_procedure<=1;
                        if (done_up==1)
                            enable_frontback<=1;
                            go_back<=1;
                            if(done_front==1) begin
                                start_magnet<=0;
                                go_back<=2;
                                if(done_back==1) pullup_procedure<=2;
                                    if(done_down==1)begin 
                                        enable_frontback<=0;
                                        enable_pullup_servo<=0;
                                        enable_magnet_servo<=0;
                                        state<=start;
                                    end    
                            end  
                    end        
                          
            GiveMeWasher: begin                
                            enable_count<=0;
                            enable_motor<=1;
                            turn_procedure<=2;
                            if (done_turning90==1) begin
                                start_magnet<=0;
                                enable_motor<=0;
                                state<=start;
                            end  
                          end         
                            
            default: state<='bx;    
            endcase    
        end
endmodule