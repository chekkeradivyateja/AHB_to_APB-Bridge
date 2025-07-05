class env_config extends uvm_object;
	`uvm_object_utils(env_config)
	ahb_agt_config ahb_cfg[];
	apb_agt_config apb_cfg[];
	
	int has_ahb;
	int has_apb;
	bit has_sb;
	int no_of_master_agents;
   	int no_of_slave_agents;

	function new(string name ="env_config");
	super.new(name);
	endfunction
endclass
