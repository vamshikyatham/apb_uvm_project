class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)
  
  virtual apb_intf vif;
  
  uvm_analysis_port #(transaction) mon_ap; //analysis port 
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
    mon_ap = new("mon_ap",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!(uvm_config_db#(virtual apb_intf)::get(this,"","vif",vif)))
       `uvm_fatal(get_type_name(),"No virtual interface");
  endfunction
  
  task run_phase(uvm_phase phase);
    transaction tx;
    `uvm_info(get_type_name(),"Monitor run phase start",UVM_LOW);

    forever begin
      @(vif.mon_cb);
	  
	  `uvm_info(get_type_name(),
          $sformatf("CLK=%0t PWRITE=%b PSEL=%b PENABLE=%b PREADY=%b PADDR=%0h ",
                    $time, vif.mon_cb.PWRITE, vif.mon_cb.PSEL, vif.mon_cb.PENABLE, vif.mon_cb.PREADY, vif.mon_cb.PADDR),
          UVM_LOW);
      if(vif.mon_cb.PSEL && vif.mon_cb.PENABLE && vif.mon_cb.PREADY)begin
        tx = transaction::type_id::create("tx", this);
        
        tx.PADDR = vif.mon_cb.PADDR;
        tx.PWRITE = vif.mon_cb.PWRITE;
        tx.PSLVERR = vif.mon_cb.PSLVERR;
        
        if(vif.PWRITE==1) tx.PWDATA = vif.mon_cb.PWDATA;
        else tx.PRDATA = vif.mon_cb.PRDATA;
        
        //sending to scoreboard
		
        mon_ap.write(tx);
		`uvm_info(get_type_name(),"Sent tx in to secorboard",UVM_LOW);
      
        
      end
    end   
  endtask
  
endclass
       