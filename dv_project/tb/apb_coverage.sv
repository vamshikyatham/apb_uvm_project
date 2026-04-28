class apb_coverage extends uvm_component;
  `uvm_component_utils(apb_coverage)

  uvm_analysis_imp #(transaction, apb_coverage) cov_imp;
  transaction cov_tx;

//------------covergroup---------------------
  covergroup apb_cg();
  
    //option.per_instance = 1;

    // Read / Write coverage
    PWRITE_cp : coverpoint cov_tx.PWRITE {
      bins READ  = {0};
      bins WRITE = {1};
    }

    // Address coverage
    PADDR_cp : coverpoint cov_tx.PADDR {
      bins LOW_ADDR  = {[8'h05 : 8'h50]};
      bins MID_ADDR  = {[8'h51 : 8'hA0]};
      bins HIGH_ADDR = {[8'hA1 : 8'hF1]};
	  illegal_bins OUT_OF_RANGE = default;
    }

    // Error coverage
    PSLVERR_cp : coverpoint cov_tx.PSLVERR {
      bins OKAY = {0};
      bins ERR  = {1};
    }

    // Cross coverage
    RW_ADDR_CROSS : cross PWRITE_cp, PADDR_cp;

  endgroup
//------------covergroup end----------------------------

  function new(string name, uvm_component parent);
    super.new(name, parent);
    cov_imp = new("cov_imp", this);
    apb_cg = new();
  endfunction

  function void write(transaction tx);
    cov_tx = tx;
    apb_cg.sample();
  endfunction
endclass
