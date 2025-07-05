 class test extends uvm_test;
	`uvm_component_utils(test)

	int has_ahb=1;
	int has_apb=1;
	bit has_sb=1;
	env_config m_cfg;
	ahb_agt_config ahb_cfg[];
	apb_agt_config apb_cfg[];
	env envh;
	int no_of_master_agents = 1;
   	int no_of_slave_agents = 1;
 


	function new(string name="test",uvm_component parent);
	super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
	m_cfg=env_config::type_id::create("m_cfg");
	if(has_ahb)
	begin
	    ahb_cfg = new[no_of_master_agents];
		foreach(ahb_cfg[i])
		begin
		ahb_cfg[i]=ahb_agt_config::type_id::create($sformatf("ahb_cfg[%0d", i));
	 	ahb_cfg[i].is_active=UVM_ACTIVE;

		  uvm_config_db #(ahb_agt_config)::set(this,$sformatf("envh.ahb_agnt.ahba_h[%0d]*", i), "ahb_agt_config", ahb_cfg[i]);

	 if(!uvm_config_db #(virtual bridge_if)::get(this, "", "vif_ahb", ahb_cfg[i].vif))
               		`uvm_fatal("VIF CONFIG","Can't get vif")
		$display("test config get",ahb_cfg[i].vif);			
		m_cfg.ahb_cfg[i]=ahb_cfg[i];

		end
	end
//	end
	if(has_apb)
	begin
	    apb_cfg = new[no_of_slave_agents];
		foreach(apb_cfg[i])
		begin
		apb_cfg[i]=apb_agt_config::type_id::create($sformatf("apb_cfg[%0d]", i));
		apb_cfg[i].is_active=UVM_ACTIVE;

		  uvm_config_db #(apb_agt_config)::set(this,$sformatf("envh.apb_agnt.apba_h[%0d]*", i), "apb_agt_config", apb_cfg[i]);

	  if(!uvm_config_db #(virtual bridge_if)::get(this, "", "vif_apb", apb_cfg[i].vif))
               		`uvm_fatal("VIF CONFIG","Can't get vif")		
		m_cfg.apb_cfg[i]=apb_cfg[i];
		end
	end
			uvm_config_db#(env_config)::set(this,"*","env_config",m_cfg);
		m_cfg.has_ahb=has_ahb;
		m_cfg.has_apb=has_apb;
		m_cfg.no_of_master_agents=no_of_master_agents;
		m_cfg.no_of_slave_agents=no_of_slave_agents;
		m_cfg.has_sb=has_sb;
		

	envh=env::type_id::create("envh",this);
	endfunction

	 function void start_of_simulation_phase(uvm_phase phase);
       uvm_top.print_topology();
   	endfunction
   

endclass

/////////////////////// single Trans /////////////////////

class single_trans extends test;
	
	`uvm_component_utils(single_trans)
	
	single_seqs s_trnh;

	function new(string name="single_trans",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	endfunction
		
	task run_phase(uvm_phase phase);
	super.run_phase(phase);
	phase.raise_objection(this);

	s_trnh=single_seqs::type_id::create("s_trnh");
	s_trnh.start(envh.ahb_agnt.ahba_h[0].ahbsr_h);
	#50;
	phase.drop_objection(this);
	endtask
endclass

/////////////////// Increment Trans /////////////////////////

class incr_trans extends test;
	
	`uvm_component_utils(incr_trans)
	
	incr_seqs i_trnh;

	function new(string name="incr_trans",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	endfunction
		
	task run_phase(uvm_phase phase);
	super.run_phase(phase);
	phase.raise_objection(this);

	i_trnh=incr_seqs::type_id::create("i_trnh");
	i_trnh.start(envh.ahb_agnt.ahba_h[0].ahbsr_h);
	#50;
	phase.drop_objection(this);
	endtask
endclass

//////////////////////// Wrap ///////////////////////////////

class wrap_trans extends test;
	
	`uvm_component_utils(wrap_trans)
	
	wrap_seqs w_trnh;

	function new(string name="wrap_seqs",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	endfunction
		
	task run_phase(uvm_phase phase);
	super.run_phase(phase);
	phase.raise_objection(this);

	w_trnh=wrap_seqs::type_id::create("w_trnh");
	w_trnh.start(envh.ahb_agnt.ahba_h[0].ahbsr_h);
	#50;
	phase.drop_objection(this);
	endtask
endclass


