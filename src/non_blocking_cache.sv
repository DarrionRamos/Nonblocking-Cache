module non_blocking_cache #(
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 16,
    parameter NUM_BLOCKS  = 256,
	parameter NUM_OPS     = 32,
	parameter NUM_MISSES  = 64,
    parameter BLOCK_DEPTH = 64  //Cache lines per block, not implemented yet
) (
    input  logic clk,
    input  logic reset,
    input  logic read_enable,
	input  logic [ADDR_WIDTH-1:0] read_address,
	input  logic [$clog2(NUM_OPS)-1:0] read_op,
	
	output logic [DATA_WIDTH-1:0]      data_out,
	output logic [$clog2(NUM_OPS)-1:0] op_out,
	output logic                       stall, // ignore read requests on read_stall
    output logic                       hit,
	output logic                       miss,
	
	// Main memory signals, exposed for manual implementation
	input  logic [DATA_WIDTH-1:0]            mm_ret_data,
	input  logic [$clog2(NUM_OPS)-1:0]       mm_ret_op,
	input  logic 							 mm_ret_valid,
	output logic [ADDR_WIDTH-1:0] mm_req,
	output logic [$clog2(NUM_OPS)-1:0]       mm_req_op,
	output logic 							 mm_req_valid
);
	localparam BLOCK_INDEX_BITS = $clog2(NUM_BLOCKS);
    localparam TAG_BITS = ADDR_WIDTH - BLOCK_INDEX_BITS;
	
	logic cache_write_enable, cache_stall, mshr_stall;
    logic [$clog2(NUM_OPS)-1:0] write_op;
    logic [ADDR_WIDTH-1:0] write_address;
	logic [DATA_WIDTH-1:0] write_data;
	
	logic [$clog2(NUM_OPS)-1:0]                    req_op;
	logic [(ADDR_WIDTH - $clog2(NUM_BLOCKS))-1: 0] req_tag;
	logic [$clog2(NUM_BLOCKS)-1: 0]                req_index;
	logic [(ADDR_WIDTH - $clog2(NUM_BLOCKS))-1: 0] miss_tag;
	logic [$clog2(NUM_BLOCKS)-1: 0]                miss_index;
	logic                                          valid_request;
	logic                                          received_request;
	
	assign write_address[BLOCK_INDEX_BITS-1:0]             = miss_index;
	assign write_address[ADDR_WIDTH-1:ADDR_WIDTH-TAG_BITS] = miss_tag;
	assign stall 										   = cache_stall || mshr_stall;
	
	cache #(.DATA_WIDTH(DATA_WIDTH),
		    .ADDR_WIDTH(ADDR_WIDTH),
		    .NUM_BLOCKS(NUM_BLOCKS),
		    .NUM_OPS(NUM_OPS),
		    .BLOCK_DEPTH(BLOCK_DEPTH))
	DM_CACHE
    (.clk             (clk),
	 .reset           (reset),
	 .read_enable     (read_enable),
	 .write_enable    (cache_write_enable),
	 .received_request(received_request),
	 .w_op            (write_op),
	 .r_op			  (read_op),
	 .w_address       (write_address),
	 .r_address       (read_address),
	 .write_data      (write_data),
	 
	 .req_op          (req_op),
	 .req_tag         (req_tag),
	 .req_index       (req_index),
	 .valid_request   (valid_request),
	 
	 .data_out        (data_out),
	 .op_out          (op_out),
	 .stall_out      (cache_stall),
	 .hit             (hit),
	 .miss            (miss)
    );
	
	mshr #(.TAG_WIDTH(ADDR_WIDTH - $clog2(NUM_BLOCKS)),
		   .INDEX_WIDTH($clog2(NUM_BLOCKS)),
		   .DATA_WIDTH(DATA_WIDTH),
		   .NUM_OPS(NUM_OPS),
		   .NUM_MISSES(NUM_MISSES)) 
	MSHR
	(.clk(clk),
	 .rst(reset),
	 .valid_request(valid_request),
	 .requested_tag(req_tag),
	 .requested_index(req_index),
	 .requested_operation(req_op),
	 
	 .mm_ret_data(mm_ret_data),
	 .mm_ret_operation(mm_ret_op),
	 .mm_ret_valid(mm_ret_valid),
	 .mm_req(mm_req),
	 .mm_req_operation(mm_req_op),
	 .mm_req_valid(mm_req_valid),
	 
	 .received_request(received_request),
	 .miss_returned(cache_write_enable),
	 .miss_data(write_data),
	 .miss_tag(miss_tag),
	 .miss_index(miss_index),
	 .miss_operation(write_op),
	 .stall(mshr_stall)
	);
endmodule

