`timescale 1 ns/10 ps // 1 ns time unit, 10 ps precision

module mshr_tb;
	parameter TAG_WIDTH = 8;
	parameter INDEX_WIDTH = 4;
	parameter DATA_WIDTH = 16;
	parameter NUM_OPS = 32;
	parameter NUM_MISSES = 4;
	
	logic                             clk, rst, valid_request;
	logic [TAG_WIDTH-1:0]             requested_tag;
	logic [INDEX_WIDTH-1:0]           requested_index;
	logic [$clog2(NUM_OPS)-1:0]       requested_operation;
	logic [DATA_WIDTH-1:0]            mm_ret_data;
	logic [$clog2(NUM_OPS)-1:0]       mm_ret_operation;
	logic 							  mm_ret_valid; 
	logic 							  received_request;
	logic                             miss_returned;              
	logic                             stall;                      
	logic [DATA_WIDTH-1:0]            miss_data;
	logic [TAG_WIDTH-1:0]             miss_tag;
	logic [INDEX_WIDTH-1:0]           miss_index;
	logic [$clog2(NUM_OPS)-1:0]       miss_operation;
	logic [TAG_WIDTH+INDEX_WIDTH-1:0] mm_req;
	logic [$clog2(NUM_OPS)-1:0]       mm_req_operation;
	logic 							  mm_req_valid;
	
	// Instantiate DUT
	mshr #(.TAG_WIDTH(TAG_WIDTH), .INDEX_WIDTH(INDEX_WIDTH), .DATA_WIDTH(DATA_WIDTH), .NUM_OPS(NUM_OPS), .NUM_MISSES(NUM_MISSES))DUT
		(.*);
		
	initial begin : generate_clock
	  clk = 1'b0;
	  while(1)
		#5 clk = !clk;
	end

	initial begin
		// Set the time units to nanosecond scale.
		$timeformat(-9, 0, " ns");
		
		rst <= 1'b1;
		valid_request <= 1'b0;
		requested_tag <= '0;
		requested_index <= '0;
		requested_operation <= '0;
		mm_ret_data <= '0;
		mm_ret_operation <= '0;
		mm_ret_valid <= '0;
		
		// Wait 2 cycles
		for (int i=0; i < 2; i++)
			@(posedge clk);
			
		// Clear reset
		@(negedge clk);
		rst <= 1'b0;
		
		// Wait 2 cycles
		for (int i=0; i < 2; i++)
			@(posedge clk);
			
		// Insert miss requests
		valid_request <= 1'b1;
		requested_index <= 4'b1010;
		requested_tag   <= 'd36;
		requested_operation <= 'd9;
		@(posedge clk);
		
		requested_index <= 4'b0100;
		requested_tag   <= 'd42;
		requested_operation <= 'd10;
		@(posedge clk);
		
		// data returns from second request
		mm_ret_valid <= 1'b1;
		mm_ret_operation <= 'd10;
		mm_ret_data <= 'd100;
		
		requested_index <= 4'b0111;
		requested_tag   <= 'd43;
		requested_operation <= 'd11;
		@(posedge clk);
		mm_ret_valid <= 1'b0;
		
		requested_index <= 4'b1111;
		requested_tag   <= 'd44;
		requested_operation <= 'd12;
		@(posedge clk);
		
		valid_request <= 1'b0;
		for (int i=0; i < 0; i++)
			@(posedge clk);
		
		valid_request <= 1'b1;
		requested_index <= 4'b0101;
		requested_tag   <= 'd50;
		requested_operation <= 'd14;
		@(posedge clk);
		@(posedge clk);
		
		requested_index <= 4'b0111;
		requested_tag   <= 'd33;
		requested_operation <= 'd20;
		for (int i=0; i < 10; i++)
			@(posedge clk);
			
		// data returns from third request
		mm_ret_valid <= 1'b1;
		mm_ret_operation <= 'd12;
		mm_ret_data <= 'd122;
		@(posedge clk);
		@(posedge clk);
		mm_ret_valid <= 1'b0;
		

		
		for (int i=0; i < 4; i++)
			@(posedge clk);
		// Disable the other initial blocks so that the simulation terminates.
		disable generate_clock;
		$display("Tests completed.");
	end 
endmodule