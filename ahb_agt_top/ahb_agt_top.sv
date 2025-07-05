class ahb_agt_top extends uvm_env;
	`uvm_component_utils(ahb_agt_top)

	ahb_agent  ahba_h[];
	env_config env_cfg_h;

	function new(string name ="ahb_agt_top",uvm_component parent);
	super.new(name,parent);
	endfunction
	
	function  void build_phase(uvm_phase phase);
	super.build_phase(phase);
	 if(!uvm_config_db #(env_config)::get(this, "", "env_config", env_cfg_h))
	     `uvm_fatal("CONFIG_OBJ", "Can't get in ahb_agt_top")
	  if(env_cfg_h.has_ahb)
		ahba_h=new[env_cfg_h.has_ahb];
	 foreach(ahba_h[i])
	     ahba_h[i] = ahb_agent::type_id::create($sformatf("ahba_h[%0d]", i), this);

	endfunction

/*	task run_phase(uvm_phase phase);
	uvm_top.print_topology();
	endtask */
endclass
