module top;


env environment;

// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;
localparam depth=32;
localparam width=8;
// SYSTEMVERILOG: logic and bit data types
bit         clk;


//memory interface instantiation 
mem_intf   #(.DEPTH(depth),.WIDTH(width))       intf   (clk);
mem        #(.DEPTH(depth),.WIDTH(width))       memory (  .inf(intf.mem));
testbench t1(intf);

always #5 clk = ~clk;


endmodule


