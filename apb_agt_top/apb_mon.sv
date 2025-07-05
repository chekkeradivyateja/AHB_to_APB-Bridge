class apb_mon extends uvm_monitor;
	`uvm_component_utils(apb_mon)
	apb_agt_config apb_cfg;
	uvm_analysis_port #(apb_xtn) ap_s;

	virtual bridge_if vif;
	apb_xtn xtn_h;


	function new(string name = "apb_mon", uvm_component parent);
	super.new(name, parent);
		ap_s = new("apb_xtn",this);
	endfunction
		

	function void build_phase(uvm_phase phase);
	if(!uvm_config_db#(apb_agt_config)::get(this,"","apb_agt_config",apb_cfg))
	`uvm_fatal("error","config not getting")
	super.build_phase(phase);
	endfunction


	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif = apb_cfg.vif;
	endfunction


	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		@(vif.s_mon);
		forever 
			begin	
				collect_data();
				`uvm_info("SLAVE MONITOR",$sformatf("printing from slave monitor \n %s",xtn_h.sprint()),UVM_LOW)

				ap_s.write(xtn_h);

			end

	endtask


	task collect_data();
		
		xtn_h = apb_xtn::type_id::create("xtn_h");
			@(vif.s_mon);

		while(vif.s_mon.Penable!==1)
			@(vif.s_mon);
		
		while(vif.s_drv.Psel==0)
		@(vif.s_drv);

		xtn_h.Paddr = vif.s_mon.Paddr;
		xtn_h.Pwrite = vif.s_mon.Pwrite;
		xtn_h.Psel = vif.s_mon.Psel;
		xtn_h.Penable = vif.s_mon.Penable;

	

		if(vif.s_mon.Pwrite)begin
			xtn_h.Pwdata = vif.s_mon.Pwdata;
			$display("====================xtn_h.pwdata============================",vif.s_mon.Pwdata);
				end	
		else 
			xtn_h.Prdata = vif.s_mon.Prdata;
			$display("====================xtn_h.prdata============================",vif.s_mon.Prdata);



	//	repeat(2)
			@(vif.s_mon);
			
		
	endtask




endclass
