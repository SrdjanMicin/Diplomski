-- File                  : BeepTest_tb.vhd
-- Author                : Srdjan Micin <Srdjan.Micin@rt-rk.com>
-- Created               : May 30, 2018, 11:22 CDT
--
------------------------------------------------------------------------------------------------------------
--
--    $RCSfile:  $
--   $Revision:  $
--     $Author:  $
--       $Date:  $
--     $Source:  $
--
-- Description:  <description>
--
-------------------------------------------------------------------------------------------------------------
-- The following is company Confidential Information.
-- Copyright  (c)  2017
-- All rights reserved. This program is protected as an
-- unpublished work under the Copyright Act of 1976 and the ComputerSoftware
-- Act of 1980. This program is also considered a trade secret. It is not to
-- be disclosed or used by parties who have not received written authorization
-- from Company, Inc.
-------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BeepTest_tb is

end BeepTest_tb;

architecture Behavioral of BeepTest_tb is

    component BeepTest is 
        Port    (
                    iCLK                : in  std_logic;
                    inRST               : in  std_logic;
                    inSAMPLES           : in  std_Logic_vector(31 downto 0);
                    inSAMPLES_VALID     : in  std_logic;
					outREADY			: out std_logic;
                    outCOMPARE_RESULT   : out std_logic    
                );
    end component BeepTest;

    component AudioGen is
        Port    (
                    iCLK    : in  std_logic;
                    inRST   : in  std_logic;
                    m_axis_data_tready  : in  std_logic;
                    m_axis_data_tvalid  : out std_logic;
                    m_axis_data_tlast   : out std_logic;
                    m_axis_data_tdata   : out std_logic_vector(31 downto 0)
                );
    end component AudioGen;

signal clk      : std_logic;
signal reset    : std_logic := '0';    
signal s_ready  : std_logic := '1';
signal s_valid  : std_logic;
signal s_last   : std_logic;
signal s_data   : std_logic_vector(31 downto 0);
signal s_result     : std_logic; 
 
begin

    SCB:    BeepTest port map 	(
									iCLK                => clk,
									inRST               => reset,
									inSAMPLES           => s_data,
									inSAMPLES_VALID     => s_valid,
									outREADY			=> s_ready,
									outCOMPARE_RESULT   => s_result
								);    
    generator:    AudioGen port map	(
										iCLK    => clk,
										inRST   => reset,
										m_axis_data_tready  => s_ready,
										m_axis_data_tvalid  => s_valid,
										m_axis_data_tlast   => s_last,
										m_axis_data_tdata   => s_data 
									);    

clk_process:    process
                begin
                    clk <= '0';
                    wait for 0.02ms;
                    clk <= '1';
                    wait for 0.02ms;
                end process;

    rst:    process
            begin
                wait for 0.1ms;
                reset <= '1';
                wait;
            end process;
end Behavioral;

-------------------------------------------------------------------------------------------------------------
--                                         Revision History
-------------------------------------------------------------------------------------------------------------
--
--  $Log:  $


-------------------------------------------------------------------------------------------------------------