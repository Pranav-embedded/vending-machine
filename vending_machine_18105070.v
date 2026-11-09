`timescale 1ns/1ps
// -----------------------------------------------------------------------------
// vending_machine_18105070.v : vending machine FSM (from the lab report)
//
// Item costs 15 rs. Coins: 01 = 5 rs, 10 = 10 rs, 00 = no coin.
// States remember the money inside:  s0 = 0 rs,  s1 = 5 rs,  s2 = 10 rs.
//   out    = 1 : item (bottle) is given
//   change = 01: give back 5 rs,   change = 10: give back 10 rs
// If no coin comes while money is inside (in = 00), the money is returned.
// -----------------------------------------------------------------------------
module vending_machine_18105070(
    input clk,
    input rst,
    input [1:0] in,          // 01 = 5 rs, 10 = 10 rs
    output reg out,
    output reg [1:0] change
);

parameter s0 = 2'b00;
parameter s1 = 2'b01;
parameter s2 = 2'b10;

reg [1:0] c_state, n_state;

always @ (posedge clk)
    begin
        if (rst == 1)
            begin
                c_state = 0;
                n_state = 0;
                change  = 2'b00;
            end
        else
            c_state = n_state;

        case (c_state)
            s0: // state 0 : 0 rs
                if (in == 0)
                    begin
                        n_state = s0;
                        out = 0;
                        change = 2'b00;
                    end
                else if (in == 2'b01)
                    begin
                        n_state = s1;
                        out = 0;
                        change = 2'b00;
                    end
                else if (in == 2'b10)
                    begin
                        n_state = s2;
                        out = 0;
                        change = 2'b00;
                    end

            s1: // state 1 : 5 rs
                if (in == 0)
                    begin
                        n_state = s0;
                        out = 0;
                        change = 2'b01; // change returned 5 rs
                    end
                else if (in == 2'b01)
                    begin
                        n_state = s2;
                        out = 0;
                        change = 2'b00;
                    end
                else if (in == 2'b10)
                    begin
                        n_state = s0;
                        out = 1;
                        change = 2'b00;
                    end

            s2: // state 2 : 10 rs
                if (in == 0)
                    begin
                        n_state = s0;
                        out = 0;
                        change = 2'b10; // change returned 10 rs
                    end
                else if (in == 2'b01)
                    begin
                        n_state = s0;
                        out = 1;
                        change = 2'b00;
                    end
                else if (in == 2'b10)
                    begin
                        n_state = s0;
                        out = 1;
                        change = 2'b01; // change returned 5 rs and 1 bottle
                    end
        endcase
    end

endmodule
