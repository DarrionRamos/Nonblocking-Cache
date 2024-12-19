// Darrion Ramos
// University of Florida

`timescale 1ns / 1ps
`define EXPECTING_HIT 01
`define EXPECTING_FULL 11
`define EXPECTING_MISS 00

module non_blocking_cache_tb;

    // Parameters
    parameter DATA_WIDTH  = 32;
    parameter ADDR_WIDTH  = 16;
    parameter NUM_BLOCKS  = 8;
	parameter NUM_OPS     = 32;
    parameter BLOCK_DEPTH = 64;
	parameter NUM_MISSES  = 4;

    // Testbench signals
    logic clk;
    logic reset;
    logic read_enable;
	logic [ADDR_WIDTH-1:0] 		read_address;
   	logic [DATA_WIDTH-1:0]      data_out;
	logic [$clog2(NUM_OPS)-1:0] op_out;
	logic [$clog2(NUM_OPS)-1:0] read_op;
	logic                       stall;
    logic                       hit;
	logic                       miss;
	
	// Main memory signals, exposed for manual implementation
	logic [DATA_WIDTH-1:0]            mm_ret_data;
	logic [$clog2(NUM_OPS)-1:0]       mm_ret_op;
	logic 							  mm_ret_valid;
	logic [ADDR_WIDTH-1:0] mm_req;
	logic [$clog2(NUM_OPS)-1:0]       mm_req_op;
	logic 							  mm_req_valid;

    // Instantiate the cache
    non_blocking_cache #(.DATA_WIDTH (DATA_WIDTH),
						 .ADDR_WIDTH (ADDR_WIDTH),
						 .NUM_BLOCKS (NUM_BLOCKS),
						 .NUM_OPS    (NUM_OPS),
						 .BLOCK_DEPTH(BLOCK_DEPTH),
						 .NUM_MISSES (NUM_MISSES))  
	DUT
	(.*);

    // Clock generation
    initial begin : generate_clock
	  clk = 1'b0;
	  while(1)
		#5 clk = !clk;
	end // 10 ns clock period

	// Task for reading from cache
    task read_from_cache(input [ADDR_WIDTH-1:0] addr, input [$clog2(NUM_OPS)-1:0] op);
        begin
            @(posedge clk);
            read_address = addr;
			read_op		 = op;
            read_enable = 1;
            @(posedge clk);
            read_enable = 0;
        end
    endtask
	
    // Task for reading from cache
    task read(input [ADDR_WIDTH-1:0] addr, input [DATA_WIDTH-1:0] expected_data, input [$clog2(NUM_OPS)-1:0] op, input [1:0] expected);
        begin
            // Read back and check for hits
            read_from_cache(addr, op); 
			if (expected == `EXPECTING_HIT) begin
				@(posedge clk);
				if (hit && data_out == expected_data)
					$display("PASS: Read data 0x%H at address 0x%H", data_out, addr);
				else begin
					$error("FAIL: Expected 0x%H at address 0x%H", expected_data, addr);
					$error("Read data 0x%H at address 0x%H", data_out, addr);
				end
			end

			else begin
				var int errors;
				@(posedge clk);
				assert (miss == 1) else begin
					$error("Miss not asserted");
					errors++;
				end
				
				if (expected == `EXPECTING_FULL) begin
					assert (stall == 1) else begin
						$error("Cache not stalled by request while MSHR is FULL.");
						errors++;
					end
				end
				
				@(posedge clk);
				if (expected == `EXPECTING_MISS) begin
					assert (DUT.DM_CACHE.received_request == 1) else begin
						$error("Miss not receieved by MSHR");
						errors++;
					end
				end
				
				if (errors == 0)
					$display("PASS: Miss for address: 0x%H properly handled.", addr);
			end
        end
    endtask
	
	task get_mm_data(input [DATA_WIDTH-1:0] data, input [$clog2(NUM_OPS)-1:0] op);
		begin
			var int errors;
			mm_ret_data <= data;
			mm_ret_op   <= op;
			mm_ret_valid <= 1'b1;
			@(posedge clk);
			mm_ret_valid <= 1'b0;
			@(posedge clk);
			@(posedge clk);
			assert(DUT.DM_CACHE.BLOCK_ops[DUT.DM_CACHE.w_index] == op) else begin
				$error("Miss return for op: 0x%H, from MM not written to cache", op);
				errors++;
			end
			if (errors == 0)
				$display("PASS: Miss return for op: 0x%H properly stored", op);
		end
	endtask
	
    // Test procedure
    initial begin
        // Initialize signals
        reset        = 1;
        read_enable  = 0;
        read_address = 0;
		read_op		 = 0;

		mm_ret_data  = 0;
		mm_ret_op    = 0;
		mm_ret_valid = 0;
		
        // Reset the cache
        @(posedge clk);
		@(posedge clk);
        reset = 0;
        @(posedge clk);
		@(posedge clk);

        // Read back and check for hits
        read(32'h0001, 32'hAAAA_AAAA, 10, `EXPECTING_MISS);
        read(32'h0002, 32'hBBBB_BBBB, 11, `EXPECTING_MISS); 
        read(32'h0003, 32'hCCCC_CCCC, 12, `EXPECTING_MISS); 
        read(32'h0004, 32'hDDDD_DDDD, 13, `EXPECTING_MISS);
		get_mm_data(32'hBBBB_BBBB, 11);
		//for (int i=0; i <4; i++) begin
		//	@(posedge clk);
		//end
        read(32'h1005, 32'hFFFF_FFFF, 14,`EXPECTING_MISS);
        read(32'hB006, 32'h1111_1111, 15,`EXPECTING_FULL);
		get_mm_data(32'hCCCC_CCCC, 12);
		get_mm_data(32'hAAAA_AAAA, 10);
		get_mm_data(32'hDDDD_DDDD, 13);
		get_mm_data(32'hFFFF_FFFF, 14);
		for (int i=0; i <4; i++) begin
			@(posedge clk);
		end

		read(32'h0004, 32'hDDDD_DDDD, 13, `EXPECTING_HIT);
		read(32'h1005, 32'hFFFF_FFFF, 14, `EXPECTING_HIT);
		read(32'h0003, 32'hCCCC_CCCC, 12, `EXPECTING_HIT);
		read(32'h0001, 32'hAAAA_AAAA, 10, `EXPECTING_HIT);
		for (int i=0; i <4; i++) begin
			@(posedge clk);
		end
		
		disable generate_clock;
		$display("Tests completed.");
    end

endmodule

