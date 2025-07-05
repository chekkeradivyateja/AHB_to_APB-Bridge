class ahb_mon extends uvm_monitor;
	`uvm_component_utils(ahb_mon)
	ahb_agt_config ahb_cfg;
   	ahb_xtn xtn;
	  uvm_analysis_port #(ahb_xtn) a_port;

  	virtual bridge_if.M_MON m_vif;
	

	function new(string name = "ahb_mon", uvm_component parent);
	super.new(name, parent);
	a_port = new("a_port", this);	
	endfunction
	
	function void build_phase(uvm_phase phase);
	if(!uvm_config_db#(ahb_agt_config)::get(this,"","ahb_agt_config",ahb_cfg))
	`uvm_fatal("error","config not getting")
	super.build_phase(phase);
	endfunction

	  function void connect_phase(uvm_phase phase);
	     m_vif = ahb_cfg.vif;
	  endfunction
	  
	 task run_phase(uvm_phase phase);
	      super.run_phase(phase);
		  `uvm_info("DEBUG_MSG", "Run_phase of M_MON started", UVM_HIGH);
		forever
			collect_data();
	  endtask

	task collect_data();
	xtn = ahb_xtn::type_id::create("xtn");

	while(m_vif.m_mon.Hreadyout!==1)
		@(m_vif.m_mon);
	while((m_vif.m_mon.Htrans==2'b00) || (m_vif.m_mon.Htrans==2'b01))
		@(m_vif.m_mon);


		xtn.Haddr = m_vif.m_mon.Haddr;
		xtn.Hresetn=m_vif.m_mon.Hresetn;
		xtn.Htrans = m_vif.m_mon.Htrans;
		xtn.Hwrite = m_vif.m_mon.Hwrite;
		xtn.Hsize = m_vif.m_mon.Hsize;
		xtn.Hburst=m_vif.m_mon.Hburst;
		xtn.Hresp=m_vif.m_mon.Hresp;

		@(m_vif.m_mon);

		while(m_vif.m_mon.Hreadyout!==1)
			@(m_vif.m_mon);
	
			if(m_vif.m_mon.Hwrite)
			xtn.Hwdata=m_vif.m_mon.Hwdata;
		
		else
			xtn.Hrdata=m_vif.m_mon.Hrdata;
		
				`uvm_info("MASTER_MONITOR",$sformatf("printing from master monitor \n %s",xtn.sprint()),UVM_LOW)
	

	endtask		


endclass
