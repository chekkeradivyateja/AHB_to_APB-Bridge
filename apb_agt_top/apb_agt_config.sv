class apb_agt_config extends uvm_object;
	`uvm_object_utils(apb_agt_config)
	uvm_active_passive_enum is_active=UVM_ACTIVE;

 	 virtual bridge_if vif; 

	
	function new(string name ="apb_agt_config");
	super.new(name);
	endfunction
endclass

