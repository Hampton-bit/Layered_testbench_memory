program testbench(mem_intf.test intf);
    timeunit 1ns;
    timeprecision 1ns;

    env environment;

    initial begin 
        environment=new(50, intf);
        environment.run();
    end 

endprogram