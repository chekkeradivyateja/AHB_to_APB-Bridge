class env extends uvm_env;
	`uvm_component_utils(env);

	ahb_agt_top ahb_agnt;
	apb_agt_top apb_agnt;
	env_config m_cfg;
	sb sbh;
	
	function new(string name ="env",uvm_component parent);
	super.new(name,parent);
	endfunction

	function void  build_phase(uvm_phase phase);
	if(!uvm_config_db#(env_config)::get(this,"","env_config",m_cfg))
	     `uvm_fatal("CONFIG_OBJ", "Can't get in env")
	super.build_phase(phase);
	if(m_cfg.has_ahb)
	begin
	ahb_agnt=ahb_agt_top::type_id::create("ahb_agnt",this);
	//uvm_config_db#(ahb_agt_config)::set(this,"*","ahb_agt_config",m_cfg.ahb_cfg);
	end
	if(m_cfg.has_apb)
	begin
	apb_agnt=apb_agt_top::type_id::create("apb_agnt",this);
	//uvm_config_db#(apb_agt_config)::set(this,"*","apb_agt_config",m_cfg.apb_cfg);
	end
	if(m_cfg.has_sb)
	sbh=sb::type_id::create("sbh",this);

	endfunction
	
	function void connect_phase(uvm_phase phase);
	      super.connect_phase(phase);
     	for(int i=0;i<m_cfg.no_of_master_agents;i++)		
	ahb_agnt.ahba_h[0].ahbm_h.a_port.connect(sbh.ahb_fifo[0].analysis_export);
     	for(int i=0;i<m_cfg.no_of_slave_agents;i++)		
	apb_agnt.apba_h[0].ahpm_h.ap_s.connect(sbh.apb_fifo[0].analysis_export);
	endfunction
/*
	function void connect_phase(uvm_phase phase);
                ahb_agnt.ahba_h.ahbm_h.a_port.connect(sbh.ahb_fifo.analysis_export);
                apb_agnt.apba_h.apbm_h.monitor_port.connect(sbh.apb_fifo.analysis_export);

	endfunction
*/
endclass


