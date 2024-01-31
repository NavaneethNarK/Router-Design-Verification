module top;

	import router_test_pkg::*;

	import uvm_pkg::*;
	int file_handle;
	bit clk=0;
	always #10 clk = ~clk;
	router_if r_if(clk);
	router_if r_if0(clk);
	router_if r_if1(clk);
	router_if r_if2(clk);

	Router1x3 DUV(.clock(r_if.clock),
			.resetn(r_if.resetn),
			.read_enb_0(r_if0.read_enb),
			.read_enb_1(r_if1.read_enb),
		 	.read_enb_2(r_if2.read_enb),
 			.pkt_valid(r_if.pkt_valid),
			.data_in(r_if.data_in), 
			.data_out_0(r_if0.data_out), 
			.data_out_1(r_if1.data_out), 
			.data_out_2(r_if2.data_out), 
			.valid_out_0(r_if0.valid_out), 
			.valid_out_1(r_if1.valid_out), 
			.valid_out_2(r_if2.valid_out), 
			.error(r_if.error), 
			.busy(r_if.busy));

	initial begin
		uvm_config_db #(virtual router_if)::set(null,"*","vif",r_if);
		uvm_config_db #(virtual router_if)::set(null,"*","vif_0",r_if0);
		uvm_config_db #(virtual router_if)::set(null,"*","vif_1",r_if1);
		uvm_config_db #(virtual router_if)::set(null,"*","vif_2",r_if2);
		
		file_handle = $fopen("output.csv", "w");
		$fwrite(file_handle, "resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid,data_in,data_out_0,data_out_1,data_out_2,valid_out_0,valid_out_1,valid_out_2,error,busy\n");
		run_test();
	end
	
	// always @(posedge clk) begin
	// 	$display("data_in: %d\ndata_out0: %d\ndata_out1: %d\ndata_out2: %d",r_if.data_in,r_if0.data_out,r_if1.data_out,r_if2.data_out);
	// 	$display("data_in: %d\nValid_out0: %d\nValid_out1: %d\nValid_out2: %d",r_if.data_in,r_if0.valid_out,r_if1.valid_out,r_if2.valid_out);
	// 	$display("data_in: %d\nread0: %d\nread1: %d\nread2: %d",r_if.data_in,r_if0.read_enb,r_if1.read_enb,r_if2.read_enb);
	// end
	// initial $monitor("data_out 1:%d",r_if0.data_out);
	initial begin
		repeat(200) begin
			@(posedge clk)
			#2;
			$fwrite(file_handle, $sformatf("%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n",r_if.resetn,
																						r_if0.read_enb,
																						r_if1.read_enb,
																						r_if2.read_enb,
																						r_if.pkt_valid,
																						r_if.data_in,
																						r_if0.data_out,
																						r_if1.data_out,
																						r_if2.data_out,
																						r_if0.valid_out,
																						r_if1.valid_out,
																						r_if2.valid_out,
																						r_if.error,
																						r_if.busy));


		end
		$fclose(file_handle);
	end	
endmodule
