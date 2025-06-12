
module mem #(parameter DEPTH=32, parameter WIDTH=8) (
            mem_intf inf
            );

timeunit 1ns;
timeprecision 1ns;

logic [WIDTH-1:0]memory [0:DEPTH-1]; 

always_ff@(posedge inf.clk )
begin 
  if(inf.write) begin 
    memory[inf.addr]<=inf.data_in;
  end 
  else if (inf.read) begin 
    inf.data_out<=memory[inf.addr];
  end 

end 
endmodule
