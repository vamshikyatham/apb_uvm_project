interface intf(input clk,reset);
	logic [7:0] PADDR;
	logic [1:0] PSEL;
       	logic       PENABLE;
	logic       PWRITE;
	logic [31:0]PWDATA;
	logic [31:0]PRDATA;
	logic       PREADY;
	logic       PSLVERR;
endinterface

