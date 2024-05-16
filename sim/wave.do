onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_itype/clk
add wave -noupdate /test_itype/rst
add wave -noupdate /test_itype/flash_addr
add wave -noupdate /test_itype/flash_data
add wave -noupdate /test_itype/flash_en
add wave -noupdate /test_itype/outport
add wave -noupdate -divider Controller
add wave -noupdate /test_itype/DUT/_controller/opcode
add wave -noupdate /test_itype/DUT/_controller/regfile_wren
add wave -noupdate /test_itype/DUT/_controller/ir_wren
add wave -noupdate /test_itype/DUT/_controller/pc_inc
add wave -noupdate /test_itype/DUT/_controller/mem_wren
add wave -noupdate /test_itype/DUT/_controller/regfile_load_from_mem
add wave -noupdate /test_itype/DUT/_controller/ram_raddr_31_20
add wave -noupdate /test_itype/DUT/_controller/state
add wave -noupdate /test_itype/DUT/_controller/next_state
add wave -noupdate -divider Regfile
add wave -noupdate -color Cyan /test_itype/DUT/_datapath/_regfile/regf/clk
add wave -noupdate -color Cyan /test_itype/DUT/_datapath/_regfile/regf/rst
add wave -noupdate -color Cyan /test_itype/DUT/_datapath/_regfile/regf/wr_en
add wave -noupdate -color Cyan /test_itype/DUT/_datapath/_regfile/regf/addr_a
add wave -noupdate -color Cyan /test_itype/DUT/_datapath/_regfile/regf/addr_b
add wave -noupdate -color Cyan /test_itype/DUT/_datapath/_regfile/regf/wr_addr
add wave -noupdate -color Cyan /test_itype/DUT/_datapath/_regfile/regf/wr_data
add wave -noupdate -color Cyan /test_itype/DUT/_datapath/_regfile/regf/a
add wave -noupdate -color Cyan /test_itype/DUT/_datapath/_regfile/regf/b
add wave -noupdate -expand /test_itype/DUT/_datapath/_regfile/regf/registers
add wave -noupdate -divider ALU
add wave -noupdate /test_itype/DUT/_datapath/_alu/fn
add wave -noupdate /test_itype/DUT/_datapath/_alu/funct7
add wave -noupdate /test_itype/DUT/_datapath/_alu/a
add wave -noupdate /test_itype/DUT/_datapath/_alu/b
add wave -noupdate /test_itype/DUT/_datapath/_alu/out
add wave -noupdate -divider Datapath
add wave -noupdate /test_itype/DUT/_datapath/regfile_load_from_mem
add wave -noupdate /test_itype/DUT/_datapath/alu_out
add wave -noupdate /test_itype/DUT/_datapath/mem_rd_data
add wave -noupdate /test_itype/DUT/_datapath/regfile_wr_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {308081 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 198
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
WaveRestoreZoom {0 ps} {488250 ps}
