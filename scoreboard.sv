class scoreboard; 
transaction t1;
transaction t2;

mailbox mon_scb;
mailbox gen_scb;

int txns_received;

int ref_model [int];
int error_count;
event scb_ended;
int repeat_count;
function new(mailbox mon_scb, gen_scb, event scb_ended, int repeat_count );
    this.mon_scb=mon_scb;
    this.gen_scb=gen_scb;
    this.scb_ended=scb_ended;
    this.repeat_count=repeat_count;
    t1=new();
    t2=new();
endfunction

task run();
    forever begin 
        t1=new();
        t2=new();
        // bit got_gen_scb, got_mon_scb;
        gen_scb.get(t1);
        // if(got_gen_scb) begin 
            if(t1.write) begin 
                ref_model[t1.addr]=t1.data_in;
            end 
        // end 
        // got_mon_scb=
        mon_scb.get(t2);
        // if(got_mon_scb) begin 
            if(t2.read) begin 
                if(t2.data_out != ref_model[t2.addr]) begin 
                    error_count++;
                    $display("Mismatch | mem: %h | ref_model: %0h",t2.data_out, ref_model[t2.addr]);
                end
            end

        txns_received++;
        
        $display("[%0t] Scb: received Addr=%0d, DataIn=%h, DataOut=%h Write=%b, Read=%b", $time, t2.addr, t2.data_in, t2.data_out, t2.write, t2.read);
        // end 
        if(txns_received >= repeat_count) begin 
            ->scb_ended;
        end 
    end 
    #1;


endtask 

endclass 
