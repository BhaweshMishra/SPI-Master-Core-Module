`timescale 1ns/1ns

module rx_shift_register_tb;
	reg [5:0] char_len;
	reg miso,go_busy,clk,lsb,reset;
	wire [127:0] outrxd;
	wire clk_out,rx_complete;
	
	
	reg [127:0] x;
	
	integer i;
	integer j;
	
	rx_shift_register inst1(reset,char_len,outrxd,miso,go_busy,clk,rx_complete,lsb,clk_out);
	
	initial begin
		reset = 0;
		clk = 0;
		miso = 0;
		char_len = 'd24;
		#10;
		
		for(i = 0; i<1000; i=i+1)begin
			clk = ~clk;
			#10;
		end
		
	end
	
	initial begin
		x = 'b10101011000111;
		go_busy = 0;
		lsb = 0;
		$display("initial tb charlen: %d",char_len);
		#50;
		go_busy = 1;
		
		
		for(j = char_len-1;j>=0;j=j-1)begin
			miso = x[j];
			#20;
		end
		
		
		x = 'b110010101010;
		go_busy = 0;
		//lsb = 1;
		#20;
		go_busy = 0;
		
		
		for(j = char_len-1;j>=0;j=j-1)begin
			miso = x[j];
			#20;
		end
		#10;
		//reset = 1;
		#10;
		reset = 0;
	end
	
	always @ (posedge rx_complete)begin
		go_busy = 0;
	end
	
endmodule
	
	