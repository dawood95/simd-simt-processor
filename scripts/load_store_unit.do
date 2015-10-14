onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /load_store_unit_tb/clk
add wave -noupdate /load_store_unit_tb/nRST
add wave -noupdate /load_store_unit_tb/LS/CLK
add wave -noupdate /load_store_unit_tb/LS/nRST
add wave -noupdate /load_store_unit_tb/LS/index
add wave -noupdate /load_store_unit_tb/LS/nextIndex
add wave -noupdate /load_store_unit_tb/LS/isData
add wave -noupdate /load_store_unit_tb/LS/daddr
add wave -noupdate /load_store_unit_tb/LS/dstore
add wave -noupdate /load_store_unit_tb/lsif/dhalt
add wave -noupdate /load_store_unit_tb/lsif/readReq
add wave -noupdate /load_store_unit_tb/lsif/writeReq
add wave -noupdate /load_store_unit_tb/lsif/instReq
add wave -noupdate /load_store_unit_tb/lsif/dHit
add wave -noupdate /load_store_unit_tb/lsif/iHit
add wave -noupdate /load_store_unit_tb/lsif/isVector
add wave -noupdate /load_store_unit_tb/lsif/flushed
add wave -noupdate /load_store_unit_tb/lsif/sdaddr
add wave -noupdate /load_store_unit_tb/lsif/sdstore
add wave -noupdate /load_store_unit_tb/lsif/sdload
add wave -noupdate /load_store_unit_tb/lsif/iaddr
add wave -noupdate /load_store_unit_tb/lsif/iload
add wave -noupdate /load_store_unit_tb/lsif/chalt
add wave -noupdate /load_store_unit_tb/lsif/imemREN
add wave -noupdate /load_store_unit_tb/lsif/dmemREN
add wave -noupdate /load_store_unit_tb/lsif/dmemWEN
add wave -noupdate /load_store_unit_tb/lsif/icacheHit
add wave -noupdate /load_store_unit_tb/lsif/dcacheHit
add wave -noupdate /load_store_unit_tb/lsif/dmemaddr
add wave -noupdate /load_store_unit_tb/lsif/dmemstore
add wave -noupdate /load_store_unit_tb/lsif/dmemload
add wave -noupdate /load_store_unit_tb/lsif/imemaddr
add wave -noupdate /load_store_unit_tb/lsif/imemload
add wave -noupdate {/load_store_unit_tb/ccif/iwait[0]}
add wave -noupdate {/load_store_unit_tb/ccif/dwait[0]}
add wave -noupdate {/load_store_unit_tb/ccif/iREN[0]}
add wave -noupdate {/load_store_unit_tb/ccif/dREN[0]}
add wave -noupdate {/load_store_unit_tb/ccif/dWEN[0]}
add wave -noupdate -expand /load_store_unit_tb/ccif/iload
add wave -noupdate -expand /load_store_unit_tb/ccif/dload
add wave -noupdate -expand /load_store_unit_tb/ccif/dstore
add wave -noupdate -expand /load_store_unit_tb/ccif/iaddr
add wave -noupdate -expand /load_store_unit_tb/ccif/daddr
add wave -noupdate /load_store_unit_tb/ccif/ccwait
add wave -noupdate /load_store_unit_tb/ccif/ccinv
add wave -noupdate /load_store_unit_tb/ccif/ccwrite
add wave -noupdate /load_store_unit_tb/ccif/cctrans
add wave -noupdate /load_store_unit_tb/ccif/ccsnoopaddr
add wave -noupdate /load_store_unit_tb/ccif/ramWEN
add wave -noupdate /load_store_unit_tb/ccif/ramREN
add wave -noupdate /load_store_unit_tb/ccif/ramstate
add wave -noupdate /load_store_unit_tb/ccif/ramaddr
add wave -noupdate /load_store_unit_tb/ccif/ramstore
add wave -noupdate /load_store_unit_tb/ccif/ramload
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {101849 ps} 0}
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
WaveRestoreZoom {0 ps} {256 ns}
