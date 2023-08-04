`timescale 1ns/1ns
module spi_tb;
	
	reg wb_clk,reset,cyc,wb_stb,wb_we;
	wire wb_stall,wb_ack;
	reg [4:0] wb_adr_i;
	wire sclk_pad_o;
	
	wire miso;
	wire mosi;
	reg [31:0] wb_data_i;
	wire [31:0] wb_data_o;
	integer i;

	wire [7:0] ss_pad_o;
	
	reg [31:0] ctrl_data;
	
	spi ins(wb_clk,cyc,wb_ack,wb_stb,wb_stall,wb_we,wb_data_i,wb_data_o,reset,wb_adr_i,miso,mosi,ss_pad_o,sclk_pad_o);
	
	slave slave_inst(ss_pad_o[0],sclk_pad_o,miso,mosi);
	
	
	
	task config_reg(input [4:0] adr,input [31:0] data);
		
		if(wb_stb)begin
			wb_we = 1;
			wb_adr_i = adr;
			wb_data_i = data;
			
		end
		
		else begin
			$display("config reg unsuccessful");
		end
		
	endtask
	
	
	task data_read(input [4:0] adr);
		
		if(wb_stb)begin
			
			wb_we = 0;
			wb_adr_i = adr;
			$display("adr for read %b",adr);
			$display("data_out %b",wb_data_o);
			
		end
		
		else begin
			$display("spi master not connected");
		end
		
	endtask
	
	
	task start_tx(input [7:0] ss);
		
		if(wb_stb)begin
			
			wb_we = 1;
			
			ctrl_data[8] = 1;
			
			config_reg('h10,ctrl_data);
			
		end
		
		else begin
			$display("spi master not connected");
		end
		
	endtask
	
	task stop_tx(input [7:0] ss);
		
		if(wb_stb)begin
			
			wb_we = 1;

			config_reg('h10,ctrl_data);
			
		end
		
		else begin
			$display("spi master not connected");
		end
		
	endtask
	
	
	
	initial begin
		
		//$display("ctrl data %b",ctrl_data);
		wb_clk = 0;
		reset = 0;
		for(i=0;i<500;i=i+1)begin
			wb_clk = ~wb_clk;
			#20;
		end
		
	end
	
	always @ (posedge cyc)begin
		while(!wb_ack)begin
			$display("waiting for ack");
			#1;
		end
		wb_stb = 1;
		$display("acknowledged");
	end
	
	initial begin
		#39;
		cyc = 1;
		wb_stb = 0;
		//miso = 1;
		#40;
		
		config_reg('h00,'b1010000001);
		#40;
		
		config_reg('h10,ctrl_data);
		#40;
		
		config_reg('h18,'b01);
		#40;
		
		config_reg('h14,'b01);
		#80;
		
		start_tx('b1);
		#40;
	
		#40;
		wb_we = 0;
		//reading data
		
		data_read('h00);
		
		
	end
	
	initial begin
		ctrl_data = 0;
		#1
		ctrl_data[13] = 1; //Ass
		ctrl_data[6:0] = 'd10; //charlen
		ctrl_data[11] = 1; //lsb
		ctrl_data[10] = 1; //txneg
		ctrl_data[9] = 0; //rxneg
		ctrl_data[8] = 0; //go_busy
		
		$display("=========================================================");
	end
	
	
endmodule