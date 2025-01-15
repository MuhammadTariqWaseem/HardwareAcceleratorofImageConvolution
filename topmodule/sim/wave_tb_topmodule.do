onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_topmodule/clk
add wave -noupdate -radix hexadecimal /tb_topmodule/reset
add wave -noupdate -radix hexadecimal /tb_topmodule/start
add wave -noupdate -radix hexadecimal /tb_topmodule/addr_image
add wave -noupdate -radix hexadecimal /tb_topmodule/addr_kernal
add wave -noupdate -radix hexadecimal -childformat {{{/tb_topmodule/addr_conv[10]} -radix hexadecimal} {{/tb_topmodule/addr_conv[9]} -radix hexadecimal} {{/tb_topmodule/addr_conv[8]} -radix hexadecimal} {{/tb_topmodule/addr_conv[7]} -radix hexadecimal} {{/tb_topmodule/addr_conv[6]} -radix hexadecimal} {{/tb_topmodule/addr_conv[5]} -radix hexadecimal} {{/tb_topmodule/addr_conv[4]} -radix hexadecimal} {{/tb_topmodule/addr_conv[3]} -radix hexadecimal} {{/tb_topmodule/addr_conv[2]} -radix hexadecimal} {{/tb_topmodule/addr_conv[1]} -radix hexadecimal} {{/tb_topmodule/addr_conv[0]} -radix hexadecimal}} -subitemconfig {{/tb_topmodule/addr_conv[10]} {-height 15 -radix hexadecimal} {/tb_topmodule/addr_conv[9]} {-height 15 -radix hexadecimal} {/tb_topmodule/addr_conv[8]} {-height 15 -radix hexadecimal} {/tb_topmodule/addr_conv[7]} {-height 15 -radix hexadecimal} {/tb_topmodule/addr_conv[6]} {-height 15 -radix hexadecimal} {/tb_topmodule/addr_conv[5]} {-height 15 -radix hexadecimal} {/tb_topmodule/addr_conv[4]} {-height 15 -radix hexadecimal} {/tb_topmodule/addr_conv[3]} {-height 15 -radix hexadecimal} {/tb_topmodule/addr_conv[2]} {-height 15 -radix hexadecimal} {/tb_topmodule/addr_conv[1]} {-height 15 -radix hexadecimal} {/tb_topmodule/addr_conv[0]} {-height 15 -radix hexadecimal}} /tb_topmodule/addr_conv
add wave -noupdate -radix hexadecimal -childformat {{{/tb_topmodule/offset[11]} -radix hexadecimal} {{/tb_topmodule/offset[10]} -radix hexadecimal} {{/tb_topmodule/offset[9]} -radix hexadecimal} {{/tb_topmodule/offset[8]} -radix hexadecimal} {{/tb_topmodule/offset[7]} -radix hexadecimal} {{/tb_topmodule/offset[6]} -radix hexadecimal} {{/tb_topmodule/offset[5]} -radix hexadecimal} {{/tb_topmodule/offset[4]} -radix hexadecimal} {{/tb_topmodule/offset[3]} -radix hexadecimal} {{/tb_topmodule/offset[2]} -radix hexadecimal} {{/tb_topmodule/offset[1]} -radix hexadecimal} {{/tb_topmodule/offset[0]} -radix hexadecimal}} -subitemconfig {{/tb_topmodule/offset[11]} {-height 15 -radix hexadecimal} {/tb_topmodule/offset[10]} {-height 15 -radix hexadecimal} {/tb_topmodule/offset[9]} {-height 15 -radix hexadecimal} {/tb_topmodule/offset[8]} {-height 15 -radix hexadecimal} {/tb_topmodule/offset[7]} {-height 15 -radix hexadecimal} {/tb_topmodule/offset[6]} {-height 15 -radix hexadecimal} {/tb_topmodule/offset[5]} {-height 15 -radix hexadecimal} {/tb_topmodule/offset[4]} {-height 15 -radix hexadecimal} {/tb_topmodule/offset[3]} {-height 15 -radix hexadecimal} {/tb_topmodule/offset[2]} {-height 15 -radix hexadecimal} {/tb_topmodule/offset[1]} {-height 15 -radix hexadecimal} {/tb_topmodule/offset[0]} {-height 15 -radix hexadecimal}} /tb_topmodule/offset
add wave -noupdate -radix hexadecimal /tb_topmodule/busy
add wave -noupdate -radix hexadecimal /tb_topmodule/done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10820879 ps} 0}
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
WaveRestoreZoom {0 ps} {11319 ns}
