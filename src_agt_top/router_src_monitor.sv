class router_src_monitor extends uvm_monitor;

	`uvm_component_utils(router_src_monitor)

	virtual router_if.SMON_MP vif;
	
	router_src_agent_config m_cfg;
	
	src_xtn xtn;
	
	uvm_analysis_port#(src_xtn)monitor_port;

	extern function new( string name = "router_src_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
	extern task collect_data();
endclass

function router_src_monitor::new(string name = "router_src_monitor", uvm_component parent);
	super.new(name,parent);
	monitor_port =  new("monitor_port",this);
endfunction

function void router_src_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get in src mon")
endfunction

function void router_src_monitor::connect_phase(uvm_phase phase);
	vif = m_cfg.vif;
endfunction

task router_src_monitor::main_phase(uvm_phase phase);
	forever
		collect_data();
endtask

task router_src_monitor::collect_data();
	`uvm_info("SRCMONITOR","done monitoring",UVM_MEDIUM)
	xtn = src_xtn::type_id::create("src_monitor_data");
	@(vif.smon_cb);
	wait (!vif.smon_cb.busy && vif.smon_cb.pkt_valid)
	{xtn.length,xtn.address} = vif.smon_cb.data_in;
	xtn.payload = new[xtn.length];
	@(vif.smon_cb);
	@(vif.smon_cb);
	foreach(xtn.payload[i])begin
		wait (vif.smon_cb.busy == 0);
		@(vif.smon_cb);
		xtn.payload[i] = vif.smon_cb.data_in;
		//$display("MONITOR: ",vif.smon_cb.data_in);
	end
		wait (!vif.smon_cb.busy && !vif.smon_cb.pkt_valid)
	xtn.parity = vif.smon_cb.data_in;
	repeat (2)
		@(vif.smon_cb);
	xtn.error = vif.smon_cb.error;
	`uvm_info("SRCMONITOR","done monitoring",UVM_MEDIUM)
	monitor_port.write(xtn);
	xtn.print();
endtask
