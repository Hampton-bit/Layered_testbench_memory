class driver;

transaction t;
mailbox gen_drv;
virtual mem_intf vif;
int txns_received=0;

function new(mailbox gen_drv, virtual mem_intf vif);
    this.gen_drv= gen_drv;
    this.vif=vif;   
    t=new();
endfunction

task run();
    forever begin 
        
        t=new();
        
        gen_drv.get(t);
            
        // if(got_t) begin
        @(negedge vif.clk);
        vif.read=t.read;
        vif.write=t.write;
        vif.data_in=t.data_in;
        vif.addr = t.addr;  
        @(posedge vif.clk);
        $display("[%0t] DRIVER: Drove Addr=%0d, DataIn=%h, Write=%b, Read=%b", $time, t.addr, t.data_in, t.write, t.read);

        txns_received++;
        // end 
       
    end 
endtask
endclass 