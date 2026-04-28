class apb_sequence extends uvm_sequence#(transaction);
  `uvm_object_utils(apb_sequence)
  
  function new(string name = "apb_sequence");
    super.new(name);
  endfunction 

    
endclass
//--------------------------------------------------------
//                   APB RANDOM WRITE AND READ                             
//--------------------------------------------------------

class apb_seq extends apb_sequence;
  `uvm_object_utils(apb_seq)
  
  transaction tx;
  
  function new(string name = "apb_seq");
    super.new(name);
  endfunction 

  
  task body();
    `uvm_info(get_type_name(),"Sequence body",UVM_LOW);
    
    tx = transaction::type_id::create("tx");
    
    start_item(tx);
    `uvm_info(get_type_name(),"sequence starting item",UVM_LOW);
	
			if(!tx.randomize() with {PADDR == 'h11;}) `uvm_info(get_type_name(),"randomization failed ",UVM_LOW);
	
    `uvm_info(get_type_name(),"sequence Randmization completed",UVM_LOW);
	
    finish_item(tx);
	
    `uvm_info(get_type_name(),"sequence Finished item",UVM_LOW);
    
    
  endtask 
    
endclass
//--------------------------------------------------------
//                   APB WRITE                             
//--------------------------------------------------------

class apb_write extends apb_sequence;
  `uvm_object_utils(apb_write)
  
  transaction tx;
  
  function new(string name="apb_write");
    super.new(name);
  endfunction
	
  task body();
  bit [7:0] write_addrs[] = '{8'h16, 8'h55, 8'hA2};
  
  foreach(write_addrs[i])begin
    `uvm_info(get_type_name(),"Driving APB WRITE Transaction",UVM_LOW);
    tx = transaction::type_id::create("tx");
    `uvm_do_with(tx,{PADDR == write_addrs[i]; PWRITE==1;});
	end
  endtask
endclass
//--------------------------------------------------------
//                   APB READ                             
//--------------------------------------------------------
class apb_read extends apb_sequence;
  `uvm_object_utils(apb_read)
  
  transaction tx;
  
  function new(string name="apb_read");
    super.new(name);
  endfunction
  
  task body();
    bit [7:0] read_addrs[] = '{8'h16, 8'h55, 8'hA2};

    foreach(read_addrs[i]) begin
      `uvm_info(get_type_name(),"Driving APB READ Transaction", UVM_LOW);
      tx = transaction::type_id::create("tx");
      
      `uvm_do_with(tx, {PADDR == read_addrs[i];PWRITE == 0;});
  
    end
  endtask
endclass
//--------------------------------------------------------
//                   APB READ                             
//--------------------------------------------------------


///////////////////////////////////////////////////////////
//             VIRTUAL SEQUENCE   APB                      
///////////////////////////////////////////////////////////

class apb_virtual_seq extends uvm_sequence;
  `uvm_object_utils(apb_virtual_seq)

  virtual_sequencer vseqr;//handle of virtual sequencer 

  function new(string name="apb_virtual_seq");
    super.new(name);
  endfunction

  task body();
    apb_seq seq;     // handles of normal sequences 
    apb_write apb_w; 
    apb_read apb_r;

    // Get virtual sequencer
    if(!$cast(vseqr,m_sequencer)) `uvm_fatal(get_type_name(),"ERROR");

    if (vseqr == null)
      `uvm_fatal("VSEQ", "Virtual sequencer handle is null");

    seq = apb_seq::type_id::create("seq");
    seq.start(vseqr.apb_seqr);
    
    apb_w = apb_write::type_id::create("apb_w");
    apb_w.start(vseqr.apb_seqr);//This is starting a lower-level APB sequence from a virtual sequence.
    
    apb_r = apb_read::type_id::create("apb_r");
    apb_r.start(vseqr.apb_seqr); //starts virtual sequencer
	
	
    
  endtask
endclass
///////////////////////////////////////////////////////////
//             VIRTUAL SEQUENCE   I2C                      
///////////////////////////////////////////////////////////

// class i2c_virtual_seq extends uvm_sequence;
//   `uvm_object_utils(i2c_virtual_seq)

//   virtual_sequencer vseqr;

//   task body();
//     i2c_write_seq i2c_w;
//     i2c_read_seq  i2c_r;

//     if(!$cast(vseqr, m_sequencer))
//       `uvm_fatal("I2C_VSEQ","Cast failed");

//     i2c_w = i2c_write_seq::type_id::create("i2c_w");
//     i2c_w.start(vseqr.i2c_seqr);

//     i2c_r = i2c_read_seq::type_id::create("i2c_r");
//     i2c_r.start(vseqr.i2c_seqr);
//   endtask
// endclass


