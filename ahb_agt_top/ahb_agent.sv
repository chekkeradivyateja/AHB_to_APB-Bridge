class ahb_agent extends uvm_agent;
`uvm_component_utils(ahb_agent)
	ahb_agt_config ahb_cfg;
	ahb_mon ahbm_h;
	ahb_drv ahbd_h;
	ahb_seqr ahbsr_h;

	function new(string name="ahp_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	  
 	 function void build_phase(uvm_phase phase);
      		if(!uvm_config_db #(ahb_agt_config)::get(this, "", "ahb_agt_config", ahb_cfg))
	     `uvm_fatal("CONFIG_OBJ", "Can't get in ahb_agt")
	 
	  ahbm_h = ahb_mon::type_id::create("ahbm_h", this);
	  if(ahb_cfg.is_active==UVM_ACTIVE)
	  begin
	     ahbsr_h = ahb_seqr::type_id::create("ahbsr_h", this);
		 ahbd_h = ahb_drv::type_id::create("ahbd_h", this);
	  end
  	endfunction
	

	function void connect_phase(uvm_phase phase);
	if(ahb_cfg.is_active)
	begin
	ahbd_h.seq_item_port.connect(ahbsr_h.seq_item_export);
	end
	endfunction


endclass
