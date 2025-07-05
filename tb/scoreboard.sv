class sb extends uvm_scoreboard;
`uvm_component_utils(sb)
ahb_xtn ahb_h;
apb_xtn apb_h;
uvm_tlm_analysis_fifo #(ahb_xtn) ahb_fifo[];
uvm_tlm_analysis_fifo#(apb_xtn) apb_fifo[];
env_config m_cfg;

function new(string name="scoreboard",uvm_component parent);
super.new(name,parent); 
ahb=new();
apb=new();
endfunction

virtual function void build_phase(uvm_phase phase);
if(!uvm_config_db#(env_config)::get(this,"","env_config",m_cfg))
`uvm_fatal(get_type_name(),"getting is failed")
ahb_fifo=new[m_cfg.no_of_master_agents];
apb_fifo=new[m_cfg.no_of_slave_agents];

       ahb_h = ahb_xtn::type_id::create("ahb_h");
       apb_h = apb_xtn::type_id::create("apb_h");

       foreach(ahb_fifo[i])
           ahb_fifo[i] = new($sformatf("ahb_fifo[%0d]", i), this);
       foreach(ahb_fifo[i])
           apb_fifo[i] = new($sformatf("apb_fifo[%0d]", i), this);

endfunction

covergroup ahb;
HADDR:coverpoint ahb_h.Haddr{
	bins slave1={[32'h8000_0000:32'h8000_03ff]};
	bins slave2={[32'h8400_0000:32'h8400_03ff]};
	bins slave3={[32'h8800_0000:32'h8800_03ff]};
	bins slave4={[32'h8c00_0000:32'h8c00_03ff]};
		}
HSIZE:coverpoint ahb_h.Hsize{
	bins one_byte={0};
	bins two_byte={1};
	bins four_byte={2};
  		}
HWRITE:coverpoint ahb_h.Hwrite{
	bins write0={0};
	bins write1={1};
	  	}
HTRANS:coverpoint ahb_h.Htrans{
	bins nseq={2};
	bins seq={3};
  		}

AHP:cross HADDR,HSIZE,HWRITE,HTRANS;

endgroup


covergroup apb;
PSELX:coverpoint apb_h.Psel{
	bins one={1};
	bins two={2};
	bins four={4};
	bins eight={8};
		}
PWRITE:coverpoint apb_h.Pwrite{
	bins writep0={0};
	bins writep1={1};
	  	}
PADDR:coverpoint apb_h.Paddr{
	bins mastre1={[32'h8000_0000:32'h8000_03ff]};
	bins master2={[32'h8400_0000:32'h8400_03ff]};
	bins master3={[32'h8800_0000:32'h8800_03ff]};
	bins master4={[32'h8c00_0000:32'h8c00_03ff]};
		}

APB:cross PSELX,PWRITE,PADDR;

endgroup

virtual task run_phase(uvm_phase phase);
forever
begin
	fork
		begin
			ahb_fifo[0].get(ahb_h);
		$display("from ahb scorboard --$$$$$$$$$$$$$$$$$$$$$$");
		//		`uvm_info("SCORE_BOARD",$sformatf("printing from scoreboard \n %s",ahb_h.sprint()),UVM_LOW)

			ahb_h.print();
			ahb.sample();
		end

		begin
			apb_fifo[0].get(apb_h);
	$display("from apb scorboard---$$$$$$$$$$$$$$$$$$$$$$");
//				`uvm_info("SCORE_BOARD",$sformatf("printing from scoreboard \n %s",apb_h.sprint()),UVM_LOW)

			apb_h.print();
			apb.sample();
		end
	join
chec(ahb_h,apb_h);
end
endtask


task compar(int Haddr,Paddr,Hdata,Pdata);

if(Haddr==Paddr)
	$display("addr is matched");
else 
	begin
	$display("addr is not matched");
//	$display("Haddr,Paddr");
	end
if(Hdata==Pdata)
	$display("data is matched");
else 
	begin
	$display("data is not matched");
//	$display("Hdata,Pdata");
	end

endtask
task chec(ahb_xtn ahb_h,apb_xtn apb_h);
	if(ahb_h.Hwrite==1)
		begin
			if(ahb_h.Hsize==2'b00)
			begin
			if(ahb_h.Haddr[1:0]==2'b00)
			compar(ahb_h.Haddr,apb_h.Paddr,ahb_h.Hwdata[7:0],apb_h.Pwdata[7:0]);
			if(ahb_h.Haddr[1:0]==2'b01)
			compar(ahb_h.Haddr,apb_h.Paddr,ahb_h.Hwdata[15:8],apb_h.Pwdata[15:8]);
			if(ahb_h.Haddr[1:0]==2'b10)
			compar(ahb_h.Haddr,apb_h.Paddr,ahb_h.Hwdata[23:16],apb_h.Pwdata[23:16]);
			if(ahb_h.Haddr[1:0]==2'b11)
			compar(ahb_h.Haddr,apb_h.Paddr,ahb_h.Hwdata[31:24],apb_h.Pwdata[31:24]);
		end
	if(ahb_h.Hsize==2'b01)
		begin
			if(ahb_h.Haddr[1:0]==2'b00)
			compar(ahb_h.Haddr,apb_h.Paddr,ahb_h.Hwdata[15:0],apb_h.Pwdata[15:0]);
			if(ahb_h.Haddr[1:0]==2'b10)
			compar(ahb_h.Haddr,apb_h.Paddr,ahb_h.Hwdata[31:16],apb_h.Pwdata[31:16]);
		end
	if(ahb_h.Hsize==2'b10)
		begin
			if(ahb_h.Haddr[1:0]==2'b10)
			compar(ahb_h.Haddr,apb_h.Paddr,ahb_h.Hwdata[31:0],apb_h.Pwdata[31:0]);
		end
end

if(ahb_h.Hwrite==0)
		begin
			if(ahb_h.Hsize==2'b00)
			begin
			if(ahb_h.Haddr[1:0]==2'b00)
			compar(ahb_h.Haddr,apb_h.Paddr,ahb_h.Hrdata[7:0],apb_h.Prdata[7:0]);
			if(ahb_h.Haddr[1:0]==2'b01)
			compar(ahb_h.Haddr,apb_h.Paddr,ahb_h.Hrdata[15:8],apb_h.Prdata[15:8]);
			if(ahb_h.Haddr[1:0]==2'b10)
			compar(ahb_h.Haddr,apb_h.Paddr,ahb_h.Hrdata[23:16],apb_h.Prdata[23:16]);
			if(ahb_h.Haddr[1:0]==2'b11)
			compar(ahb_h.Haddr,apb_h.Paddr,ahb_h.Hrdata[31:24],apb_h.Prdata[31:24]);
		end
	if(ahb_h.Hsize==2'b01)
		begin
			if(ahb_h.Haddr[1:0]==2'b00)
			compar(ahb_h.Haddr,apb_h.Paddr,ahb_h.Hrdata[15:0],apb_h.Prdata[15:0]);
			if(ahb_h.Haddr[1:0]==2'b10)
			compar(ahb_h.Haddr,apb_h.Paddr,ahb_h.Hrdata[31:16],apb_h.Prdata[31:16]);
		end
	if(ahb_h.Hsize==2'b10)
		begin
			if(ahb_h.Haddr[1:0]==2'b10)
			compar(ahb_h.Haddr,apb_h.Paddr,ahb_h.Hrdata[31:0],apb_h.Prdata[31:0]);
		end
end

endtask
endclass











