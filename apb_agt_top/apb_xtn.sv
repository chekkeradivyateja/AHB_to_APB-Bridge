class apb_xtn extends uvm_sequence_item;
	`uvm_object_utils(apb_xtn)
	
	bit Presetn;
	bit Penable;
	bit [31:0] Paddr;
	bit Pwrite;
	bit [31:0] Prdata;
	bit [31:0] Pwdata;
	bit [3:0]Psel;

	function new(string name="apb_xtn");
		super.new(name);
	endfunction

	function void do_print(uvm_printer printer);
		super.do_print(printer);
				
		printer.print_field("Presetn",	this.Presetn,	1,	UVM_BIN);
		printer.print_field("Penable",	this.Penable,	1,	UVM_DEC);
		printer.print_field("Paddr",	this.Paddr,	32,	UVM_HEX);
		printer.print_field("Pwrite",	this.Pwrite,	1,	UVM_DEC);
		printer.print_field("Prdata",	this.Prdata,	32,	UVM_DEC);
		printer.print_field("Pwdata",	this.Pwdata,	32,	UVM_DEC);
		printer.print_field("psel",	this.Psel,	4,	UVM_DEC);

	endfunction
	
endclass	
