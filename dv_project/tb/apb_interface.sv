interface apb_intf(input logic clk,rst_n);
 //APB as 8 signals 
  logic 	  PWRITE  = 0;
  logic 	  PSEL    = 0;
  logic 	  PENABLE = 0;
  logic [7:0] PADDR   = 32'h0;
  logic [7:0] PWDATA  = 32'h0;
  logic 	  PREADY  ;
  logic [7:0] PRDATA  ;
  logic		  PSLVERR ;

/*
//clocking block for driver
  clocking drv_cb @(posedge clk);
    output PWRITE;
    output PSEL;
    output PENABLE;
    output PADDR;
    output PWDATA;

    input  PREADY;
    input  PRDATA;
    input  PSLVERR;
  endclocking
*/
//clocking block for monitor

  clocking mon_cb @(posedge clk);
  //default input#1;
    input PWRITE;
    input PSEL;
    input PENABLE;
    input PADDR;
    input PWDATA;
    input PREADY;
    input PRDATA;
    input PSLVERR;
  endclocking


property SETUP_TO_ACCESS;
	@(posedge clk);
	PSEL |-> ##1 PENABLE;
	//PSEL |=> PENABLE;
	
	//PSEL && PENABLE&&!PREADY |-> $stable(PADDR,PWRITE);
endproperty
	
assert property(SETUP_TO_ENABLE);
$error("PENABLE IS NOT HIGH AFTER PSEL HIGH");
endinterface


