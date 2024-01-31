class router_dst_agt_top extends uvm_env;
	
	`uvm_component_utils(router_dst_agt_top)

	router_env_config m_cfg;
	
	router_dst_agent agenth[];

	extern function new(string name = "router_dst_agt_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass

function router_dst_agt_top::new(string name = "router_dst_agt_top",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_dst_agt_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get in router agent top")
	agenth = new[m_cfg.no_of_dst];
	for(int i = 0; i < m_cfg.no_of_dst; i++)
		agenth[i] = router_dst_agent::type_id::create($sformatf("router_dst_agent[%0d]",i),this);
endfunction


