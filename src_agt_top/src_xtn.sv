class src_xtn extends uvm_sequence_item;

	`uvm_object_utils(src_xtn)
	
	rand bit[1:0] address;
	rand bit[5:0] length;
	rand bit[7:0] payload[];
	bit [7:0] parity;
	bit error;
	constraint address_c{address != 3;}
	// constraint address_c1{address == 0;}
	constraint length_c{length > 1;}
	constraint payload_c{payload.size == length;}
	extern function new(string name = "src_xtn");
	extern function void do_print(uvm_printer printer);
	extern function void post_randomize();
endclass

function src_xtn::new(string name = "src_xtn");
	super.new(name);
endfunction:new

function void src_xtn::do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field("address",this.address,2,UVM_DEC);
	printer.print_field("length",this.length,6,UVM_DEC);
	foreach(this.payload[i])
		printer.print_field("payload",this.payload[i],8,UVM_DEC);
	printer.print_field("parity",this.parity,8,UVM_DEC);
endfunction
	

function void src_xtn::post_randomize();
	parity = {length,address};
	foreach(payload[i])
		parity = parity^payload[i];
endfunction

