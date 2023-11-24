`timescale 1ns/1ps
module spi_top( clk, d_in, new_data, rst, rst_s, done, d_out
);

input clk, new_data, rst, rst_s;
input [11:0] d_in;
output done;
output [11:0] d_out;

spi_master m1(
   . clk(clk), 
   . rst(rst),
   . rst_s(rst_s), 
   . new_data(new_data), 
   . d_in(d_in), 
   . cs(cs), 
   . mosi(mosi), 
   . sclk(sclk)
);

spi_slave s1(
.cs(cs), 
.mosi(mosi), 
.sclk(sclk), 
.d_out(d_out), 
.done(done)
);

endmodule

