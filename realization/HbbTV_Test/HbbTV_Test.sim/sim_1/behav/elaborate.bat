@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto 811531c13d77419ba82caf0e966c4130 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot FlashTest_tb_behav xil_defaultlib.FlashTest_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
