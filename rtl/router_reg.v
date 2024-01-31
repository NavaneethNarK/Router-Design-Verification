module router_reg(input clock, resetn, pkt_valid, fifo_full, rst_int_reg, detect_add, ld_state, laf_state, full_state, lfd_state, input [7:0] data_in, output reg parity_done, low_pkt_valid, err, output reg [7:0] dout);

reg [7:0] header, fifo_full_state_byte, internal_parity, packet_parity;

//parity_done logic
always@(posedge clock) 
	begin
		if(!resetn) 
			parity_done <= 1'b0;
		else if((ld_state && !fifo_full && !pkt_valid) || (laf_state && low_pkt_valid && !parity_done)) 
			parity_done <= 1'b1;
		else if(detect_add) 
			parity_done <= 1'b0;
//else parity_done <= parity_done;
	end

//low_pkt_valid logic
always@(posedge clock) 
	begin
		if(!resetn) 
			low_pkt_valid <= 1'b0;
		else if(ld_state && !pkt_valid) 
			low_pkt_valid <= 1'b1;
		else if(rst_int_reg) 
			low_pkt_valid <= 1'b0;
//else low_pkt_valid <= low_pkt_valid;
	end

//dout logic
always@(posedge clock) 
	begin
		if(!resetn) 
			begin	
				dout <= 8'h00;
				header <= 8'h00;
				fifo_full_state_byte <= 8'h00;
			end
		else
			begin
				if(detect_add && pkt_valid && data_in[1:0] != 2'b11)
					header <= data_in;
				else if(lfd_state)
					dout <= header;
				else if(ld_state && !fifo_full)
					dout <= data_in;
				else if(ld_state && fifo_full)
					fifo_full_state_byte <= data_in;
				else if(laf_state)
					dout <= fifo_full_state_byte;
			end
	end

//err logic
always@(posedge clock) 
	begin
		if(!resetn) 
			err <= 1'b0;
		else if(!parity_done)
			err <= 1'b0;
		else if(packet_parity != internal_parity)
			err <= 1'b1;
		else
			err <= 1'b0;
	end

//internal_parity logic
always@(posedge clock) 
	begin
		if(!resetn) 
			internal_parity <= 8'h00;
		else
			begin
				if(detect_add)
					internal_parity <= 8'h00;
				else if(lfd_state)
					internal_parity <= internal_parity ^ header;
				else if(ld_state && !full_state && pkt_valid)
					internal_parity <= internal_parity ^ data_in;
			end
	end

//packet_parity logic
always@(posedge clock) 
	begin
		if(!resetn) 
			packet_parity  <= 8'h00;
		else if(detect_add) 
			packet_parity <= 8'h00;
		else if((ld_state && !pkt_valid && !fifo_full) || (laf_state & low_pkt_valid & !parity_done)) 
			packet_parity <= data_in; 
end
endmodule



