class router_env_config extends uvm_object;
	
	`uvm_object_utils(router_env_config)
	
	bit has_dst = 1;
	bit has_src = 1;

	bit has_virtual_sequencer = 1;
	
	router_dst_agent_config m_dst_agt_cfg [];
	router_src_agent_config m_src_agt_cfg;
	
	bit has_scoreboard = 1;
	
	int no_of_dst = 3;
		
	extern function new(string name = "router_env_config");
endclass

function router_env_config::new(string name = "router_env_config");
	super.new(name);
	m_dst_agt_cfg = new[no_of_dst];
endfunction


