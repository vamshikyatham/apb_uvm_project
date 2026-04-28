class apb_driver extends uvm_driver#(transaction);
  `uvm_component_utils(apb_driver)
  
  virtual apb_intf vif;
  transaction tx;
  
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_intf)::get(this,"","vif",vif))
      `uvm_fatal(get_type_name(),"No virtual interface found");
    `uvm_info(get_type_name(),"Driver build phase completed",UVM_LOW);
    reset_signals();
  endfunction

  
  function void reset_signals();
    vif.PSEL    = 0;
    vif.PENABLE = 0;
    vif.PWRITE  = 0;
    vif.PADDR   = '0;
    vif.PWDATA  = '0;
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"Driver Run phase started",UVM_LOW);
    vif.PSEL    = 0;
    vif.PENABLE = 0;
    vif.PWRITE  = 0;
    vif.PADDR   = '0;
    vif.PWDATA  = '0;
    wait(vif.rst_n == 1);
    
    forever begin
      seq_item_port.get_next_item(tx);
      @(posedge vif.clk);
      if(tx.PADDR !== 'x)begin
        if(tx.PWRITE) write_apb(tx);
        else read_apb(tx);
      end
      else `uvm_info(get_type_name(),
                     "APB PADDR is unknown 0xXX",UVM_LOW);
      seq_item_port.item_done();

    `uvm_info(get_type_name(),"Driver Run phase End",UVM_LOW);
    end  
  endtask 
///////////////////////////////////////////////////////
//        				 APB WRITE                     
///////////////////////////////////////////////////////
  
  virtual task write_apb(transaction tx);
    int apb_timeout = 0;
    
    
    vif.PADDR   = tx.PADDR;
    vif.PWRITE  = 1;
    vif.PWDATA  = tx.PWDATA;
    vif.PSEL    = 1;
    vif.PENABLE = 0;
    @(posedge vif.clk);
    vif.PENABLE = 1;
    @(posedge vif.clk);
    
    while(!vif.PREADY && (apb_timeout < 101))begin
      @(posedge vif.clk);
      apb_timeout++;
    end
    if(apb_timeout == 100) 
      `uvm_error(get_type_name(),"Driver Write PREADY not assersted by DUT"); 
     
    //wait(vif.PREADY);
    
    //@(posedge vif.clk);
    vif.PSEL = 0;
    vif.PENABLE = 0;
    //@(posedge vif.clk);
    
  endtask
  
  virtual task read_apb(transaction tx);
    int apb_timeout = 0;
    
    vif.PADDR  = tx.PADDR;
    vif.PWRITE = 0;
    vif.PSEL   = 1;
    vif.PENABLE = 0;
    @(posedge vif.clk);
    
    vif.PENABLE = 1;
    @(posedge vif.clk);
    
    while(!vif.PREADY && (apb_timeout < 100)) begin
      @(posedge vif.clk);
      apb_timeout++;
    end
    if(apb_timeout == 100) 
      `uvm_error(get_type_name(),"Driver Read PREADY is not asserted");
    
    //wait(vif.PREADY);
	//@(posedge vif.clk);
    tx.PRDATA = vif.PRDATA;
    vif.PSEL = 0;
    vif.PENABLE = 0;
    vif.PWRITE = 1;
    @(posedge vif.clk);
    
    
    
    
    
  endtask
  
  
  
  
endclass

    
    