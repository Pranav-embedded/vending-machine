`timescale 1ns/1ps
// -----------------------------------------------------------------------------
// vending_machine_tb.v : testbench for the vending machine
//
// How it works:
//   - clock period is 10 ns
//   - each step() puts ONE coin on "in" for exactly one clock, then checks
//     the outputs after that clock edge
//   - coins must come on back-to-back clocks: if a clock passes with no coin
//     (in = 00) while money is inside, the machine gives the money back
// -----------------------------------------------------------------------------
module vending_machine_tb;

    // inputs
    reg clk;
    reg [1:0] in;
    reg rst;

    // outputs
    wire out;
    wire [1:0] change;

    vending_machine_18105070 uut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .out(out),
        .change(change)
    );

    // clock: flips every 5 ns
    initial clk = 0;
    always #5 clk = ~clk;

    integer passed;
    integer failed;

    task report(input ok);
        begin
            if (ok) begin
                passed = passed + 1;
                $display("   PASS");
            end else begin
                failed = failed + 1;
                $display("   FAIL   <<<<<<<<<<");
            end
        end
    endtask

    // one clock: put coin c on "in", then check out and change
    task step(input [1:0] c, input exp_out, input [1:0] exp_change);
        begin
            in = c;
            #10;
            $display("  coin %b: out = %b (expected %b), change = %b (expected %b)",
                     c, out, exp_out, change, exp_change);
            report(out == exp_out && change == exp_change);
        end
    endtask

    initial begin
        $dumpfile("vending_machine_18105070.vcd");
        $dumpvars(0, vending_machine_tb);

        passed = 0;
        failed = 0;
        rst = 1;
        in  = 2'b00;
        #30;
        rst = 0;

        $display("");
        $display("Test 1: after reset");
        step(2'b00, 0, 2'b00);

        $display("");
        $display("Test 2: 10 + 5 = 15 rs -> bottle");
        step(2'b10, 0, 2'b00);
        step(2'b01, 1, 2'b00);
        step(2'b00, 0, 2'b00);

        $display("");
        $display("Test 3: 5 + 10 = 15 rs -> bottle");
        step(2'b01, 0, 2'b00);
        step(2'b10, 1, 2'b00);
        step(2'b00, 0, 2'b00);

        $display("");
        $display("Test 4: 5 + 5 + 5 = 15 rs -> bottle");
        step(2'b01, 0, 2'b00);
        step(2'b01, 0, 2'b00);
        step(2'b01, 1, 2'b00);
        step(2'b00, 0, 2'b00);

        $display("");
        $display("Test 5: 10 + 10 = 20 rs -> bottle and 5 rs back");
        step(2'b10, 0, 2'b00);
        step(2'b10, 1, 2'b01);
        step(2'b00, 0, 2'b00);

        $display("");
        $display("Test 6: 5 + 5 + 10 = 20 rs -> bottle and 5 rs back");
        step(2'b01, 0, 2'b00);
        step(2'b01, 0, 2'b00);
        step(2'b10, 1, 2'b01);
        step(2'b00, 0, 2'b00);

        $display("");
        $display("Test 7: 5 rs then no coin -> 5 rs back");
        step(2'b01, 0, 2'b00);
        step(2'b00, 0, 2'b01);
        step(2'b00, 0, 2'b00);

        $display("");
        $display("Test 8: 10 rs then no coin -> 10 rs back");
        step(2'b10, 0, 2'b00);
        step(2'b00, 0, 2'b10);
        step(2'b00, 0, 2'b00);

        $display("");
        $display("=====================================");
        $display(" RESULT: %0d passed, %0d failed", passed, failed);
        $display("=====================================");
        $finish;
    end

endmodule
