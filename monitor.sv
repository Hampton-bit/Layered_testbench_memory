class monitor;
transaction t;
virtual mem_intf vif;
mailbox mon_scb;

function new(mailbox mon_scb, virtual mem_intf vif);
    this.vif=vif;
    this.mon_scb=mon_scb;
    t=new();
endfunction

task run();

    forever begin 
        @(posedge vif.clk);
        #2ns;
        t=new();
        
         // Capture all interface signals
        t.addr     = vif.addr;
        t.data_in  = vif.data_in;
        t.write    = vif.write;
        t.read     = vif.read;
        t.data_out = vif.data_out;
        // if (t.data_out === 'x) begin
        //     $fatal("[%0t] WARNING: Read uninitialized memory at address %0d", $time, t.addr);
        // end
        $display("[%0t] Monitor: received Addr=%0d, DataIn=%h, DataOut=%h Write=%b, Read=%b", $time, t.addr, t.data_in, t.data_out, t.write, t.read);
        mon_scb.put(t);
    end 

endtask

endclass 