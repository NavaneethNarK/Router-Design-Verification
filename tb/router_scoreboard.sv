class router_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(router_scoreboard)
	uvm_tlm_analysis_fifo #(dst_xtn) fifo_dsth[];
	uvm_tlm_analysis_fifo #(src_xtn) fifo_srch;	

	src_xtn src_data;
	dst_xtn dst_data;

	src_xtn src_cov;
	dst_xtn dst_cov;

	int data_verified_count;

	router_env_config m_cfg;

	covergroup router_src_cov;
		SRC_ADDRESS: coverpoint src_cov.address {
			bins a0 = {2'b00};
			bins a1 = {2'b01};
			bins a2 = {2'b10};
		}
		SRC_LENGTH: coverpoint src_cov.length {
			bins short_pkt = {[0:9]};
			bins medium_pkt = {[10:29]};
			bins long_pkt = {[30:63]};
		}
		SRC_ADDRESSxLENGTH: cross SRC_ADDRESS,SRC_LENGTH;
	endgroup

	covergroup router_dst_cov;
		DST_ADDRESS: coverpoint dst_cov.address {
			bins a0 = {2'b00};
			bins a1 = {2'b01};
			bins a2 = {2'b10};
		}
		DST_LENGTH: coverpoint dst_cov.length {
			bins short_pkt = {[0:9]};
			bins medium_pkt = {[10:29]};
			bins long_pkt = {[30:63]};
		}
		DST_ADDRESSxLENGTH: cross DST_ADDRESS,DST_LENGTH;
	endgroup

	extern function new(string name = "router_scoreboard", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
	extern function void check_data(dst_xtn xtn);
endclass

function router_scoreboard::new(string name = "router_scoreboard", uvm_component parent);
	super.new(name,parent);
	router_src_cov = new();
	router_dst_cov = new();
endfunction

function void router_scoreboard::build_phase(uvm_phase phase);
	src_data = src_xtn::type_id::create("src_data");
	dst_data = dst_xtn::type_id::create("dst_data");
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get in scoreboard");
	fifo_dsth = new[m_cfg.no_of_dst];
	foreach(fifo_dsth[i])
		fifo_dsth[i] = new($sformatf("fifo_dsth[%d]",i), this);
   	fifo_srch = new("fifo_srch", this);
endfunction

task router_scoreboard::main_phase(uvm_phase phase);
	fork
		begin
			forever begin
				fifo_srch.get(src_data);
				src_cov = src_data;
				router_src_cov.sample();
			end
		end

		begin
			forever begin
				fork
					begin
						fifo_dsth[0].get(dst_data);
						check_data(dst_data);
						dst_cov = dst_data;
						router_dst_cov.sample();
					end
					begin
						fifo_dsth[1].get(dst_data);
						check_data(dst_data);
						dst_cov = dst_data;
						router_dst_cov.sample();
					end
					begin
						fifo_dsth[2].get(dst_data);
						check_data(dst_data);
						dst_cov = dst_data;
						router_dst_cov.sample();
					end
				join_any
				disable fork;
			end
		end
	join
endtask

function void router_scoreboard::check_data(dst_xtn xtn);
	if(src_data.address == xtn.address)
		`uvm_info("SB", "ADDRESS MATCHED SUCCESSFULLY", UVM_LOW)
	else
		`uvm_error("SB", "ADDRESS MATCHING FAILED")

	if(src_data.length == xtn.length)
		`uvm_info("SB", "LENGTH MATCHED SUCCESSFULLY", UVM_LOW)
	else
		`uvm_error("SB", "LENGTH MATCHING FAILED")


	if(src_data.payload == xtn.payload)
		`uvm_info("SB", "PAYLOAD MATCHED SUCCESSFULLY", UVM_LOW)
	else
		`uvm_error("SB", "PAYLOAD MATCHING FAILED")


	if(src_data.parity == xtn.parity)
		`uvm_info("SB", "PARITY MATCHED SUCCESSFULLY", UVM_LOW)
	else
		`uvm_error("SB", "PARITY MATCHING FAILED")

	data_verified_count++;
endfunction
