onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top_calculator/clock_50m
add wave -noupdate /tb_top_calculator/pb
add wave -noupdate /tb_top_calculator/fnd_s
add wave -noupdate /tb_top_calculator/fnd_d
add wave -noupdate /tb_top_calculator/sw_clk
add wave -noupdate /tb_top_calculator/fnd_clk
add wave -noupdate -radix hexadecimal /tb_top_calculator/eBCD
add wave -noupdate /tb_top_calculator/rst
add wave -noupdate -radix decimal /tb_top_calculator/ans
add wave -noupdate -radix decimal /tb_top_calculator/operand1
add wave -noupdate -radix decimal /tb_top_calculator/operand2
add wave -noupdate -radix hexadecimal /tb_top_calculator/operator
add wave -noupdate /tb_top_calculator/cal_enable
add wave -noupdate -radix decimal /tb_top_calculator/fnd_serial
add wave -noupdate /tb_top_calculator/UI/sw_clk
add wave -noupdate /tb_top_calculator/UI/rst
add wave -noupdate -radix hexadecimal /tb_top_calculator/UI/eBCD
add wave -noupdate -radix decimal /tb_top_calculator/UI/ans
add wave -noupdate -radix decimal /tb_top_calculator/UI/operand1
add wave -noupdate -radix decimal /tb_top_calculator/UI/operand2
add wave -noupdate -radix decimal /tb_top_calculator/UI/operator
add wave -noupdate /tb_top_calculator/UI/cal_enable
add wave -noupdate -radix decimal /tb_top_calculator/UI/fnd_serial
add wave -noupdate -radix hexadecimal /tb_top_calculator/UI/state
add wave -noupdate /tb_top_calculator/UI/signBit
add wave -noupdate -radix hexadecimal /tb_top_calculator/UI/buffer
add wave -noupdate -radix hexadecimal /tb_top_calculator/UI/cnt_buffer
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 237
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {930 ns}
