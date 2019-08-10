`timescale 1ns / 1ps

module magnet_tb();
    reg start_magnet;
    reg CLK;
    wire magnet_on;
    
    electromagnet uut(
        .start_magnet(start_magnet),
        .CLK(CLK),
        .magnet_on(magnet_on)
        );

    initial begin
        start_magnet=0;
        #100 start_magnet=1;
        CLK=0;
    end
    
    always #5 CLK=~CLK;

endmodule
