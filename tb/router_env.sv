class router_env extends uvm_env;

	`uvm_component_utils(router_env)
	
	router_src_agt_top sagt_top;
	router_dst_agt_top dagt_top;

	router_virtual_sequencer v_sequencer;
	
	router_scoreboard sb;

	router_env_config m_cfg;
	
	extern function new(string name = "router_env", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

function router_env::new(string name = "router_env", uvm_component parent);
	super.new(name,parent);
endfunction

function  void router_env::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot use get in env")
	
	if(m_cfg.has_src) begin
		m_cfg.m_src_agt_cfg = router_src_agent_config::type_id::create("router_src_agent_config");
		if(!uvm_config_db #(virtual router_if)::get(this,"","vif",m_cfg.m_src_agt_cfg.vif))
			`uvm_fatal("CONFIG","cannot get vif in env");
		sagt_top = router_src_agt_top::type_id::create("router_src_agt_top",this);
		uvm_config_db #(router_src_agent_config)::set(this,"*","router_src_agent_config",m_cfg.m_src_agt_cfg);
	end

	if(m_cfg.has_dst) begin
		for (int i = 0;i<m_cfg.no_of_dst;i++) begin
			m_cfg.m_dst_agt_cfg[i] = router_dst_agent_config::type_id::create($sformatf("router_dst_agent_config_%d",i));
			if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("vif_%0d",i),m_cfg.m_dst_agt_cfg[i].vif))
				`uvm_fatal("CONFIG","cannot get vif in env");
			uvm_config_db #(router_dst_agent_config)::set(this,$sformatf("router_dst_agt_top.router_dst_agent[%0d]*",i),"router_dst_agent_config",m_cfg.m_dst_agt_cfg[i]);
		end
		dagt_top = router_dst_agt_top::type_id::create("router_dst_agt_top", this);
		
	end
	super.build_phase(phase);
	if(m_cfg.has_virtual_sequencer) begin
		v_sequencer = router_virtual_sequencer::type_id::create("router_virtual_sequencer", this);
	end

	if(m_cfg.has_scoreboard) begin
		sb = router_scoreboard::type_id::create("router_scoreboard", this);
	end
endfunction

function void router_env::connect_phase(uvm_phase phase);
	if(m_cfg.has_virtual_sequencer) begin
		if(m_cfg.has_src) begin
			v_sequencer.src_seqrh = sagt_top.agenth.seqrh;
		end
		if(m_cfg.has_dst) begin
			foreach(v_sequencer.dst_seqrh[i])
				v_sequencer.dst_seqrh[i] = dagt_top.agenth[i].seqrh;
		end
	end
	if(m_cfg.has_scoreboard) begin
		sagt_top.agenth.monh.monitor_port.connect(sb.fifo_srch.analysis_export);
		foreach(dagt_top.agenth[i])
			dagt_top.agenth[i].monh.monitor_port.connect(sb.fifo_dsth[i].analysis_export);
	end
endfunction
