class driver;

transaction t;
mailbox gen_drv;
// mailbox drv_scb;

virtual mem_intf vif;
int txns_received;

function new(mailbox gen_drv, virtual mem_intf vif);
    this.gen_drv= gen_drv;
    // this.drv_scb=drv_scb;
    this.vif=vif;  
    txns_received=0; 
    t=new();
endfunction

task run();
    forever begin 
        
        t=new(,,,4);
        
        gen_drv.get(t);
        // drv_scb.put(t);    
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