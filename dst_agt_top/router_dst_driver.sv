class router_dst_driver extends uvm_driver #(dst_xtn);
	
	`uvm_component_utils(router_dst_driver)
	
	virtual router_if.DDR_MP vif;

	router_dst_agent_config m_cfg;

	extern function new(string name = "router_dst_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
	extern task send_to_dut(dst_xtn xtn);
endclass

function router_dst_driver::new(string name = "router_dst_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_dst_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(router_dst_agent_config)::get(this,"","router_dst_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get in dst drv");
endfunction

function void router_dst_driver::connect_phase(uvm_phase phase);
	vif = m_cfg.vif;
endfunction

task router_dst_driver::main_phase(uvm_phase phase);
	forever begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	end
endtask

task router_dst_driver::send_to_dut(dst_xtn xtn);
	`uvm_info("ROUTER_DST_DRIVER","sending dst inputs",UVM_LOW)
	@(vif.ddr_cb);
	$display("vif.ddr_cb");
	wait(vif.ddr_cb.valid_out)
	$display("vif.ddr_cb.valid_out");
	repeat(xtn.no_of_cycles)
		@(vif.ddr_cb);
	vif.ddr_cb.read_enb <=1;
	@(vif.ddr_cb);
	wait(!vif.ddr_cb.valid_out)
	
	vif.ddr_cb.read_enb <=1;
	@(vif.ddr_cb);
	vif.ddr_cb.read_enb <=0;
	repeat(2)
		@(vif.ddr_cb);

endtask
