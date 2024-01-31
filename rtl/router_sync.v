module router_sync(input clock, resetn, write_enb_reg, detect_add, read_enb_0, read_enb_1, read_enb_2, empty_0, empty_1, empty_2, full_0, full_1, full_2, input [1:0] data_in, output reg [2:0] write_enb, output vld_out_0, vld_out_1, vld_out_2, output reg soft_reset_0, soft_reset_1, soft_reset_2, fifo_full);

reg [1:0] temp;
reg [4:0] count_0, count_1, count_2;

//address logic
always@(posedge clock) begin
	if(detect_add)
		temp <= data_in;
end
//fifo full logic
always@(*) 
	begin
		if(!resetn)
			fifo_full = 0;
		else
		begin
		case(temp)
			2'b00 : fifo_full = full_0;
			2'b01 : fifo_full = full_1;
			2'b10 : fifo_full = full_2;
			default : fifo_full = full_0;
		endcase
		end
	end

assign vld_out_0 = !empty_0;
assign vld_out_1 = !empty_1;
assign vld_out_2 = !empty_2;

//write enable logic
always@(*) 
	begin
		if(!resetn)
			write_enb = 0;
		else
		begin
		if(write_enb_reg) 
			begin
				case(temp)
					2'b00 : write_enb = 3'b001;
					2'b01 : write_enb = 3'b010;
					2'b10 : write_enb = 3'b100;
					default: write_enb = 3'b000;
				endcase
			end
		else 
			write_enb = 3'b000;
		end
	end


//soft reset 0 logic new change
always@(posedge clock)
	begin
		if(!resetn)
			begin
				soft_reset_0 <= 0;
				count_0 <= 0;
			end
		else if(vld_out_0)
			begin
				if(!read_enb_0)
					begin
						if(count_0 == 30)
							begin
								soft_reset_0 <= 1;
								count_0 <= 0;
							end
						else
							begin
								soft_reset_0 <= 0;
								count_0 <= count_0 + 1;
							end
					end
				else
					begin
						soft_reset_0 <= 0;
						count_0 <= 0;
					end
			end
	end
/*
//soft reset 0 logic
always@(posedge clock) 
	begin
		if(!resetn) 
			begin
				count_0 <= 0; 
				soft_reset_0 <= 0;
			end
		else if(!vld_out_0) 
			begin
				count_0 <= 0;
				soft_reset_0 <= 0;
			end
		else if(read_enb_0) 
			begin
				count_0 <= 0;
				soft_reset_0 <= 0;
			end
		else
			begin
				if(count_0 == 29)
					begin
						count_0 <= 0;
						soft_reset_0 <= 1;
					end
				else
					begin
						count_0 <= count_0 + 1;
						soft_reset_0 <= 0;
					end
			end
	end
*/
//soft reset 1 logic
always@(posedge clock) 
	begin
		if(!resetn) 
			begin
				count_1 <= 0;
				soft_reset_1 <= 0;
			end
		else if(!vld_out_1) 
			begin
				count_1 <= 0;
				soft_reset_1 <= 0;
			end
		else if(read_enb_1) 
			begin
				count_1 <= 0;
				soft_reset_1 <= 0;
			end
		else
			begin
				if(count_1 == 29)
					begin
						count_1 <= 0;
						soft_reset_1 <= 1;
					end
				else
					begin
						count_1 <= count_1 + 1;
						soft_reset_1 <= 0;
					end
			end
	end


		
//soft reset 2 logic
always@(posedge clock) 
	begin
		if(!resetn) 
			begin
				count_2 <= 0; 
				soft_reset_2 <= 0;
			end
		else if(!vld_out_2) 
			begin
				count_2 <= 0;
				soft_reset_2 <= 0;
			end
		else if(read_enb_2) 
			begin
				count_2 <= 0;
				soft_reset_2 <= 0;
			end
		else
			begin
				if(count_2 == 29)
					begin
						count_2 <= 0;
						soft_reset_2 <= 1;
					end
				else
					begin
						count_2 <= count_2 + 1;
						soft_reset_2 <= 0;
					end
			end
	end

endmodule




