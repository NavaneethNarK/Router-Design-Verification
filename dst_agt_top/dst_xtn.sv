class dst_xtn extends uvm_sequence_item;

	`uvm_object_utils(dst_xtn)

	bit[1:0] address;
	bit[5:0] length;
	bit[7:0] payload[];
	bit[7:0] parity;
	rand bit [5:0] no_of_cycles;

	extern function new(string name = "dst_xtn");
	extern function void do_print(uvm_printer printer);
endclass

function dst_xtn::new(string name = "dst_xtn");
	super.new(name);
endfunction:new

function void dst_xtn::do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field("address",this.address,2,UVM_DEC);
	printer.print_field("length",this.length,6,UVM_DEC);
	foreach(this.payload[i])
		printer.print_field("payload",this.payload[i],8,UVM_DEC);
	printer.print_field("parity",this.parity,8,UVM_DEC);
endfunction