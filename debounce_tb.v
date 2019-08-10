`timescale 1ns / 1ps

module debounce_tb();

reg CLK;
wire [2:0] job;
//wire [3:1] led_pick;
reg enable;
reg freq_counter_in;
wire done;
//wire [19:0] posedge_counter;
//wire [2:0] trueCount;

initial begin
        CLK <= 0;
        enable<=1;
        freq_counter_in <= 0;
    end
    

always #(1e+7) freq_counter_in = ~freq_counter_in;
always #5 CLK=~CLK;

    
freq_counter test(
    .CLK(CLK),
    .enable(enable),
    .in(freq_counter_in),
    .job(job),
    .done_count(done)
);
       
endmodule