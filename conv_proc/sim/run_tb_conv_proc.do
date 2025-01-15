vdel -lib work -all
vlib work
vlog -sv tb_conv_proc.sv ../rtl/conv_proc.sv 
vsim -novopt tb_conv_proc
#add wave *
do wave_tb_conv_proc.do
run -a