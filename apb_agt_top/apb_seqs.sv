class apb_seqs extends uvm_sequence #(apb_xtn);
	`uvm_object_utils(apb_seqs)
	
	function new(string name="apb_seqs");
		super.new(name);
	endfunction


	task body();
		req=apb_xtn::type_id::create("req");
		endtask
endclass
