class ahb_drv extends uvm_driver #(ahb_xtn);
	`uvm_component_utils(ahb_drv)
	ahb_agt_config ahb_cfg;

  	virtual bridge_if.M_DRV m_vif;
	//ahb_xtn xtn;

	function new(string name="ahb_drv",uvm_component parent);
	super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
	if(!uvm_config_db#(ahb_agt_config)::get(this,"","ahb_agt_config",ahb_cfg))
	`uvm_fatal("error","config not getting")
	super.build_phase(phase);
	endfunction

 	function void connect_phase(uvm_phase phase);
		 m_vif = ahb_cfg.vif;
		 if(m_vif == ahb_cfg.vif)
		   `uvm_info("DEBUG_MSG","VIF GET SUCCESSFULL", UVM_HIGH)
		 else
		   `uvm_info("DEBUG_MSG","VIF GET FAILED", UVM_HIGH)
      endfunction

	task run_phase(uvm_phase phase);
		@(m_vif.m_drv);	
		m_vif.m_drv.Hresetn <= 0;
		@(m_vif.m_drv);
		m_vif.m_drv.Hresetn <= 1;
		@(m_vif.m_drv);

	forever	
	begin
	seq_item_port.get_next_item(req);
	send_to_dut(req);
	//req.print();
	seq_item_port.item_done();
	end
	endtask


	task send_to_dut(ahb_xtn xtn);

		while(m_vif.m_drv.Hreadyout!==1)
			@(m_vif.m_drv);


		m_vif.m_drv.Htrans <= xtn.Htrans;
		m_vif.m_drv.Haddr <= xtn.Haddr;
		m_vif.m_drv.Hsize <= xtn.Hsize;
		m_vif.m_drv.Hburst <= xtn.Hburst;
		m_vif.m_drv.Hwrite <= xtn.Hwrite;
		m_vif.m_drv.Hreadyin <= 1'b1;

		@(m_vif.m_drv);



		while(m_vif.m_drv.Hreadyout!== 1)
			@(m_vif.m_drv);


			
		if(xtn.Hwrite)
			m_vif.m_drv.Hwdata <= xtn.Hwdata;
			else
			m_vif.m_drv.Hwdata <= 0;
			`uvm_info("MASTER_DRIVER",$sformatf("printing from master driver \n %s",xtn.sprint()),UVM_LOW)
	endtask

endclass
