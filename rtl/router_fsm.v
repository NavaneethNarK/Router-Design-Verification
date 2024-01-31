module router_fsm(input clock, resetn, pkt_valid, parity_done, soft_reset_0, soft_reset_1, soft_reset_2, fifo_full, low_pkt_valid, fifo_empty_0, fifo_empty_1, fifo_empty_2, input [1:0] data_in, output busy, detect_add, ld_state, laf_state, full_state, write_enb_reg, rst_int_reg, lfd_state);

parameter DECODE_ADDRESS = 8'd1, LOAD_FIRST_DATA = 8'd2, LOAD_DATA = 8'd4, LOAD_PARITY = 8'd8, FIFO_FULL_STATE = 8'd16, LOAD_AFTER_FULL = 8'd32, WAIT_TILL_EMPTY = 8'd64, CHECK_PARITY_ERROR = 8'd128;

reg [7:0] ps, ns;
reg [1:0] addr;

//address logic
always@(posedge clock)begin
	if(detect_add)
		addr <= data_in;
end
//present state logic
always@(posedge clock) 
	begin
		if(!resetn) 
			ps <= DECODE_ADDRESS;
		else if(((addr == 0) & soft_reset_0) | ((addr == 1) & soft_reset_1) | ((addr == 2) & soft_reset_2))			
			ps <= DECODE_ADDRESS;
		else 
			ps <= ns;
	end

//next state logic
always@(*) 
	begin
		ns = DECODE_ADDRESS;
			case(ps) 
				DECODE_ADDRESS : begin 
							if(pkt_valid && (data_in[1:0] == 2'b00))
								begin	
									if(fifo_empty_0)
                     								ns = LOAD_FIRST_DATA;
									else
										ns = WAIT_TILL_EMPTY;
								end
                  					else if(pkt_valid && (data_in[1:0] == 2'b01))
								begin	
									if(fifo_empty_1)
									       ns = LOAD_FIRST_DATA;
							       		else
								 		ns = WAIT_TILL_EMPTY;
								end
							else if(pkt_valid && (data_in[1:0] == 2'b10))
								begin
									if(fifo_empty_2)
										ns = LOAD_FIRST_DATA;
									else
										ns = WAIT_TILL_EMPTY;
								end
							else
								ns = DECODE_ADDRESS;
						end
				LOAD_FIRST_DATA : begin
							ns = LOAD_DATA;
						  end
				LOAD_DATA : begin
				        	if(fifo_full) 
							ns = FIFO_FULL_STATE; 
            					else if(!pkt_valid) 
							ns = LOAD_PARITY;
						else ns = LOAD_DATA;
					    end
				LOAD_PARITY : begin
					      	ns = CHECK_PARITY_ERROR;
					      end
				FIFO_FULL_STATE : begin
				       			if(fifo_full) 
								ns = FIFO_FULL_STATE; 
                  					else 
								ns = LOAD_AFTER_FULL;
						  end
				LOAD_AFTER_FULL : begin
							if(parity_done) 
								ns = DECODE_ADDRESS; 
                  					else if(low_pkt_valid) 
								ns = LOAD_PARITY; 
                  					else 
								ns = LOAD_DATA;
						  end
				WAIT_TILL_EMPTY : begin
							if((!fifo_empty_0 && (addr == 0)) | (!fifo_empty_1 && (addr == 1)) | (!fifo_empty_2 && (addr == 2)))	
                						ns = WAIT_TILL_EMPTY;
							else
							   	ns = LOAD_FIRST_DATA; 
						  end
				CHECK_PARITY_ERROR : begin
							if(fifo_full) 
								ns = FIFO_FULL_STATE; 
							else 
								ns = DECODE_ADDRESS;
						     end
			endcase
	end

//output logic
assign busy = (ps == LOAD_FIRST_DATA || ps == LOAD_PARITY || ps == FIFO_FULL_STATE || ps == LOAD_AFTER_FULL || ps == WAIT_TILL_EMPTY || ps == CHECK_PARITY_ERROR) ? 1'b1 : 1'b0;
assign detect_add = (ps == DECODE_ADDRESS) ? 1'b1 : 1'b0;
assign ld_state = (ps == LOAD_DATA) ? 1'b1 : 1'b0;
assign laf_state = (ps == LOAD_AFTER_FULL) ? 1'b1 : 1'b0;
assign full_state = (ps == FIFO_FULL_STATE) ? 1'b1 : 1'b0;
assign write_enb_reg = (ps == LOAD_AFTER_FULL || ps == LOAD_DATA || ps == LOAD_PARITY) ? 1'b1 : 1'b0;
assign rst_int_reg = (ps == CHECK_PARITY_ERROR) ? 1'b1 : 1'b0;
assign lfd_state = (ps == LOAD_FIRST_DATA) ? 1'b1 : 1'b0;

endmodule 




