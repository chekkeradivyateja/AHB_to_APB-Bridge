 package test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
//	`include "tb_defs.sv"
	`include "ahb_agt_config.sv"
	`include "apb_agt_config.sv"
	`include "env_config.sv"

	`include "ahb_xtn.sv"
	`include "ahb_drv.sv"
	`include "ahb_mon.sv"
	`include "ahb_seqr.sv"
	`include "ahb_agent.sv"
	`include "ahb_agt_top.sv"
	`include "ahb_seqs.sv"
	`include "apb_xtn.sv"

	`include "apb_drv.sv"
	`include "apb_mon.sv"
	`include "apb_seqr.sv"
	`include "apb_agent.sv"
	`include "apb_agt_top.sv"
	`include "apb_seqs.sv"


	`include "scoreboard.sv"
	//`include "ram_virtual_seqs.sv"
	
	`include "env.sv"


	`include "test.sv"
	
	
endpackage
