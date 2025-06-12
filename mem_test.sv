module mem_test  #(parameter DEPTH=32, parameter WIDTH=8)  (
                  mem_intf test_inf
                );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;
`include "transaction.sv"
transaction txn;
logic [WIDTH:0]memory_expected [0:DEPTH-1]; 


logic [ $clog2(DEPTH)-1:0 ] addr_cover;
logic [ WIDTH-1:0 ]         data_cover;


// SYSTEMVERILOG: new data types - bit ,logic
bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking

// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #400000ns $display ( " TEST TIMEOUT" );
      $finish;
    end

initial
  begin: memtest
  int error_status;
  process::self.srandom(22);
  error_status=0;

    $display("Clear Memory Test");
    @(negedge test_inf.clk);
    for (int i = 0; i< 32; i++) begin 
       // Write zero data to every address location
       test_inf.write_mem( i, 0,0);

    end 
    @(negedge test_inf.clk);
    for (int i = 0; i<32; i++)
      begin 
       // Read every address location
        
        test_inf.read_mem(i,0, .rdata(rdata) );
 
       // check each memory location for data = 'h00
        if (rdata == 0) begin 
            $display("Test Passed at %0dth location expected 0 | got %0d ",i, rdata);

        end 
        else begin 
          $display("Test Failed at %0dth location expected 0 | got %0d ",i, rdata);
            error_status++;
        end 
      end

   // print results of test
      printstatus(error_status);

    $display("Data = Address Test");
    @(negedge test_inf.clk);
    for (int i = 0; i< 32; i++) begin 
       // Write data = address to every address location

        test_inf.write_mem( i, i,0);
    end 
    @(negedge test_inf.clk);
    for (int i = 0; i<32; i++)
      begin
       // Read every address location
        
        test_inf.read_mem(i,0, .rdata(rdata) );
        
       // check each memory location for data = address
        if (rdata == i) begin 
          $display("Test Passed at %0dth location expected %0d | got %0d ",i,i, rdata);

        end 
        else begin 
          $display("Test Failed at %0dth location expected %0d | got %0d ",i,i, rdata);
            error_status++;
        end 

      end

   // print results of test
      // printstatus(error_status);
      // read_after_write ();
      // printstatus(error_status);
      // corner_test();
      // printstatus(error_status);
      // Random_Address_Data_Test();
      // printstatus(error_status);
      Random_test();
      printstatus(error_status);
    $finish;
  end : memtest





  task read_after_write ();
  int random;

    for(int i=0; i<32; i++) begin 
      random=$random%8'hFF;
      @(negedge test_inf.clk);
      test_inf.write_mem(i, random,0);
      @(negedge test_inf.clk);
      test_inf.read_mem(i,0, .rdata(rdata));
      @(negedge test_inf.clk);
      if(rdata==random) begin 
        $display("Read_after_write Test at address %0d passed", i);
      end else 
        begin 
          $display("Read_after_write Test at address %0d failed, rdata:%0d, random:%0d", i, rdata, random);
        end 
    end 
  endtask


  task corner_test();
  int random;
  repeat(100) begin 
    random=$random%8'hFF;
    @(negedge test_inf.clk);
    test_inf.write_mem(0, random,0);
    @(negedge test_inf.clk);
    test_inf.read_mem(0,0, .rdata(rdata) );
    @(negedge test_inf.clk);
    if(rdata==random) begin 
      $display("Corner  Test1 at address 0 passed");
    end else 
    begin 
        $display("Corner Test1 at address 0 failed, rdata:%0d",  rdata);
    end 


    random=$random%8'hFF;
    @(negedge test_inf.clk);
    test_inf.write_mem(31, random,0);
    @(negedge test_inf.clk);
    test_inf.read_mem(31,0, .rdata(rdata) );
    @(negedge test_inf.clk);
    if(rdata==random) begin 
      $display("Corner  Test2 at address 31 passed");
    end else 
    begin 
        $display("Corner Test2 at address 31 failed, rdata:%0d, random:%0d", rdata, random);
    end


  end 

  endtask
  
  task Random_Address_Data_Test();
      logic [7:0] random_data;
      logic [4:0] random_addr;
      $display("Random_Address_Data_Test starting");
      @(negedge test_inf.clk);
      //initialize to sum unknow memory
      for(int i=0; i< 32; i++) begin 
      
        test_inf.write_mem(i, 8'hFF,0);
        @(negedge test_inf.clk);
        memory_expected[i]=8'hFF;
      end 

      //now store random data into the memory

      random_addr=$urandom_range(0,31);
      random_data=$urandom_range(0,255);
      @(negedge test_inf.clk);
      test_inf.write_mem(random_addr,random_data,0);
      @(negedge test_inf.clk);
      memory_expected[random_addr]=random_data;

      //simulate the errors
      @(negedge test_inf.clk);
      test_inf.write_mem(10,99,0);
      @(negedge test_inf.clk);


      for(int i =0; i<32; i++)begin 

        test_inf.read_mem(i,0, .rdata(rdata) );
        @(negedge test_inf.clk);
        if(rdata==memory_expected[i]) begin 
          $display("Memory and array matched");
        end 
        else begin 
          $display("Memory and array not matched memory:%0d | array:%0d",rdata,memory_expected[random_addr]);
        end 

      end 

  
  endtask

  task Random_test();
    
    //int addr, data;
    int operation, ok, freq_up, freq_down;
    $display("Random Test");
    // addr= $urandom_range(0,31);
    // data= $urandom_range(0,255);
    repeat(10000) begin 
 
    // ok= randomize(addr, data, operation) with { 
    //   addr inside { [8'h00:8'd31] };
    //   data inside { [8'h20:8'h2F] };
    //   operation inside {0,1};

    // };
    // ok= randomize(addr, data, operation) with { 
    //   addr inside { [8'h00:8'd31] };
    //   data inside { [8'h41:8'h5a], [8'h61:8'h7a]  };
    //   operation inside {0,1};
  
    // };
    // ok= randomize(addr, data, operation) with { 
    //   addr inside { [8'h00:8'd31] };
    //   data dist  { [8'h41:8'h5a]:=80, [8'h61:8'h7a]:=20 };
    //   operation inside {0,1};
    // };  
    // ok= randomize(addr, data, operation) with { 
    //   addr inside { [8'h00:8'd31] };
    //   data dist  { [8'h41:8'h5a]:=80, [8'h61:8'h7a]:=20 };
    //   operation inside {0,1};
    // };  



    // if(!ok) $display("randomization failed");
    
    txn= new(0,2,3);
    txn.cover_alpha.start();
    // txn.constraint_mode(0);
    // txn.control_knob.constraint_mode(1);
    void'(txn.randomize());
    txn.display();

    txn.cover_alpha.sample();
    // $display("Operation: %0d", txn.operation);
    // if(txn.operation) begin //write
    if(txn.write) begin 
        test_inf.write_mem(txn.addr, txn.data_in,0);
        memory_expected[txn.addr]=txn.data_in;
    end 
    else begin 
      test_inf.read_mem(txn.addr,1, .rdata(rdata) );
      if(rdata==memory_expected[txn.addr]) begin 
        $display("Memory and array matched");
      end 
      else if ((^rdata === 1'bx) && (^memory_expected[txn.addr] === 1'bx)) begin
          $display("Both values are X | reading on used part of memory");
        end
      else begin 
        $display("FAIL: Memory and array not matched memory:%0c | array:%0c  | Address: %0d",rdata,memory_expected[addr], addr);
      end 

    end 
      
      // @(negedge test_inf.clk);
      // test_inf.write_mem(txn.addr, txn.data_in,0);
      // @(negedge test_inf.clk);
      // memory_expected[txn.addr]=txn.data_in;
      // $display("Writing to memory | Address: %0d| Data: %0c ", txn.addr,txn.data_in );
      if(txn.data_in inside { [8'h41:8'h5a] } ) begin 
        freq_up++;
      end 
      else if (txn.data_in inside { [8'h61:8'h7a] } ) freq_down++;
    // end 
    // else begin 
    //   @(negedge test_inf.clk);
    //   test_inf.read_mem(txn.addr,0, .rdata(rdata) );
    //   @(negedge test_inf.clk);

    //   $display("Reading to memory");
    //   if(rdata==memory_expected[txn.addr]) begin 
    //     $display("Memory and array matched");
    //   end 
    //   else if ((^rdata === 1'bx) && (^memory_expected[txn.addr] === 1'bx)) begin
    //       $display("Both values are X | reading on used part of memory");
    //     end
    //   else begin 
    //     $display("FAIL: Memory and array not matched memory:%0c | array:%0c  | Address: %0d",rdata,memory_expected[addr], addr);
    //   end 
    // end 
  end 
  txn.cover_alpha.stop();
  $display("Upper case freq: %0d | Lower case freq: %0d", freq_up,freq_down);

  endtask 



  // add result print function
  function void  printstatus( input int status);
  begin 
    if(status==0) begin 
      $display("Test Passed with 0 errors ");
    end 
    else begin 
      $display("Test Failed with %d errors ", status);
    end 
  end 

  endfunction 
endmodule
