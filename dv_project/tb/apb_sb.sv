class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)
  
  uvm_analysis_imp#(transaction, apb_scoreboard) sb_ap;
  
  
  //transaction apb_txn_q[$];
  bit [7:0] mem [0:255];
  bit       mem_valid [0:255];
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    sb_ap = new("sb_ap",this);
  endfunction
  
  function void write(transaction tx);
    `uvm_info(get_type_name(),"SB write task started",UVM_LOW);
    
     // apb_txn_q.push_back(tx);
      check_apb(tx);    
    `uvm_info(get_type_name(),"SB write task ended",UVM_LOW);
  endfunction
/////////////////////////////////////////////////////////////
//                  APB CHECK                    
//////////////////////////////////////////////////////////////
  
  
  function void check_apb(transaction tx);
    

//     bit [7:0] expected;
//     bit       exp_valid;
    int idx;
    
    idx = tx.PADDR[7:0];
    
    //PSlave error
    if (tx.PSLVERR) begin
      if (tx.PADDR < 8'h05 || tx.PADDR > 8'hF1)begin 
	  `uvm_error("APB_SB", "PSLVERR due to INVALID ADDRESS");
      end
      else begin
        `uvm_error("APB_SB", "PSLVERR due to PROTOCOL VIOLATION");
      end
      return;
    end
    else begin
      `uvm_info(get_type_name(),$sformatf("NO PSLAVE ERROR at addr = 0x%0h ",idx),UVM_LOW);
    end
    
    //WRITE CHECK
    
    if (tx.PWRITE) begin
      mem[idx] = tx.PWDATA;
      mem_valid[idx] = 1;
      `uvm_info(get_type_name(),$sformatf("[APB] WRITE PADDR[0x%0h] = 0x%0h", idx, tx.PWDATA),UVM_LOW);
    end
    
    //READ CHECK
    else begin
      if(!mem_valid[idx])begin
        `uvm_warning(get_type_name(),$sformatf("READ from Addr=0x%0h without prior WRITE", idx));
      end
      else if(tx.PRDATA !== mem[idx]) begin
        `uvm_error(get_type_name(),
                   $sformatf("APB READ MISMATCH Addr=0x%0h Exp=0x%0h Got=0x%0h",idx, mem[idx], tx.PRDATA));
      end
      else begin
        `uvm_info(get_type_name(),
                  $sformatf("APB READ MATCH PADDR = 0x%0h PRADAT = 0x%0h ",idx,tx.PRDATA),UVM_LOW);
      end
    end

  endfunction   

  
endclass