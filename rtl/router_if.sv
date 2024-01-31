interface router_if(input bit clock);
	logic [7:0] data_in;
	logic [7:0] data_out;
	logic resetn;
	logic error;
	logic busy;
	logic read_enb;
	logic valid_out;
	logic pkt_valid;

	clocking sdr_cb@(posedge clock);
		default input #1 output #1;
		output data_in;
		output pkt_valid;
		output resetn;
		input error;
		input busy;
	endclocking

	clocking ddr_cb@(posedge clock);
		default input #1 output #1;
		output read_enb;
		input valid_out;
	endclocking

	clocking smon_cb@(posedge clock);
		default input #1 output #1;
		input data_in;
		input pkt_valid;
		input resetn;
		input error;
		input busy;
	endclocking

	clocking dmon_cb@(posedge clock);
		default input #1 output #1;
		input data_out;
		input read_enb;
	endclocking

	modport SDR_MP(clocking sdr_cb);
	modport DDR_MP(clocking ddr_cb);
	modport SMON_MP(clocking smon_cb);
	modport DMON_MP(clocking dmon_cb);

endinterface
