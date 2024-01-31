class router_dst_monitor extends uvm_monitor;

	`uvm_component_utils(router_dst_monitor)

	virtual router_if.DMON_MP vif;

	dst_xtn dst_monitor_data;
	
	uvm_analysis_port#(dst_xtn)monitor_port;

	router_dst_agent_config m_cfg;

	extern function new( string name = "router_dst_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
	extern task collect_data();	
endclass

function router_dst_monitor::new(string name = "router_dst_monitor", uvm_component parent);
	super.new(name,parent);
	monitor_port =  new("monitor_port",this);
endfunction

function void router_dst_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(router_dst_agent_config)::get(this,"","router_dst_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get in dst mon")
endfunction

function void router_dst_monitor::connect_phase(uvm_phase phase);
	vif = m_cfg.vif;
endfunction

task router_dst_monitor::main_phase(uvm_phase phase);
	forever begin
		collect_data();
	end
endtask

task router_dst_monitor::collect_data();
	 dst_monitor_data = dst_xtn::type_id::create("dst_monitor_data");
	 @(vif.dmon_cb);
	 wait(vif.dmon_cb.read_enb);
	 #1;
	@(vif.dmon_cb);
	 {dst_monitor_data.length,dst_monitor_data.address} = vif.dmon_cb.data_out;
	 dst_monitor_data.payload = new[dst_monitor_data.length];
	 @(vif.dmon_cb);
	 foreach(dst_monitor_data.payload[i]) begin
		dst_monitor_data.payload[i] = vif.dmon_cb.data_out;
		@(vif.dmon_cb);
	 end
	 dst_monitor_data.parity = vif.dmon_cb.data_out;
	 @(vif.dmon_cb);
	 dst_monitor_data.print();
	 monitor_port.write(dst_monitor_data);
endtask