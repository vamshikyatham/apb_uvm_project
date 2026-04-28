class apb_sequencer extends uvm_sequencer#(transaction);
  `uvm_component_utils(apb_sequencer)
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass
///////////////////////////////////////////////////
//            Virtual Sequencer                    
///////////////////////////////////////////////////
class virtual_sequencer extends uvm_sequencer;
  `uvm_component_utils(virtual_sequencer)

  apb_sequencer apb_seqr;   //handles of actual sequencers 
  //uart_sequencer uart_seqr 

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass

