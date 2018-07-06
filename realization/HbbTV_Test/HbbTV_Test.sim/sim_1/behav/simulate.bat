@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xsim HbbTV_Test_tb_behav -key {Behavioral:sim_1:Functional:HbbTV_Test_tb} -tclbatch HbbTV_Test_tb.tcl -view D:/DiplomskiHbbTV/sim/BeepTest_tb_behav.wcfg -view D:/DiplomskiHbbTV/sim/FlashTest_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
