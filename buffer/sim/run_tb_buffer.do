vdel -lib work -all
vlib work
vlog -sv tb_buffer_128.sv ../rtl/buffer.sv  ../../RAM/ram.v 
vlog -sv ../../../../../../../intelFPGA/19.1/modelsim_ase/altera/verilog/src/altera_mf.v
vsim -novopt tb_buffer_128
#add wave *
do wave_tb_buffer_128.do
run -a