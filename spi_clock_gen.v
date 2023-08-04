`timescale 1ns/1ns
module spi_clock_gen(wb_clk,reset,divider,sclk,cpol0,cpol1);
	input wb_clk, reset;
	input [31:0] divider;
	output sclk,cpol0,cpol1;
	
	reg sclkreg;
	reg [31:0] counter;
	reg cpol0buff,cpol1buff;
	
	assign sclk = sclkreg;
	assign cpol0 = sclk;
	assign cpol1 = ~sclk;
	
	
	
	initial begin
	   #1;
		$display("divider: %d",divider);
		sclkreg = 0;
		counter = 1;
	end
	

	always @ (posedge wb_clk or posedge reset)begin
		//$display("divider in clk %b",divider);
		if(reset)begin
			
			sclkreg = 0;
			counter = 1;
			//$display("clk reset counter: %d sclkreg:%d",counter,sclkreg);
		end
		else if(reset == 0) begin
			counter = counter - 1;
			//$display("counter in clk %d",counter);
			
			if (counter == 0)begin
				sclkreg = ~sclkreg;
				
				counter = divider + 'b1;
			end
		end
	end
	
	
endmodule