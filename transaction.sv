typedef enum  
    {
        PRINTABLE_ASCII, UPPER_CASE, LOWER_CASE, PROBABILITY
    } 
    control_t;

class transaction #(parameter DEPTH=32, parameter WIDTH=8);

    // rand bit [ $clog2(DEPTH)-1:0 ] addr;
    // rand bit [ WIDTH-1:0 ]         data;
    control_t ctrl;

    //-----------mem_interface_signals-------------//
    rand logic read;
    rand logic write;
    rand logic [$clog2(DEPTH)-1:0] addr;
    rand logic [WIDTH-1:0] data_in;     // data_in TO memory
    logic [WIDTH-1:0] data_out;   // data_in FROM memory
    //--------------------------------------------//


    function void display();
    if(write)  $display("\nWrite Trans | Data_in: %0c | Addr:%0d\n", data_in, addr);
    else $display("Read Trans | Addr:%0d",  addr);
    endfunction

    constraint read_write{ 
        read!=write;
    }
    constraint read_write_range{ 
        read inside {1,0};
        write inside {1,0};
    }

    // covergroup cover_alpha;
    //     a: coverpoint addr;
    //     d: coverpoint  data_in {
    //         bins upper={[8'h41:8'h5a]};
    //         bins lower={[8'h61:8'h7a]};
    //         bins other= default;
    //     }
    // endgroup : cover_alpha


    // constraint printable_ascii {
    //     data_in inside {
    //         [8'h20 : 8'h7F]
    //     };
    // }

    // constraint ascii_alphabet {
    //     data_in inside {
    //         [8'h41:8'h5a], [8'h61:8'h7a]
    //     };
    // }
    constraint ascii_weightage {
        data_in dist {
            [8'h41:8'h5a]:/80, [8'h61:8'h7a]:/20
        };
    }
    // constraint not_ascii_weightage {
    //     (
    //         data_in inside {
    //         [8'h41:8'h5a], [8'h61:8'h7a]
    //         }
    //     );
    // }
    // constraint control_knob {
    //     ctrl== PRINTABLE_ASCII -> data_in inside {
    //         [8'h20 : 8'h7F]
    //     };
    //     ctrl== UPPER_CASE ->   data_in inside {
    //         [8'h41:8'h5a]
    //     };
    //     ctrl== LOWER_CASE ->   data_in inside {
    //         [8'h61:8'h7a]
    //     };
    //     ctrl== PROBABILITY ->   data_in dist {
    //         [8'h41:8'h5a]:/80, [8'h61:8'h7a]:/20
    //     }; 
    // }



    function new(int data_in=0, int data_out=0, int addr=0);
        this.data_in= data_in;
        this.data_out= data_out;
        this.addr=addr;
        // this.ctrl= ctrl;
        // cover_alpha=new();
    endfunction




endclass 