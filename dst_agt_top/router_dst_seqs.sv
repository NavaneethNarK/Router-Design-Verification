class router_dst_seqs extends uvm_sequence #(dst_xtn);

	`uvm_object_utils(router_dst_seqs)

	extern function new(string name = "router_dst_seqs");
endclass

function router_dst_seqs::new(string name = "router_dst_seqs");
	super.new(name);
endfunction

class router_dst_delay_seqs extends router_dst_seqs;
	`uvm_object_utils(router_dst_delay_seqs)

	extern function new(string name = "router_dst_delay_seqs");
	extern task body();
endclass

function router_dst_delay_seqs::new(string name = "router_dst_delay_seqs");
	super.new(name);
endfunction

task router_dst_delay_seqs::body();
			req = dst_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {no_of_cycles>0;no_of_cycles<2;});
			finish_item(req);
endtask