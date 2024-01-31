class router_dst_agent_config extends uvm_object;

	`uvm_object_utils(router_dst_agent_config)

	uvm_active_passive_enum is_active = UVM_ACTIVE;
	virtual router_if vif;
	int no_of_dst = 3;	

	extern function new(string name = "router_dst_agent_config");
endclass

function router_dst_agent_config::new(string name = "router_dst_agent_config");
	super.new(name);
endfunction

