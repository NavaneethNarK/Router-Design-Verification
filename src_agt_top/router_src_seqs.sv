class router_src_seqs extends uvm_sequence #(src_xtn);

	`uvm_object_utils(router_src_seqs)
	//src_xtn seqh;
	bit [1:0] addr;
	extern function new(string name = "router_src_seq");
endclass

function router_src_seqs::new(string name = "router_src_seq");
	super.new(name);
endfunction



class router_src_short_pkt_seqs extends router_src_seqs;
	`uvm_object_utils(router_src_short_pkt_seqs)

	extern function new(string name = "router_src_pkt_seqs");
	extern task body();
endclass

function router_src_short_pkt_seqs::new(string name = "router_src_pkt_seqs");
	super.new(name);
endfunction

task router_src_short_pkt_seqs::body();
	if(!uvm_config_db #(bit[1:0])::get(null, get_full_name(), "bit[1:0]", addr))
		`uvm_fatal(get_type_name(), "cannot get the cfg")
	req = src_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {length<10;address==addr;});
	finish_item(req);
endtask



class router_src_medium_pkt_seqs extends router_src_seqs;
	`uvm_object_utils(router_src_medium_pkt_seqs)

	extern function new(string name = "router_src_pkt_seqs");
	extern task body();
endclass

function router_src_medium_pkt_seqs::new(string name = "router_src_pkt_seqs");
	super.new(name);
endfunction

task router_src_medium_pkt_seqs::body();
	if(!uvm_config_db #(bit[1:0])::get(null, get_full_name(), "bit[1:0]", addr))
		`uvm_fatal(get_type_name(), "cannot get the cfg")
	req = src_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {length>9;length<30;address==addr;});
	finish_item(req);
endtask


class router_src_long_pkt_seqs extends router_src_seqs;
	`uvm_object_utils(router_src_long_pkt_seqs)

	extern function new(string name = "router_src_pkt_seqs");
	extern task body();
endclass

function router_src_long_pkt_seqs::new(string name = "router_src_pkt_seqs");
	super.new(name);
endfunction

task router_src_long_pkt_seqs::body();
	if(!uvm_config_db #(bit[1:0])::get(null, get_full_name(), "bit[1:0]", addr))
		`uvm_fatal(get_type_name(), "cannot get the cfg")
	req = src_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {length>29;length<64;address==addr;});
	finish_item(req);
endtask

