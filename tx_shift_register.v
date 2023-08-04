module tx_shift_register(reset,char_len,intx,mosi,go_busy,clk,tx_complete,lsb,clk_out);

	input [5:0] char_len;
	input go_busy,clk,lsb,reset;
	input [127:0] intx;
	output mosi,tx_complete,clk_out;
	
	integer count;
	
	reg [127:0] txreg;
	reg outtxbuff,tx_complete_buff,lsb_buff;
	
	assign clk_out = clk;
	assign mosi = outtxbuff;
	assign tx_complete = tx_complete_buff;
	
	initial begin
		tx_complete_buff = 0;
		txreg = 0;
		outtxbuff = 0;
		//count = char_len;
		lsb_buff = 0;
	end
	
	always @ (posedge reset or posedge clk) begin
		
		
		$display("go busy: %b",go_busy);
		
		
		if(reset)begin
			lsb_buff = 0;
			tx_complete_buff = 0;  
			count = 0;
			txreg = 0;
			outtxbuff = 0;
		end
		
		else if(go_busy == 0) begin
		
			count = char_len;
			/*
			if (lsb == 0)//msb in first
				outtxbuff = txreg[char_len-1];
			if (lsb == 1)//msb in first
				outtxbuff = txreg[0];*/
			
			if(char_len < 'd32)begin
				txreg[31:0] = intx[31:0];
				//$display("tx0");
			end
			else if (char_len < 'd64)begin
				txreg[63:0] = intx[63:0];
				//$display("tx1");
			end
			else if (char_len < 'd96)begin
				txreg[95:0] = intx[95:0];
				//$display("tx2");
			end
			else if (char_len < 'd128)begin
				txreg[127:0] = intx[127:0];
				//$display("tx3");
			end
			
			
		end
		
		
		else if (go_busy == 1)begin
			//$display("count in tx register: %d",count);
			
			
			if (lsb == 0)begin//msb in first
				
				outtxbuff = txreg[char_len-1];
				
				if('d0 < char_len  && char_len <= 'd32)begin
					txreg[31:0] = txreg[31:0] << 1;
				end
				
				if ('d32 < char_len  && char_len <= 'd64)begin
					txreg[63:0] = txreg[63:0] << 1;
				end
				
				if ('d64 < char_len  && char_len <= 'd96)begin
					txreg[95:0] = txreg[95:0] << 1;
				end
				
				if ('d96 < char_len  && char_len <= 'd128)begin
					txreg[127:0] = txreg[127:0] << 1;
				end
				
				
				
			end
			
			if (lsb == 1)begin//lsb in first
				
				outtxbuff = txreg[0];
				
				if('d0 < char_len  && char_len <= 'd32)begin
					txreg[31:0] = txreg[31:0] >> 1;
				end
				
				if ('d32 < char_len  && char_len <= 'd64)begin
					txreg[63:0] = txreg[63:0] >> 1;
				end
				
				if ('d64 < char_len  && char_len <= 'd96)begin
					txreg[95:0] = txreg[95:0] >> 1;
				end
				
				if ('d96 < char_len  && char_len <= 'd128)begin
					txreg[127:0] = txreg[127:0] >> 1;
				end
				
				
				
				
			end
			
			$display("outtxbuff %b",mosi);
			
			
			
			if (count == 1)begin
				tx_complete_buff = 1;
			end
			
			count = count-1;
			
		end
		
		
		
	end

endmodule