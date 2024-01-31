class router_virtual_seqs extends uvm_sequence #(uvm_sequence_item);

	`uvm_object_utils(router_virtual_seqs)

	router_src_sequencer src_seqrh;
	router_dst_sequencer dst_seqrh[];
	
	router_virtual_sequencer vseqrh;

	router_src_short_pkt_seqs short_seqsh;
	router_src_medium_pkt_seqs medium_seqsh;
	router_src_long_pkt_seqs long_seqsh;

	router_dst_delay_seqs delay_seqsh[];

	router_env_config m_cfg;

	bit [1:0] addr;

	extern function new(string name = "router_virtual_seqs");
	extern function build_phase(uvm_phase phase);
	extern task body();
endclass

function router_virtual_seqs::new(string name = "router_virtual_seqs");
	super.new(name);
endfunction

task router_virtual_seqs::body();
	assert($cast(vseqrh,m_sequencer))
	else
		`uvm_error("BODY","Error in $cast of virtual sequencer in v seqs")
	
	if(!uvm_config_db #(router_env_config)::get(get_sequencer(),"","router_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot use get in env")
	src_seqrh = vseqrh.src_seqrh;
	dst_seqrh = vseqrh.dst_seqrh;
	delay_seqsh = new[m_cfg.no_of_dst];
endtask



class router_virtual_short_pkt_seqs extends router_virtual_seqs;

	`uvm_object_utils(router_virtual_short_pkt_seqs)

	extern function new(string name = "router_virtual_short_pkt_seqs");
	extern task body();
endclass

function router_virtual_short_pkt_seqs::new(string name = "router_virtual_short_pkt_seqs");
	super.new(name);
endfunction

task router_virtual_short_pkt_seqs::body();
	super.body();
	if(!uvm_config_db #(bit[1:0])::get(null, get_full_name(), "bit[1:0]", addr))
		`uvm_fatal(get_type_name(), "cannot get cfg")
	short_seqsh = router_src_short_pkt_seqs::type_id::create("router_src_seqs");
	fork
		short_seqsh.start(src_seqrh);
		begin
			if(addr == 2'b00) begin
				delay_seqsh[0] = router_dst_delay_seqs::type_id::create($sformatf("router_dst_delay_seqs[%0d]",0));
				delay_seqsh[0].start(dst_seqrh[0]);
			end
			if(addr == 2'b01) begin
				delay_seqsh[1] = router_dst_delay_seqs::type_id::create($sformatf("router_dst_delay_seqs[%0d]",1));
				delay_seqsh[1].start(dst_seqrh[1]);
			end
			if(addr == 2'b10) begin
				delay_seqsh[2] = router_dst_delay_seqs::type_id::create($sformatf("router_dst_delay_seqs[%0d]",2));
				delay_seqsh[2].start(dst_seqrh[2]);
			end
		end
	join
endtask



class router_virtual_medium_pkt_seqs extends router_virtual_seqs;

	`uvm_object_utils(router_virtual_medium_pkt_seqs)

	extern function new(string name = "router_virtual_medium_pkt_seqs");
	extern task body();
endclass

function router_virtual_medium_pkt_seqs::new(string name = "router_virtual_medium_pkt_seqs");
	super.new(name);
endfunction

task router_virtual_medium_pkt_seqs::body();
	super.body();
	if(!uvm_config_db #(bit[1:0])::get(null, get_full_name(), "bit[1:0]", addr))
		`uvm_fatal(get_type_name(), "cannot get cfg")
	medium_seqsh = router_src_medium_pkt_seqs::type_id::create("router_src_seqs");
	fork
		medium_seqsh.start(src_seqrh);
		begin
			if(addr == 2'b00) begin
				delay_seqsh[0] = router_dst_delay_seqs::type_id::create($sformatf("router_dst_delay_seqs[%0d]",0));
				delay_seqsh[0].start(dst_seqrh[0]);
			end
			if(addr == 2'b01) begin
				delay_seqsh[1] = router_dst_delay_seqs::type_id::create($sformatf("router_dst_delay_seqs[%0d]",1));
				delay_seqsh[1].start(dst_seqrh[1]);
			end
			if(addr == 2'b10) begin
				delay_seqsh[2] = router_dst_delay_seqs::type_id::create($sformatf("router_dst_delay_seqs[%0d]",2));
				delay_seqsh[2].start(dst_seqrh[2]);
			end
		end
	join
endtask





class router_virtual_long_pkt_seqs extends router_virtual_seqs;

	`uvm_object_utils(router_virtual_long_pkt_seqs)

	extern function new(string name = "router_virtual_long_pkt_seqs");
	extern task body();
endclass

function router_virtual_long_pkt_seqs::new(string name = "router_virtual_long_pkt_seqs");
	super.new(name);
endfunction

task router_virtual_long_pkt_seqs::body();
	super.body();
	if(!uvm_config_db #(bit[1:0])::get(null, get_full_name(), "bit[1:0]", addr))
		`uvm_fatal(get_type_name(), "cannot get cfg")
	long_seqsh = router_src_long_pkt_seqs::type_id::create("router_src_seqs");
	fork
		long_seqsh.start(src_seqrh);
		begin
			if(addr == 2'b00) begin
				delay_seqsh[0] = router_dst_delay_seqs::type_id::create($sformatf("router_dst_delay_seqs[%0d]",0));
				delay_seqsh[0].start(dst_seqrh[0]);
			end
			if(addr == 2'b01) begin
				delay_seqsh[1] = router_dst_delay_seqs::type_id::create($sformatf("router_dst_delay_seqs[%0d]",1));
				delay_seqsh[1].start(dst_seqrh[1]);
			end
			if(addr == 2'b10) begin
				delay_seqsh[2] = router_dst_delay_seqs::type_id::create($sformatf("router_dst_delay_seqs[%0d]",2));
				delay_seqsh[2].start(dst_seqrh[2]);
			end
		end
	join
endtask

