module tx_shift_register_tb;
	
	reg [5:0] char_len;
	reg [127:0] intx;
	reg go_busy,clk,lsb;
	wire mosi,tx_complete;	
	
	integer i,j;
	
	tx_shift_register inst2(char_len,intx,mosi,go_busy,clk,tx_complete,lsb);
	
	initial begin
		clk = 0;
		char_len = 'd8;
		
		for(i = 0; i<1000; i=i+1)begin
			clk = ~clk;
			#10;
		end
		
	end
	
	initial begin
		
		go_busy = 0;
		intx = 'd169;
		lsb=0;
		#20;
		go_busy = 1;
		
		
		for(j = char_len-1;j>=0;j=j-1)begin
			#20;
		end
		
		lsb=1;
		#20;
		go_busy = 1;
		
		
		for(j = char_len-1;j>=0;j=j-1)begin
			#20;
		end
		
	end
	
	always @ (posedge tx_complete)begin
		go_busy = 0;
	end

endmodule