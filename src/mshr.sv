// Darrion Ramos
// University of Florida

module mshr #(parameter TAG_WIDTH = 8, INDEX_WIDTH = 4, DATA_WIDTH = 16, 
					    NUM_OPS = 32, NUM_MISSES = 4) 
	(
	input  logic                             clk, rst, valid_request,
	input  logic [TAG_WIDTH-1:0]             requested_tag,
	input  logic [INDEX_WIDTH-1:0]           requested_index,
	input  logic [$clog2(NUM_OPS)-1:0]       requested_operation,
	input  logic [DATA_WIDTH-1:0]            mm_ret_data,
	input  logic [$clog2(NUM_OPS)-1:0]       mm_ret_operation,
	input  logic 							 mm_ret_valid,
	output logic 							 received_request,
	output logic                             miss_returned,              
	output logic                             stall,                      
	output logic [DATA_WIDTH-1:0]            miss_data,
	output logic [TAG_WIDTH-1:0]             miss_tag,
	output logic [INDEX_WIDTH-1:0]           miss_index,
	output logic [$clog2(NUM_OPS)-1:0]       miss_operation,
	output logic [TAG_WIDTH+INDEX_WIDTH-1:0] mm_req,
	output logic [$clog2(NUM_OPS)-1:0]       mm_req_operation,
	output logic 							 mm_req_valid
	);
	
	// registers holding cache data
	logic [NUM_MISSES-1:0]                      valid_r;
	logic [NUM_MISSES-1:0][TAG_WIDTH-1:0]       tag_r;
	logic [NUM_MISSES-1:0][INDEX_WIDTH-1:0]     index_r;
	logic [NUM_MISSES-1:0][$clog2(NUM_OPS)-1:0] op_r;
	
	// added logic
	logic [$clog2(NUM_MISSES)-1:0]              avail_index   = 'd0;
	logic [$clog2(NUM_MISSES)-1:0]              ret_index     = 'd0;
	logic                                       stall_on_next = 'd0;
	logic                                       clear_row     = 1'b0;
	logic                                       update_index  = 1'b0;
	int                                         i             = 'd0;
		
	always_ff @(posedge clk, posedge rst) begin
		// If main memory returns data, a row will be cleared by the associated index.
		if (clear_row) begin
			valid_r [ret_index] <= '0;
			tag_r   [ret_index] <= '0;
			index_r [ret_index] <= '0;
			op_r    [ret_index] <= '0;
		end
		
		if (rst) begin
			// registers storing requests
			valid_r          <= '0;
			tag_r            <= '0;
			index_r          <= '0;
			op_r             <= '0;
			
			// indexing
			avail_index      = '0;
			update_index     <= 1'b0;
			ret_index        <= 'd0;
			clear_row 		 <= 1'b0;
			stall_on_next	 = 1'b0;

			// misses
			miss_returned    <= 1'b0;
			miss_data        <= 'd0;
			miss_tag	     <= 'd0;
			miss_index       <= 'd0;
			miss_operation   <= 'd0;
			
			// request outputs
			mm_req_valid     <= '0;
			mm_req	         <= '0;
			mm_req_operation <= '0;
			received_request <= 1'b0;
		end
		
		else begin
			// Clear row should only be asserted for one cycle. 
			// It also removes any stall since an index will be available.
			if (clear_row) begin
				clear_row <= 1'b0;
				stall_on_next = 1'b0;
			end
			
			// When a request returns from main memory, output matching operation and clear it's data.
			if (mm_ret_valid) begin
				for (i=0; i < NUM_MISSES; i++) begin
					if (mm_ret_operation == op_r[i]) begin
						ret_index = i;
						clear_row <= 1'b1;
						avail_index = ret_index;
						
						miss_returned = 1'b1;
						miss_data <= mm_ret_data;
						miss_operation <= op_r[ret_index];
						miss_index <= index_r[ret_index];
						miss_tag <= tag_r[ret_index];
					end
				end
			end
			else begin
				miss_returned <= 1'b0;
				clear_row <= 1'b0;
			end
			
			// Find the next available index if necessary.
			if (update_index) begin
				if (valid_r == '1)
					stall_on_next = 1'b1;
				else begin
					for (i=0; i<NUM_MISSES; i++) begin
						if (valid_r[i] == 1'b0) begin
							avail_index = i;
							break;
						end
					end
				end
			end
			
			// When all registers are valid there is no space to store a new request.
			if (valid_r == '1 && !clear_row)
				stall_on_next = 1'b1; //this needs to be a blocking assignment to ensure next statement evaluates correctly.
			
			// Only service a new request if there is no stall and no return from main memory.
			if (valid_request && !stall_on_next && !mm_ret_valid) begin
				// store request information
				valid_r[avail_index] <= 1'b1;
				tag_r  [avail_index] <= requested_tag;
				index_r[avail_index] <= requested_index;
				op_r   [avail_index] <= requested_operation;
				update_index         <= 1'b1;
				received_request     <= 1'b1;
				
				// send request to next memory stage
				mm_req_valid <= 1'b1;
				mm_req_operation <= requested_operation;
				mm_req[TAG_WIDTH+INDEX_WIDTH-1:INDEX_WIDTH] <= requested_tag;
				mm_req[INDEX_WIDTH-1:0] <= requested_index;
			end
			else begin
				received_request <= 1'b0;
				mm_req_valid     <= 1'b0;
				update_index     <= 1'b0;
			end
		end
	end	
	
	// If the all valid registers are asserted, wait until one is cleared.
	assign stall = stall_on_next && valid_request;
endmodule