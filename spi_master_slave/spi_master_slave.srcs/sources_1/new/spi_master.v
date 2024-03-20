`timescale 1ns/1ps
module spi_master(clk, rst,rst_s, new_data, d_in, cs, mosi, sclk
);

input clk, new_data, rst, rst_s;
input [11:0] d_in;
output reg sclk, mosi, cs;

//Registers
reg [3:0] count_clk;
reg [3:0] count_bit;
reg [1:0] present_state;
reg [1:0] next_state;
reg [11:0] temp;
//parameters  for FSM

parameter IDLE = 2'b00;
parameter ENABLE = 2'b01;
//parameter TX = 2'b10;
//parameter DONE = 2'b11;

//Generation of a clk

always @ (posedge clk) begin

    if (rst) begin
        count_clk <= 1'b0;
        sclk <= 1'b0;
    end
    
    else begin 
        if (count_clk<2) begin
            count_clk <= count_clk +1'b1;
               
        end
        else begin
            count_clk <= 'd0;
            sclk <= ~sclk;
        end
    end
    
    /*
    if (count_clk < 10) begin
        count_clk = count_clk + 1'b1;        
    end
    else begin
        sclk = ~sclk;
    end
*/
end

//Starting the FSM

always @(posedge sclk) begin
    if (rst_s) begin//changed this for now
        present_state <= IDLE;
  
    end
    else begin
        present_state <= next_state;
        
    end
end
//Main FSM for the Transmission of the data

always @(*) begin
            cs = 1'b1;  
        mosi = 1'b0;
        count_bit = 4'd0; 
    case (present_state)
        IDLE: begin
            if (new_data == 1'b1)begin
                temp = d_in;
                cs= 1'b0;
                next_state= ENABLE;
            end
            else begin
                temp = 'd0;
                next_state = IDLE;
            end
        end
        ENABLE: begin
            if (count_bit < 4'd12) begin
                mosi = temp[count_bit];
                count_bit = count_bit + 1'b1;
                //next_state= ENABLE;
            end
           
            else begin
                count_bit = 'b0;
                mosi = 1'b0;
                next_state = IDLE;
                cs = 1'b1;
            end
        end
//        TX: begin
        
//        end
//        DONE: begin
        
//        end
    endcase
end
    



endmodule
