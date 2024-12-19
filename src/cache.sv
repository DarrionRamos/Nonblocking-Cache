module cache #(
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 16,
    parameter NUM_BLOCKS  = 8,
	parameter NUM_OPS     = 32,
    parameter BLOCK_DEPTH = 64  //Cache lines per block, not implemented yet
) (
    input  logic clk,
    input  logic reset,
    input  logic read_enable,
    input  logic write_enable,
	input  logic received_request,
	input  logic [$clog2(NUM_OPS)-1:0] w_op,
	input  logic [$clog2(NUM_OPS)-1:0] r_op,
    input  logic [ADDR_WIDTH-1:0] w_address,
	input  logic [ADDR_WIDTH-1:0] r_address,
    input  logic [DATA_WIDTH-1:0] write_data,
	
	// data to send to mshr
	output logic [$clog2(NUM_OPS)-1:0]                    req_op,
	output logic [(ADDR_WIDTH - $clog2(NUM_BLOCKS))-1: 0] req_tag,
	output logic [$clog2(NUM_BLOCKS)-1: 0]                req_index,
	output logic                                          valid_request,
	
	// top output
	output logic [DATA_WIDTH-1:0]      data_out,
	output logic [$clog2(NUM_OPS)-1:0] op_out,
	output logic                       stall_out, // ignore read requests on read_stall
    output logic                       hit,
	output logic                       miss
);

    localparam BLOCK_INDEX_BITS = $clog2(NUM_BLOCKS);
    localparam TAG_BITS = ADDR_WIDTH - BLOCK_INDEX_BITS;

    logic [BLOCK_INDEX_BITS-1:0] w_index, r_index;
    logic [TAG_BITS-1:0] w_tag, r_tag;

    assign w_index = w_address[BLOCK_INDEX_BITS-1:0];
    assign w_tag = w_address[ADDR_WIDTH-1:ADDR_WIDTH-TAG_BITS];
	
	assign r_index = r_address[BLOCK_INDEX_BITS-1:0];
    assign r_tag = r_address[ADDR_WIDTH-1:ADDR_WIDTH-TAG_BITS];

    //Cache BLOCKs
    logic [DATA_WIDTH-1:0]        BLOCK_data[NUM_BLOCKS-1:0];
    logic [TAG_BITS-1:0]          BLOCK_tags[NUM_BLOCKS-1:0];
	logic [$clog2(NUM_OPS)-1:0]   BLOCK_ops [NUM_BLOCKS-1:0];
    logic valid[NUM_BLOCKS-1:0]; //Valid bit per cache block
	
	logic [BLOCK_INDEX_BITS-1:0] index_r;
    logic [TAG_BITS-1:0]         tag_r;
	logic [$clog2(NUM_OPS)-1:0]  op_r;
	logic received_request_r;
	logic sent_request;
	logic read_stall;
	logic stall_on_write;
	
	assign stall_out = read_stall || stall_on_write;
    //Read/Write Logic
    always_ff @(posedge clk) begin
        if (reset) begin
            //clear valid bits
            for (int i = 0; i < NUM_BLOCKS; i++) begin
                valid[i] = 0;
            end
			hit           <= 1'b0;
            miss          <= 1'b0;
			index_r       <= '0;
			op_r          <= '0;
			tag_r         <= '0;
			data_out      <= '0;
			op_out        <= '0;
			read_stall    <= '0;
			stall_on_write <= '0;
					      
			req_index     <= '0;
			req_op        <= '0;
			req_tag       <= '0;
			received_request_r = 1'b0;
			valid_request <= 1'b0;
			
        end 
		else begin
            hit <= 0;
            miss <= 0;
			valid_request <= 0;
			stall_on_write <= 0;
			
			if (received_request) begin
				sent_request <= 1'b0;
				received_request_r = 1'b1;
			end
				
            if (write_enable) begin
				stall_on_write <= 1'b1;
                // Write to selected BLOCK and address
                BLOCK_data[w_index%NUM_BLOCKS] <= write_data;
                BLOCK_tags[w_index%NUM_BLOCKS] <= w_tag;
				BLOCK_ops [w_index%NUM_BLOCKS] <= w_op;
                valid[w_index] <= 1;
				
				// Output data from missed request
				data_out <= write_data;
				op_out   <= w_op;
            end 
			
			// Read will not work when writing.
			else if (read_enable || read_stall) begin
				// continue waiting here to request data from mshr until it is ready.
				if (read_stall) begin
					if (received_request_r) begin
						read_stall    <= 1'b0;
						req_index     <= index_r;
						req_op        <= op_r;
						req_tag       <= tag_r;
						sent_request  <= 1'b1;
						valid_request <= 1'b1;
						received_request_r  = 1'b0;
					end
				end
				
				else begin
					// register request in case of a read_stall.
					tag_r   <= r_tag;
					op_r    <= r_op;
					index_r <= r_index;
					
					// Check for hit
					if (valid[r_index%NUM_BLOCKS] && BLOCK_tags[r_index%NUM_BLOCKS] == r_tag) begin
						hit <= 1;
						data_out <= BLOCK_data[r_index%NUM_BLOCKS];
						op_out   <= BLOCK_ops [r_index%NUM_BLOCKS];
					end 
					
					else begin
						miss <= 1;
						
						// if a valid_request is still pending, read_stall the cache until mshr is ready.
						if (!received_request_r && sent_request)
							read_stall <= 1'b1;
						else begin
							req_index     <= r_index;
							req_op        <= r_op;
							req_tag       <= r_tag;
							sent_request  <= 1'b1;
							valid_request <= 1'b1;
							received_request_r  = 1'b0;
						end
					end
				end
            end
        end
    end
endmodule

