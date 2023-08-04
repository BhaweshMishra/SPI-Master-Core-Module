module spi_clock_gen_tb;
	reg wb_clk,reset;
	reg [31:0] divider;
	wire sclk,cpol0,cpol1;
	
	integer i;
	
	spi_clock_gen inst1 (wb_clk,reset,divider,sclk,cpol0,cpol1);

	
	initial begin
		wb_clk = 0;
		divider = 'd2;
		reset = 0;
		#10;
		for(i = 0; i<100; i=i+1)begin
			wb_clk = ~wb_clk;
			#10;
		end
	end
	
	initial begin
		#25;
		reset = 1;
		#1;
		reset = 0;
	end
endmodule
		
		
		
	