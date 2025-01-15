onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_conv_proc/clk
add wave -noupdate /tb_conv_proc/reset
add wave -noupdate /tb_conv_proc/w_data
add wave -noupdate /tb_conv_proc/expected
add wave -noupdate /tb_conv_proc/data_mat
add wave -noupdate /tb_conv_proc/kernal
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
WaveRestoreZoom {55 ps} {1055 ps}
