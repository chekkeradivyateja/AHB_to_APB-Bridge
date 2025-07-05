class apb_agent extends uvm_agent;
`uvm_component_utils(apb_agent)

	apb_agt_config apb_cfg;
	apb_mon ahpm_h;
	apb_drv ahpd_h;
	apb_seqr ahpsr_h;

	function new(string name="apb_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
	super.build_phase(phase);	
	if(!uvm_config_db #(apb_agt_config)::get(this,"","apb_agt_config",apb_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
	ahpm_h = apb_mon::type_id::create("ahpm_h", this);
	if(apb_cfg.is_active == UVM_ACTIVE)
	begin
		ahpd_h = apb_drv::type_id::create("ahpd_h", this);
		ahpsr_h = apb_seqr::type_id::create("ahpsr_h", this);
	end
	endfunction

 function void connect_phase(uvm_phase phase);
     if(apb_cfg.is_active)
	   ahpd_h.seq_item_port.connect(ahpsr_h.seq_item_export);
  endfunction


endclass
