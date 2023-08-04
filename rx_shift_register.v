`timescale 1ns/1ns
module rx_shift_register(reset,char_len,outrxd,miso,go_busy,clk,rx_complete,lsb,clk_out);

	input [6:0] char_len;
	input miso,go_busy,clk,lsb,reset;
	output [127:0] outrxd;
	output rx_complete,clk_out;
	
	integer count;
	
	reg [127:0] rxreg;
	reg [127:0] outrxdbuff;
	reg rx_complete_buff,lsb_buff;
	
	assign clk_out = clk;
	assign outrxd = outrxdbuff;
	assign rx_complete = rx_complete_buff;
	
	initial begin
		
		outrxdbuff = 0;
		rxreg = 0;
		rx_complete_buff = 0;
		//lsb_buff = lsb;
		//count = char_len;
		
		
	end
	
	
	always @ (posedge reset or posedge clk )begin
		
		if(reset)begin
			outrxdbuff = 0;
			rxreg = 0;
			lsb_buff = 0;
			rx_complete_buff = 0;
			count = 0;
		end
		
		
		else if(go_busy == 1)begin
		
			//$display("count in rx register: %d",count);
			//$display("value in reg %b", rxreg[10:0]);
			if (lsb == 0)begin//msb in first
				$display("miso: %b",miso);
				
				
				if('d0 < char_len  && char_len <= 'd32)begin
					rxreg[31:0] = rxreg[31:0] << 1;
				end
				
				if ('d32 < char_len  && char_len <= 'd64)begin
					rxreg[63:0] = rxreg[63:0] << 1;
				end
				
				if ('d64 < char_len  && char_len <= 'd96)begin
					rxreg[95:0] = rxreg[95:0] << 1;
				end
				
				if ('d96 < char_len  && char_len <= 'd128)begin
					rxreg[127:0] = rxreg[127:0] << 1;
				end
				
				rxreg[0] = miso;
				
			end
			
			if (lsb == 1)begin//lsb in first
				
				
				
				if('d0 < char_len  && char_len <= 'd32)begin
					rxreg[31:0] = rxreg[31:0] >> 1;
				end
				
				if ('d32 < char_len  && char_len <= 'd64)begin
					rxreg[63:0] = rxreg[63:0] >> 1;
				end
				
				if ('d64 < char_len  && char_len <= 'd96)begin
					rxreg[95:0] = rxreg[95:0] >> 1;
				end
				
				if ('d96 < char_len  && char_len <= 'd128)begin
					rxreg[127:0] = rxreg[127:0] >> 1;
				end
				
				rxreg[char_len-1] = miso;
				
				
			end
			
			
			//$display("rxreg %b",rxreg);
			//$display("lsb0 count: %d",count);
			if (count == 0) begin
				rx_complete_buff = 1;
				//$display("rxbuff 1",count);
				
			end	
			
			count = count - 1;
		end 
		
		else if(go_busy == 0) begin
		
			lsb_buff = lsb;
			rx_complete_buff = 0;  
			count = char_len;
			if('d0 < char_len  && char_len <= 'd32)begin
					outrxdbuff[31:0] = 0;
					outrxdbuff[31:0] = rxreg[31:0];
					//$display("rx0 %b",outrxdbuff);
				end
				
				if ('d32 < char_len  && char_len <= 'd64)begin
					outrxdbuff[63:0] = 0;
					outrxdbuff[63:0] = rxreg[63:0];
					//$display("rx1");
				end
				
				if ('d64 < char_len  && char_len <= 'd96)begin
					outrxdbuff[95:0] = 0;
					outrxdbuff[95:0] = rxreg[95:0];
					//$display("rx2");
				end
				
				if ('d96 < char_len  && char_len <= 'd128)begin
					outrxdbuff[127:0] = 0;
					outrxdbuff[127:0] = rxreg[127:0];
					//$display("rx3");
				end	
			//$display("not gobusy");
		end
		
	end
	
	
endmodule