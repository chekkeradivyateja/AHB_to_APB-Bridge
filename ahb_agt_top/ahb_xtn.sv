class ahb_xtn extends uvm_sequence_item;

	`uvm_object_utils(ahb_xtn)

	rand bit  [1:0] Htrans;
	rand bit [2:0]Hsize;    
	rand bit [31:0]Hwdata; 
	rand bit [31:0]Haddr;
	rand bit Hwrite;
	bit  Hresetn;
	bit Hreadyin;
	rand bit[2:0] Hburst;
	bit [31:0]Hrdata;
	bit [1:0]Hresp;
	bit Hreadyout;
	rand bit[9:0] length;

	function new(string name = "ahb_xtn");
	super.new(name);
	endfunction

	constraint valid_Haddr {soft Haddr inside {[32'h8000_0000:32'h8000_03ff],
						[32'h8400_0000:32'h8400_03ff],
						[32'h8800_0000:32'h8800_03ff],
						[32'h8c00_0000:32'h8c00_03ff]};}
	constraint valid_Hsize{Hsize inside {0,1};}
	constraint aligned{(Hsize==2'b01)->Haddr%2==0;
			(Hsize==2'b10) -> Haddr%4==0;}
	constraint valid_length{(Hburst==3'b000)->length==1;
				(Hburst==3'b010)->length==4;
				(Hburst==3'b011)->length==4;
				(Hburst==3'b100)->length==8;
				(Hburst==3'b101)->length==8;
				(Hburst==3'b110)->length==16;
				(Hburst==3'b111)->length==16;}
	constraint c2{(Haddr%1024+(length*(2**Hsize)))<=1024;} //valid length should not cross 1024 (0-1023) 
//	$display("return value is %p", c2);

	function void do_print(uvm_printer printer);
	super.do_print(printer);

	printer.print_field("Hresetn",this.Hresetn,1,UVM_BIN);
	printer.print_field("Htrans",this.Htrans,2,UVM_DEC);
	printer.print_field("Haddr",this.Haddr,32,UVM_HEX);
	printer.print_field("Hburst",this.Hburst,3,UVM_DEC);
	printer.print_field("Hsize",this.Hsize,3,UVM_DEC);
	printer.print_field("Hwrite",this.Hwrite,1,UVM_DEC);
	printer.print_field("Hreadyin",this.Hreadyin,1,UVM_DEC);
	printer.print_field("Hreadyout",this.Hreadyout,1,UVM_DEC);	
	printer.print_field("Hwdata",this.Hwdata,32,UVM_DEC);
	printer.print_field("Hrdata",this.Hrdata,32,UVM_DEC);
        printer.print_field("Hresp",	this.Hresp,	2,	 UVM_BIN);
	printer.print_field("length",	this.length,	10,	 UVM_BIN);

	endfunction
endclass

	
