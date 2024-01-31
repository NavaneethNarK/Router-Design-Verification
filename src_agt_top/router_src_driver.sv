class router_src_driver extends uvm_driver #(src_xtn);
	
	`uvm_component_utils(router_src_driver)
	
	virtual router_if.SDR_MP vif;

	router_src_agent_config m_cfg;

	extern function new(string name = "router_src_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
	extern task send_to_dut(src_xtn xtn);
	extern task reset_phase(uvm_phase phase);
	extern function void extract_phase(uvm_phase phase);
endclass

function router_src_driver::new(string name = "router_src_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_src_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get in src drv");
endfunction

function void router_src_driver::connect_phase(uvm_phase phase);
	vif = m_cfg.vif;
endfunction

task router_src_driver::main_phase(uvm_phase phase);
	phase.raise_objection(this);
	repeat(10) begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done(req);
	end
	phase.drop_objection(this);
endtask

task router_src_driver::reset_phase(uvm_phase phase);
	phase.raise_objection(this);
	@(vif.sdr_cb)
	vif.sdr_cb.resetn <= 0;
	@(vif.sdr_cb)
	vif.sdr_cb.resetn <= 1;
	phase.drop_objection(this);
endtask

task router_src_driver::send_to_dut(src_xtn xtn);
	`uvm_info("SRCDRIVER","started send to dut",UVM_MEDIUM)
	xtn.print();
	@(vif.sdr_cb);
	wait (!vif.sdr_cb.busy)
	vif.sdr_cb.pkt_valid <=1;
	vif.sdr_cb.data_in <= {xtn.length,xtn.address};
	@(vif.sdr_cb);
	@(vif.sdr_cb);
	foreach(xtn.payload[i]) begin
		vif.sdr_cb.data_in <= xtn.payload[i];
		//$display("DRIVER: ",xtn.payload[i]);
		wait (!vif.sdr_cb.busy);
		@(vif.sdr_cb);
	end
	
	wait (!vif.sdr_cb.busy)
	vif.sdr_cb.pkt_valid <= 0;
	vif.sdr_cb.data_in <= xtn.parity;
	repeat(3) 
		@(vif.sdr_cb);
endtask

function void router_src_driver::extract_phase(uvm_phase phase);
	$display("extract phase");
endfunction
