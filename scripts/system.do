onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/DUT/CPU/CLK
add wave -noupdate -divider ram
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/ramREN
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/ramWEN
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/ramaddr
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/ramstore
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/ramload
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/ramstate
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/memREN
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/memWEN
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/memaddr
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/scif/memstore
add wave -noupdate -divider dp
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/CLK
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/nRST
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/control_unit/iinstr
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/control_unit/jinstr
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/control_unit/rinstr
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/instr
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/immExt
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/pc
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/pc_next
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/pcEn
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/r_req
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/w_req
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/porta_sel
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/immExt_sel
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/wMemReg_sel
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/brEn
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/portb_sel
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/pc_sel
add wave -noupdate -expand -group Datapath /system_tb/DUT/CPU/DP/regW_sel
add wave -noupdate -divider loadstore
add wave -noupdate /system_tb/DUT/CPU/lsif/dhalt
add wave -noupdate /system_tb/DUT/CPU/lsif/readReq
add wave -noupdate /system_tb/DUT/CPU/lsif/writeReq
add wave -noupdate /system_tb/DUT/CPU/lsif/instReq
add wave -noupdate /system_tb/DUT/CPU/lsif/dHit
add wave -noupdate /system_tb/DUT/CPU/lsif/iHit
add wave -noupdate /system_tb/DUT/CPU/lsif/isVector
add wave -noupdate /system_tb/DUT/CPU/lsif/flushed
add wave -noupdate /system_tb/DUT/CPU/lsif/sdaddr
add wave -noupdate /system_tb/DUT/CPU/lsif/sdstore
add wave -noupdate /system_tb/DUT/CPU/lsif/sdload
add wave -noupdate /system_tb/DUT/CPU/lsif/iaddr
add wave -noupdate /system_tb/DUT/CPU/lsif/iload
add wave -noupdate /system_tb/DUT/CPU/lsif/chalt
add wave -noupdate /system_tb/DUT/CPU/lsif/imemREN
add wave -noupdate /system_tb/DUT/CPU/lsif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/lsif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/lsif/icacheHit
add wave -noupdate /system_tb/DUT/CPU/lsif/dcacheHit
add wave -noupdate /system_tb/DUT/CPU/lsif/dmemaddr
add wave -noupdate /system_tb/DUT/CPU/lsif/dmemstore
add wave -noupdate /system_tb/DUT/CPU/lsif/dmemload
add wave -noupdate /system_tb/DUT/CPU/lsif/imemaddr
add wave -noupdate /system_tb/DUT/CPU/lsif/imemload
add wave -noupdate /system_tb/DUT/CPU/load_store/index
add wave -noupdate /system_tb/DUT/CPU/load_store/nextIndex
add wave -noupdate /system_tb/DUT/CPU/load_store/isData
add wave -noupdate /system_tb/DUT/CPU/load_store/iHit
add wave -noupdate /system_tb/DUT/CPU/lsif/vdaddr
add wave -noupdate /system_tb/DUT/CPU/lsif/vdstore
add wave -noupdate /system_tb/DUT/CPU/lsif/vdload
add wave -noupdate /system_tb/DUT/CPU/load_store/daddr
add wave -noupdate /system_tb/DUT/CPU/load_store/dstore
add wave -noupdate /system_tb/DUT/CPU/DP/vlif/porta
add wave -noupdate /system_tb/DUT/CPU/DP/vlif/portb
add wave -noupdate /system_tb/DUT/CPU/DP/vlif/out
add wave -noupdate -expand /system_tb/DUT/CPU/DP/vlif/op
add wave -noupdate -divider reg
add wave -noupdate /system_tb/DUT/CPU/DP/vfif/wsel
add wave -noupdate /system_tb/DUT/CPU/DP/vfif/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP/vfif/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP/sca_file/register_file
add wave -noupdate -expand /system_tb/DUT/CPU/DP/vec_file/register_file
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {188606 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 215
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
WaveRestoreZoom {134948 ps} {242670 ps}
