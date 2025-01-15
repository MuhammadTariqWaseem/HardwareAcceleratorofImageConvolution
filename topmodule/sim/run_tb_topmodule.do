vdel -lib work -all
vlib work
vlog -sv tb_topmodule.sv ../rtl/topmodule.sv ../../buffer/rtl/buffer.sv ../../conv_proc/rtl/conv_proc.sv ../../RAM/ram.v 
vlog -sv ../../../../../../../intelFPGA/19.1/modelsim_ase/altera/verilog/src/altera_mf.v
vsim -novopt tb_topmodule
#add wave *
do wave_tb_topmodule.do
run -a