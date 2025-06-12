class scoreboard; 
transaction t;

mailbox mon_scb;
mailbox gen_scb;

int txns_received;

int ref_model [int];
int error_count;
event scb_ended;
function new(mailbox mon_scb, gen_scb, event scb_ended );
    this.mon_scb=mon_scb;
    this.gen_scb=gen_scb;
    this.scb_ended=scb_ended;
    t=new();
endfunction

task run();
    forever begin 
        bit got_gen_scb, got_mon_scb;
        got_gen_scb=gen_scb.try_get(t);
        if(got_gen_scb) begin 
            if(t.write) begin 
                ref_model[t.addr]=t.data_in;
            end 
        end 
        got_mon_scb=mon_scb.try_get(t);
        if(got_mon_scb) begin 
            if(t.read) begin 
                if(t.data_out != ref_model[t.addr]) error_count++;
            end

        txns_received++;
        
        $display("[%0t] Scb: received Addr=%0d, DataIn=%h, DataOut=%h Write=%b, Read=%b", $time, t.addr, t.data_in, t.data_out, t.write, t.read);
        end 
    end 
    #1;


endtask 

endclass 
