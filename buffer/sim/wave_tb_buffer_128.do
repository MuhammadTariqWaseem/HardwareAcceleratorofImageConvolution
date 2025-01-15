onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_buffer_128/clk
add wave -noupdate -radix hexadecimal /tb_buffer_128/busy
add wave -noupdate -radix hexadecimal /tb_buffer_128/reset
add wave -noupdate -radix hexadecimal /tb_buffer_128/buffermode
add wave -noupdate -radix hexadecimal /tb_buffer_128/wren_b
add wave -noupdate -radix hexadecimal /tb_buffer_128/hold_mode
add wave -noupdate -radix hexadecimal /tb_buffer_128/w_data
add wave -noupdate -radix hexadecimal /tb_buffer_128/addr_image
add wave -noupdate -radix hexadecimal /tb_buffer_128/addr_kernal
add wave -noupdate -radix hexadecimal /tb_buffer_128/addr_conv
add wave -noupdate -radix hexadecimal /tb_buffer_128/mat_row
add wave -noupdate -radix hexadecimal /tb_buffer_128/mat_col
add wave -noupdate -radix unsigned /tb_buffer_128/matched
add wave -noupdate -radix unsigned /tb_buffer_128/miss_matched
add wave -noupdate -radix hexadecimal /tb_buffer_128/kernal
add wave -noupdate -radix hexadecimal -childformat {{{/tb_buffer_128/data_mat_exp[8]} -radix hexadecimal} {{/tb_buffer_128/data_mat_exp[7]} -radix hexadecimal} {{/tb_buffer_128/data_mat_exp[6]} -radix hexadecimal} {{/tb_buffer_128/data_mat_exp[5]} -radix hexadecimal} {{/tb_buffer_128/data_mat_exp[4]} -radix hexadecimal} {{/tb_buffer_128/data_mat_exp[3]} -radix hexadecimal} {{/tb_buffer_128/data_mat_exp[2]} -radix hexadecimal} {{/tb_buffer_128/data_mat_exp[1]} -radix hexadecimal} {{/tb_buffer_128/data_mat_exp[0]} -radix hexadecimal}} -subitemconfig {{/tb_buffer_128/data_mat_exp[8]} {-radix hexadecimal} {/tb_buffer_128/data_mat_exp[7]} {-radix hexadecimal} {/tb_buffer_128/data_mat_exp[6]} {-radix hexadecimal} {/tb_buffer_128/data_mat_exp[5]} {-radix hexadecimal} {/tb_buffer_128/data_mat_exp[4]} {-radix hexadecimal} {/tb_buffer_128/data_mat_exp[3]} {-radix hexadecimal} {/tb_buffer_128/data_mat_exp[2]} {-radix hexadecimal} {/tb_buffer_128/data_mat_exp[1]} {-radix hexadecimal} {/tb_buffer_128/data_mat_exp[0]} {-radix hexadecimal}} /tb_buffer_128/data_mat_exp
add wave -noupdate -radix hexadecimal /tb_buffer_128/data_mat
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {173601750 ps}
