onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/clk
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/reset
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/mm_ret_data
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/mm_ret_op
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/mm_ret_valid
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/mm_req
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/mm_req_op
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/mm_req_valid
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/data_out
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/op_out
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/read_enable
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/read_address
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/read_op
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/stall
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/hit
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/miss
add wave -noupdate -divider CACHE
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/read_enable
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/write_enable
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/received_request
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/w_op
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/r_op
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/w_address
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/r_address
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/write_data
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/req_op
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/req_tag
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/req_index
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/valid_request
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/data_out
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/op_out
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/read_stall
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/w_index
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/w_tag
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/r_index
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/r_tag
add wave -noupdate -radix hexadecimal -childformat {{{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_data[7]} -radix unsigned} {{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_data[6]} -radix unsigned} {{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_data[5]} -radix unsigned} {{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_data[4]} -radix unsigned} {{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_data[3]} -radix unsigned} {{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_data[2]} -radix unsigned} {{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_data[1]} -radix unsigned} {{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_data[0]} -radix unsigned}} -subitemconfig {{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_data[7]} {-height 15 -radix unsigned} {/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_data[6]} {-height 15 -radix unsigned} {/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_data[5]} {-height 15 -radix unsigned} {/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_data[4]} {-height 15 -radix unsigned} {/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_data[3]} {-height 15 -radix unsigned} {/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_data[2]} {-height 15 -radix unsigned} {/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_data[1]} {-height 15 -radix unsigned} {/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_data[0]} {-height 15 -radix unsigned}} /non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_data
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_tags
add wave -noupdate -radix hexadecimal -childformat {{{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_ops[7]} -radix hexadecimal} {{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_ops[6]} -radix hexadecimal} {{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_ops[5]} -radix hexadecimal} {{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_ops[4]} -radix hexadecimal} {{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_ops[3]} -radix hexadecimal} {{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_ops[2]} -radix hexadecimal} {{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_ops[1]} -radix hexadecimal} {{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_ops[0]} -radix hexadecimal}} -subitemconfig {{/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_ops[7]} {-height 15 -radix hexadecimal} {/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_ops[6]} {-height 15 -radix hexadecimal} {/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_ops[5]} {-height 15 -radix hexadecimal} {/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_ops[4]} {-height 15 -radix hexadecimal} {/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_ops[3]} {-height 15 -radix hexadecimal} {/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_ops[2]} {-height 15 -radix hexadecimal} {/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_ops[1]} {-height 15 -radix hexadecimal} {/non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_ops[0]} {-height 15 -radix hexadecimal}} /non_blocking_cache_tb/DUT/DM_CACHE/BLOCK_ops
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/valid
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/index_r
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/tag_r
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/DM_CACHE/op_r
add wave -noupdate -divider MSHR
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/valid_request
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/requested_tag
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/requested_index
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/requested_operation
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/mm_ret_data
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/mm_ret_operation
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/mm_ret_valid
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/received_request
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/miss_returned
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/stall
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/miss_data
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/miss_tag
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/miss_index
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/miss_operation
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/mm_req
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/mm_req_operation
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/mm_req_valid
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/valid_r
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/tag_r
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/index_r
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/op_r
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/avail_index
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/ret_index
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/stall_on_next
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/clear_row
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/update_index
add wave -noupdate -radix hexadecimal /non_blocking_cache_tb/DUT/MSHR/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {210123 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {170738 ps} {480488 ps}
