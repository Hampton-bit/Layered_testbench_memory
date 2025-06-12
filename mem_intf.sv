interface mem_intf  #(parameter DEPTH=32, parameter WIDTH=8) (input logic clk);
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

logic read;
logic write;
logic [$clog2(DEPTH)-1:0] addr;
logic [WIDTH-1:0] data_in;     // data TO memory
logic [WIDTH-1:0] data_out;   // data FROM memory


task read_mem( input logic [4:0]addr_t, input logic debug, output logic [7:0] rdata );

    write =1'b0;
    read= 1'b1;
    addr = addr_t;

    @(negedge clk);
    rdata = data_out;
    write =1'b0;
    read= 1'b0;
    if(debug) begin
        $display("Read address %0d | Data Read %0c ",addr, rdata);
    end
  
endtask

  // add read_mem and write_mem tasks
task write_mem( input logic [4:0]addr_t, 
                input logic [7:0]data_in_t,
                input logic debug              
                );


        write =1'b1;
        read= 1'b0;

        addr    =addr_t;
        data_in =data_in_t ;
        @(negedge clk);
        write =1'b0;
        read= 1'b0;
        if(debug) begin
        $display("Write address %0d | Data Written %0c ",addr, data_in);
        end

endtask
modport mem (input clk, read, write , addr , data_in , output  data_out );
modport test (output clk, read, write , addr , data_in , input  data_out, import write_mem,read_mem );

endinterface


