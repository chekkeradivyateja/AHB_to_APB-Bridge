class apb_drv extends uvm_driver;
	`uvm_component_utils(apb_drv)
	apb_agt_config apb_cfg;
   virtual bridge_if.S_DRV vif;


	function new(string name="apb_drv",uvm_component parent);
	super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
	if(!uvm_config_db#(apb_agt_config)::get(this,"","apb_agt_config",apb_cfg))
	`uvm_fatal("error","config not getting")
	super.build_phase(phase);
	endfunction 

	function void connect_phase(uvm_phase phase);
	vif = apb_cfg.vif;
	if(vif == apb_cfg.vif)
		`uvm_info("DEBUG_MSG","VIF GET SUCCESSFULL", UVM_HIGH)
	else
		`uvm_info("DEBUG_MSG","VIF GET FAILED", UVM_HIGH)
 	 endfunction

	task run_phase(uvm_phase phase);
	 super.run_phase(phase);
	//	@(vif.s_drv);	
	
	forever
	  begin
	    drive();   
	  end
	
  	endtask
 
  	task drive();
	while(vif.s_drv.Psel===0)
		@(vif.s_drv);
		
	
	while(vif.s_drv.Penable===0)
		@(vif.s_drv);

   	if(vif.s_drv.Pwrite==0)
     	begin
		//repeat(2)  
           begin
	
	      vif.s_drv.Prdata <= $urandom;
		//	$display("====================Prdata============================",vif.s_drv.Prdata);
//	`uvm_info("SLAVE_DRIVER",$sformatf("printing from slave driver \n %s",xtn.sprint()),UVM_LOW)

	   end
    	 end
  
  	 else
      	 vif.s_drv.Prdata <= 0;

		repeat(2)
			@(vif.s_drv);			

	endtask
endclass
