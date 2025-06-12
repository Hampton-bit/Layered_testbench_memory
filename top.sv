module top;
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;
localparam depth=32;
localparam width=8;
// SYSTEMVERILOG: logic and bit data types
bit         clk;
wire       read;
wire       write;
wire [4:0] addr;

wire [7:0] data_out;      // data_from_mem
wire [7:0] data_in;       // data_to_mem


//memory interface instantiation 
mem_intf   #(.DEPTH(depth),.WIDTH(width))       intf   (clk);
mem_test   #(.DEPTH(depth),.WIDTH(width))       test   ( .test_inf(intf.test) );
mem        #(.DEPTH(depth),.WIDTH(width))       memory (  .inf(intf.mem));

always #5 clk = ~clk;
endmodule
