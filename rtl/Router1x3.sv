module Router1x3(input clock, resetn, read_enb_0, read_enb_1, read_enb_2, pkt_valid, input [7:0] data_in, output [7:0] data_out_0, data_out_1, data_out_2, output valid_out_0, valid_out_1, valid_out_2, error, busy);
wire [2:0] write_enb;
wire [7:0] dout;
router_fsm FSM(clock, resetn, pkt_valid, parity_done, soft_reset_0, soft_reset_1, soft_reset_2, fifo_full, low_pkt_valid, fifo_empty_0, fifo_empty_1, fifo_empty_2, data_in[1:0], busy, detect_add, ld_state, laf_state, full_state, write_enb_reg, rst_int_reg, lfd_state);
router_sync SYNCHRONIZER(clock, resetn, write_enb_reg, detect_add, read_enb_0, read_enb_1, read_enb_2, fifo_empty_0, fifo_empty_1, fifo_empty_2, full_0, full_1, full_2, data_in[1:0], write_enb, valid_out_0, valid_out_1, valid_out_2, soft_reset_0, soft_reset_1, soft_reset_2, fifo_full);
router_reg REGISTER(clock, resetn, pkt_valid, fifo_full, rst_int_reg, detect_add, ld_state, laf_state, full_state, lfd_state, data_in, parity_done, low_pkt_valid, error, dout);
router_fifo FIFO_0(clock, resetn, write_enb[0], soft_reset_0, read_enb_0, lfd_state, dout, fifo_empty_0, full_0, data_out_0);
router_fifo FIFO_1(clock, resetn, write_enb[1], soft_reset_1, read_enb_1, lfd_state, dout, fifo_empty_1, full_1, data_out_1);
router_fifo FIFO_2(clock, resetn, write_enb[2], soft_reset_2, read_enb_2, lfd_state, dout, fifo_empty_2, full_2, data_out_2);

endmodule




