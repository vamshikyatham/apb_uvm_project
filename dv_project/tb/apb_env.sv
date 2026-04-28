class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)
  
  apb_agent agent;
  apb_scoreboard sb;
  
  apb_coverage cov;
  
  //uart_agent uart_agt;
  //uart_scoreboard uart_sb;
  //uart_coverage cov_uart;
  
  virtual_sequencer vseqr;//new virtual sequencer
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    
    agent = apb_agent::type_id::create("agent",this);
    sb = apb_scoreboard::type_id::create("sb",this);
    vseqr = virtual_sequencer::type_id::create("vseqr",this);
	cov = apb_coverage::type_id::create("cov",this);
    

  endfunction 
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //MON ---> SB
    agent.mon.mon_ap.connect(sb.sb_ap);
    //uart_agt.uart_mon.uart_ap.connect(uart_sb.uart_sb_ap);
	
	agent.mon.mon_ap.connect(cov.cov_imp);
    
    //REAL SEQUENCER -- VIRTUAL SEQUENCER
    vseqr.apb_seqr = agent.seqr;//we assign each agent’s real sequencer handle to the virtual sequencer
								//We are connecting real sequencers from agents into the virtual sequencer.
	
   //vseqr.uart_seqr = uart_agent.seqr;
    //The virtual sequencer is created in the environment, and in connect phase we assign real sequencer handles from agents.
    
    
    
  endfunction

  
endclass