class test extends uvm_test;
  `uvm_component_utils(test)
  
  apb_env env;
// //   apb_sequence seq;
// //   apb_seq t1;
  apb_virtual_seq vseq;
  
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    env = apb_env::type_id::create("env",this);
    vseq  = apb_virtual_seq::type_id::create("vseq",this);

  endfunction 
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
  
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction 
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
	
    phase.raise_objection(this);
	
		vseq.start(env.vseqr); //This is a virtual sequence start call on a virtual sequencer
		
    phase.drop_objection(this);
	
  endtask
  
endclass



/*
Sharana Basava
20:44
.write in ral
.read in ral
.mirror
set value
get value
Aruguments for above methods

Sharana Basava
20:45
APB time

Sharana Basava
20:55
dram_reg_bllock.sv
dram_reg_block dram_inst;
dram_inst.write('h8,ff,status)

Sharana Basava
20:56
.write/.read/.mirror

*/