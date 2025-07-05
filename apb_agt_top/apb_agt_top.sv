class apb_agt_top extends uvm_env;
	`uvm_component_utils(apb_agt_top)

	apb_agent apba_h[];
	env_config env_cfg_h;

	function new(string name ="apb_agt_top",uvm_component parent);
	super.new(name,parent);
	endfunction

	function  void build_phase(uvm_phase phase);
	super.build_phase(phase);
	 if(!uvm_config_db #(env_config)::get(this, "", "env_config", env_cfg_h))
	     `uvm_fatal("CONFIG_OBJ", "Can't get in ahb_agt_top")
	  if(env_cfg_h.has_apb)
		apba_h=new[env_cfg_h.no_of_slave_agents];
	 foreach(apba_h[i])
	     apba_h[i] = apb_agent::type_id::create($sformatf("apba_h[%0d]", i), this);

	endfunction


endclass
