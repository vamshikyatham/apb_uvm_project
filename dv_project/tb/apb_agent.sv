class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)
  
  virtual apb_intf vif;
  apb_driver   drv;
  apb_monitor  mon;
  apb_sequencer seqr;
  
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_intf)::get(this,"","vif",vif))
      `uvm_fatal(get_type_name(),"No virtual interface found");
    
    drv = apb_driver::type_id::create("drv",this);
    mon = apb_monitor::type_id::create("mon",this);
    seqr = apb_sequencer::type_id::create("seqr",this);
    
    uvm_config_db#(virtual apb_intf)::set(this,"drv","vif",vif);
    uvm_config_db#(virtual apb_intf)::set(this,"mon","vif",vif);
  endfunction 
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask
  
  
  
endclass