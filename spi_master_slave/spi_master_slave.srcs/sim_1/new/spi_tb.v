
`timescale 1ns/1ps

module spi_tb();

    parameter CLK_PERIOD = 2; 


    reg clk = 0;
    reg rst, rst_s ;
    reg start_tx = 0;
    reg [11:0] data = 12'b110010101010;
    
    
    spi_top s1 (
        .clk(clk), 
        .d_in(data), 
        .new_data(start_tx), 
        .rst(rst),
        . rst_s(rst_s),  
        .done(done), 
        .d_out(d_out)
    );


    always #(CLK_PERIOD/2) clk = ~clk;
    
    // Stimulus
    initial begin
       
        #10 rst = 1;
        repeat(2) @(posedge clk);
        rst = 0;
        repeat(5) @(posedge clk);
        
        rst_s = 1;
        repeat(10) @(posedge clk);
        rst_s = 0;       
        
        
        // Start data transmission
         repeat(2)@(posedge clk) start_tx = 1;
         
         repeat(200)@(posedge clk);
        
        //#60 start_tx = 0;
        
        // Wait for transmission to complete
        #1000000;
        
        // End simulation
        $finish;
    end



endmodule
