class router_src_agt_top extends uvm_env;
	
	`uvm_component_utils(router_src_agt_top)
	
	router_src_agent agenth;
	extern function new(string name = "router_src_agt_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void start_of_simulation_phase(uvm_phase phase);
endclass

function router_src_agt_top::new(string name = "router_src_agt_top",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_src_agt_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	agenth = router_src_agent::type_id::create("router_src_agent",this);	
endfunction

function void router_src_agt_top::start_of_simulation_phase(uvm_phase phase);
	uvm_top.print_topology;
endfunction
	


