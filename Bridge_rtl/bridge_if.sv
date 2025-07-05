interface bridge_if(input bit clk);

//---------------------------------------------AHB SIGNALS--------------------------------------------//
logic Hresetn,Hwrite,Hreadyin,Hreadyout;
logic[1:0]Htrans,Hresp;
logic[31:0]Hwdata,Hrdata,Haddr;
logic[2:0]Hsize,Hburst;

//---------------------------------------------APB SIGNALS-------------------------------------------//
logic Penable,Prstn,Pwrite;
logic [3:0]Psel;
logic [31:0] Paddr,Prdata,Pwdata;


//-----------------------------------master_drv clocking block---------------------------------------//
clocking m_drv @(posedge clk);
	default input #1 output #1;
	output   Hresetn,Hwrite,Htrans,Hwdata,Haddr,Hsize,Hburst,Hreadyin;
	input Hrdata,Hresp,Hreadyout;
endclocking


//---------------------------------master_mon clocking block----------------------------------//
clocking m_mon @(posedge clk);
	default input #1 output #1;
	input Hresetn,Hwrite,Htrans,Hwdata,Haddr,Hsize,Hburst,Hrdata,Hresp,Hreadyout;
endclocking 


//-----------------------------------slave_drv clocking block-----------------------------//
clocking s_drv @(posedge clk);
	default input #1 output #1;
	output Prdata;
	input Penable,Pwrite,Pwdata,Paddr,Psel;
endclocking 

//-----------------------------------slave_mon clocking block-----------------------------//
clocking s_mon @(posedge clk);
	default input #1 output #1;
	input Prdata,Penable,Pwrite,Pwdata,Paddr,Psel;
endclocking



modport M_DRV(clocking m_drv);
modport S_DRV(clocking s_drv);
modport M_MON(clocking m_mon);
modport S_MON(clocking s_mon);
 

endinterface

