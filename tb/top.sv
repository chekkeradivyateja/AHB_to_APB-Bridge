module top;

	  import uvm_pkg::*;
   	 import test_pkg::*;

	 bit clock;
  	always #5 clock = ~clock;
  	//Instantiate interfaces
  	bridge_if in0(clock);
  	bridge_if in1(clock);


   rtl_top DUT(.Hclk(clock), .Hresetn(in0.Hresetn), .Htrans(in0.Htrans), .Hsize(in0.Hsize), .Hreadyin(in0.Hreadyin), .Hwdata(in0.Hwdata), .Haddr(in0.Haddr), .Hwrite(in0.Hwrite), .Prdata(in1.Prdata), .Hrdata(in0.Hrdata), .Hresp(in0.Hresp), .Hreadyout(in0.Hreadyout), .Pselx(in1.Psel), .Pwrite(in1.Pwrite), .Penable(in1.Penable), .Paddr(in1.Paddr), .Pwdata(in1.Pwdata));
 
  initial
   begin
     `ifdef VCS
       $fsdbDumpvars(0,top);
     `endif
     //set VIF
     uvm_config_db #(virtual bridge_if)::set(null, "*", "vif_ahb", in0);
     uvm_config_db #(virtual bridge_if)::set(null, "*", "vif_apb", in1);	 
     
     run_test();
   end
endmodule

