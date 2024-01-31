module router_fifo(input clock, resetn, write_enb, soft_reset, read_enb, lfd_state, input [7:0] data_in, output empty, full, output reg [7:0] data_out);

parameter WIDTH = 9, ADDR = 5, DEPTH = 16;

reg [ADDR-1:0] rd_ptr, wr_ptr;
reg lfd;
reg [6:0] count;
integer i;
reg [WIDTH-1:0] mem [DEPTH-1:0];

always@(posedge clock) 
	lfd <= lfd_state;

//write logic
always@(posedge clock) 
	begin
		if(!resetn) 
			begin
				wr_ptr <= 0;
				for(i=0;i<DEPTH;i=i+1) 
					mem[i] <= 0;
			end
		else if(soft_reset) 
			begin
				wr_ptr <= 0;
				for(i=0;i<DEPTH;i=i+1) 
					mem[i] <= 0;
			end
		else 
			begin
				if(write_enb && !full)
					begin
						wr_ptr <= wr_ptr + 1;
						mem[wr_ptr[3:0]] <= {lfd, data_in};
					end
			end
	end

//read logic
always@(posedge clock) 
	begin
		if(!resetn) 
			begin
				rd_ptr <= 0;
				data_out <= 8'h00;
			end
		else if(soft_reset)
			begin
				rd_ptr <= 0;
				data_out <= 8'hzz;
			end
		else 
			begin
				if(read_enb && !empty)
					rd_ptr <= rd_ptr + 1;
				if((count == 0) && (data_out != 0)) 
					data_out <= 8'dz;
				else if(read_enb && !empty) 
					data_out <= mem[rd_ptr[3:0]];
			end
	end

//counter logic
always@(posedge clock) 
	begin
		if(!resetn) 
			count <= 0;
		else if(soft_reset)
			count <= 0;
		else if(read_enb && !empty) 
			begin
				if(mem[rd_ptr[3:0]][8]) 
					count <= mem[rd_ptr[3:0]][7:2] + 1'b1;
				else if(count != 0) 
					count <= count - 1'b1;
			end
	end

assign empty = (rd_ptr == wr_ptr) ? 1'b1 : 1'b0;
assign full = (wr_ptr == {!rd_ptr[4], rd_ptr[3:0]}) ? 1'b1 : 1'b0;

endmodule


