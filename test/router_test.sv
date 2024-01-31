class router_test extends uvm_test;

	`uvm_component_utils(router_test)

	router_env 		router_envh;
	router_env_config 	m_env_cfg;	

	bit [1:0] addr;

	extern function new(string name = "router_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass

function router_test::new(string name = "router_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void router_test::build_phase(uvm_phase phase);
	m_env_cfg = router_env_config::type_id::create("router_env_config");
	uvm_config_db #(router_env_config)::set(this,"*","router_env_config",m_env_cfg);
	super.build();
	router_envh = router_env::type_id::create("ram_envh",this);
endfunction







class router_short_pkt_test extends router_test;
	`uvm_component_utils(router_short_pkt_test)
	router_virtual_short_pkt_seqs vseqsh;

	extern function new(string name = "router_short_pkt_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
endclass

function router_short_pkt_test::new(string name = "router_short_pkt_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void router_short_pkt_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task router_short_pkt_test::main_phase(uvm_phase phase);
	phase.raise_objection(this);
	repeat(10) begin
		addr = {$random}%3;
		uvm_config_db #(bit[1:0])::set(this, "*", "bit[1:0]", addr);
		vseqsh = router_virtual_short_pkt_seqs::type_id::create("router_virtual_seqs");
		vseqsh.start(router_envh.v_sequencer);
	end
	phase.drop_objection(this);
endtask	




class router_medium_pkt_test extends router_test;
	`uvm_component_utils(router_medium_pkt_test)
	router_virtual_medium_pkt_seqs vseqsh;

	extern function new(string name = "router_medium_pkt_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
endclass

function router_medium_pkt_test::new(string name = "router_medium_pkt_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void router_medium_pkt_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task router_medium_pkt_test::main_phase(uvm_phase phase);
	phase.raise_objection(this);
	repeat(10) begin
		addr = {$random}%3;
		uvm_config_db #(bit[1:0])::set(this, "*", "bit[1:0]", addr);
		vseqsh = router_virtual_medium_pkt_seqs::type_id::create("router_virtual_seqs");
		vseqsh.start(router_envh.v_sequencer);
	end
	phase.drop_objection(this);
endtask	

class router_long_pkt_test extends router_test;
	`uvm_component_utils(router_long_pkt_test)
	router_virtual_long_pkt_seqs vseqsh;

	extern function new(string name = "router_long_pkt_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
endclass

function router_long_pkt_test::new(string name = "router_long_pkt_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void router_long_pkt_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task router_long_pkt_test::main_phase(uvm_phase phase);
	phase.raise_objection(this);
	repeat(10) begin
		addr = {$random}%3;
		uvm_config_db #(bit[1:0])::set(this, "*", "bit[1:0]", addr);
		vseqsh = router_virtual_long_pkt_seqs::type_id::create("router_virtual_seqs");
		vseqsh.start(router_envh.v_sequencer);
	end
	phase.drop_objection(this);
endtask	
