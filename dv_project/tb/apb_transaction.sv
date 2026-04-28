class transaction extends uvm_sequence_item;
  `uvm_object_utils(transaction)
  
  
  rand bit 		 PWRITE;
  rand bit [7:0] PADDR;
  rand bit [7:0] PWDATA;
  
       bit 		 PSEL;
       bit 		 PENABLE;
       bit 		 PREADY;
       bit [7:0] PRDATA;
  	   bit 		 PSLVERR;
  	   

  
  
  constraint addrs_c {PADDR inside {[8'h05:8'hF1]};}
  
  
  function new(string name ="transaction");
    super.new(name);
  endfunction
  
endclass

  