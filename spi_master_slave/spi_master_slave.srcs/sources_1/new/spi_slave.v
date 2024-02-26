`timescale 1ns/1ps
module spi_slave(cs, mosi, sclk, d_out, done
);

input cs, mosi, sclk;
output reg done;
output  [11:0]d_out;

reg [1:0] present_state;
reg [1:0] next_state;
reg [3:0] count_bit;
reg [11:0] temp;

parameter DETECT_START = 2'b00;
parameter READ_DATA = 2'b01;

//we will make twow states here 1. Detect start state 2. Read the data
//once all the 12 bits are read we will move the FSM back to IDLE state i.e. Detect start stae 
//and then transfer the value of the temp to dout
always @ (posedge sclk)begin
    if (cs == 1'b1)begin
        present_state <= DETECT_START;

    end
    else begin 
        present_state <= next_state;
    end
end

always @ (posedge sclk) begin
        count_bit = 'd0;
        temp = 0;//added for initial condition cs as rst
         done = 1'b0;
    case (present_state)
        DETECT_START: begin
        done<= 1'b0;
            if (cs == 1'b0) begin
                next_state = READ_DATA;
            end
            else begin
                next_state = DETECT_START;
            end     
        end
        READ_DATA: begin
            if (count_bit <= 11)begin
                count_bit = count_bit + 1'b1;
                temp = {mosi, temp[11:1]};
            end
            else begin
                count_bit = 'd0;
                done = 1'b1;
                next_state = DETECT_START;
            end
        end
    endcase
    
end
assign d_out = temp;

endmodule
