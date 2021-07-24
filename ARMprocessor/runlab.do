# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./mux2_1.sv"
vlog "./mux2_1_VARb.sv"
vlog "./mux8_1_VARb.sv"
vlog "./mux4_1_VARB.sv"
vlog "./mux4_1.sv"
vlog "./mux8_1.sv"
vlog "./mux16_1.sv"
vlog "./mux32_1.sv"
vlog "./en_DFF_VAR.sv"
vlog "./en_D_FF.sv"
vlog "./D_FF.sv"
vlog "./en_decode2_4.sv"
vlog "./en_decode3_8.sv"
vlog "./en_decode4_16.sv"
vlog "./en_decode5_32.sv"
vlog "./regfile.sv"
vlog "./regstim.sv"
vlog "./fullAdder.sv"
vlog "./multiBitAdder.sv"
vlog "./addSubtract.sv"
vlog "./oneBitALU.sv"
vlog "./alu.sv"
vlog "./alustim.sv"
vlog "./sign_extend.sv"
vlog "./left_shift.sv"
vlog "./prog_count.sv"
vlog "./processor_cntrl.sv"
vlog "./flag_reg.sv"
vlog "./instruction_fetch.sv"
vlog "./data_op.sv"
vlog "./cpu.sv"
vlog "./instructmem.sv"
vlog "./datamem.sv"
vlog "./giant_nor.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work cpu_testbench

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do cpu_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
