class ahb_seqs extends uvm_sequence #(ahb_xtn);
	
	`uvm_object_utils(ahb_seqs);

	bit[31:0] haddr;
	bit[2:0] hburst,hsize;
	bit hwrite;
	bit[9:0] hlength;

	function new(string name ="ahb_seqs");
		super.new(name);
	endfunction
endclass

///////single////////

class single_seqs extends ahb_seqs;
	`uvm_object_utils(single_seqs)

	function new(string name ="single_seqs");
		super.new(name);
	endfunction

	task body();
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {Htrans==2'b10;Hburst==3'b000;})
`uvm_info("AHB_SINGLE",$sformatf("printing from AHB_single_sequence \n %s", req.sprint()),UVM_MEDIUM) 	

	finish_item(req);
	end
	endtask
endclass

/////////// Increment /////////////

class incr_seqs extends ahb_seqs;

	`uvm_object_utils(incr_seqs)

	function new(string name="incr_seqs");
	super.new(name);
	endfunction

	task body();
	req=ahb_xtn::type_id::create("req");
//	repeat(4)
	begin
	start_item(req);

	assert(req.randomize() with {Htrans==2'b11;
			   Hburst inside {1,3,5,7};Hwrite==1'b1;})
	`uvm_info("ROUTR_DST_SEQUENCE",$sformatf("printing from ahb_incr_seqs \n %s", req.sprint()),UVM_MEDIUM) 
	finish_item(req);
	end
	haddr=req.Haddr;
	hwrite=req.Hwrite;
	hsize=req.Hsize;
	hburst=req.Hburst;
	hlength=req.length;

	for(int i=1;i<hlength;i++)
	begin
         start_item(req);
	assert(req.randomize () with {Hwrite==hwrite;
			Hsize==hsize;
			Hburst==hburst;
			Htrans==2'b11;
			Haddr==haddr+2**hsize;});
	finish_item(req);
			haddr=req.Haddr;
	end
	endtask		
endclass

////////////// Wrap /////////////////

class wrap_seqs extends ahb_seqs;

	`uvm_object_utils(wrap_seqs)
	bit[31:0] starting_addr,boundary_addr;

	function new(string name = "wrap_seqs");
	super.new(name);
	endfunction

	task body();
	req=ahb_xtn::type_id::create("req");
//	repeat(4)
	begin
	start_item(req);

	assert(req.randomize() with {Htrans==2'b10;
			   Hburst inside {2,4,6};Hwrite==1'b1;})
	`uvm_info("ROUTR_DST_SEQUENCE",$sformatf("printing from ahb_wrap_seqs \n %s", req.sprint()),UVM_MEDIUM) 
	finish_item(req);
	end
	haddr=req.Haddr;
	hwrite=req.Hwrite;
	hsize=req.Hsize;
	hburst=req.Hburst;
	hlength=req.length;

	starting_addr=(haddr/(hlength*(2**hsize)))*(hlength*(2**hsize));
	boundary_addr=starting_addr+((2**hsize)*(hlength));
	haddr=req.Haddr+(2**hsize);

	for(int i=1;i<hlength;i++)
	begin
	if(haddr==boundary_addr)
		haddr=starting_addr;
         start_item(req);
	assert(req.randomize () with {Hwrite==hwrite;
				Hsize==hsize;
				Hburst==hburst;
				Htrans==2'b11;
				Haddr==haddr;});
	finish_item(req);
	haddr=req.Haddr+(2**hsize);
	end
endtask
endclass



