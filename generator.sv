class generator;

transaction t;
mailbox gen_drv;
mailbox gen_scb;
int repeat_count;
event gen_ended;


function new(mailbox gen_drv, gen_scb, int repeat_count, event gen_ended);

    this.gen_drv=gen_drv;
    this.gen_scb= gen_scb;
    this.repeat_count=repeat_count;
    this.gen_ended= gen_ended;
    t= new(,,,3);
    // t.cover_alpha=new();

endfunction

task run();
    repeat(repeat_count) begin 
        t= new();
        
        assert(t.randomize()) else $fatal("randomization failed");
        $display("[%0t] Generator: Addr=%0d, DataIn=%h, Write=%b, Read=%b", $time, t.addr, t.data_in, t.write, t.read);
        t.cover_alpha.sample();
        gen_drv.put(t);
        gen_scb.put(t);
    $display("hekko");

    end
    ->gen_ended;

endtask 

endclass 