//`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "apb_slave.sv"

`include "apb_interface.sv"

`include "apb_transaction.sv"
`include "apb_sequencer.sv"
`include "apb_sequence.sv"
`include "apb_driver.sv"
`include "apb_coverage.sv"
`include "apb_monitor.sv"
`include "apb_sb.sv"
`include "apb_agent.sv"
`include "apb_env.sv"
`include "apb_test.sv"


module tb;
  
  logic clk,rst;
  
  apb_intf intf_h(
    .clk(clk),
    .rst_n(rst)
  );
  
  
  apb_slave DUT_VAMSHI(
    
    .RSTN(intf_h.rst_n),
    .PCLK(intf_h.clk),
    .PWRITE(intf_h.PWRITE),
    .PSEL(intf_h.PSEL),
    .PENABLE(intf_h.PENABLE),
    .PADDR(intf_h.PADDR),
    .PWDATA(intf_h.PWDATA),
    .PREADY(intf_h.PREADY),
    .PRDATA(intf_h.PRDATA),
    .PSLVERR(intf_h.PSLVERR)
  );
  
  always #5 clk = !clk;
  
  initial begin
    clk = 0;
    rst = 'x;
    #3;
    rst = 0;
    #5;
    rst = 1;
  end
  
  initial begin
    uvm_config_db #(virtual apb_intf)::set(null,"uvm_test_top.env.agent","vif",intf_h);
    run_test();
    

  end
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end
  
endmodule 
  

//-access +rw +UVM_VERBOSITY=UVM_HIGH +access+r +UVM_OBJECTION_TRACE +UVM_TESTNAME=test(write the name of your uvm_test class name --->test )



  