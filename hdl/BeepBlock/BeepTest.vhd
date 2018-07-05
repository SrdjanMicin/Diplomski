-- File                  : BeepTest.vhd
-- Author                : Srdjan Micin <Srdjan.Micin@rt-rk.com>
-- Created               : May 29, 2018, 13:27 CDT
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
use IEEE.NUMERIC_STD.ALL;


entity BeepTest is
  Port  (
            iCLK                : in  std_logic;
            inRST               : in  std_logic;
            inSAMPLES           : in  std_logic_vector(31 downto 0);
            inSAMPLES_VALID     : in  std_logic;
			outREADY			: out std_logic;
            outCOMPARE_RESULT   : out std_logic 
        );
end BeepTest;

architecture Behavioral of BeepTest is

    component AverageSum is
        Port    (
                    iCLK                            : in  std_logic;
                    inRST                           : in  std_logic;
                    inSAMPLES_DATA                  : in  std_logic_vector(31 downto 0);
                    inSAMPLES_DATA_VALID            : in  std_logic;
                    outAVERAGE_SUM_LEFT_CHANNEL     : out std_logic_vector(31 downto 0);
                    outAVERAGE_SUM_RIGHT_CHANNEL    : out std_logic_vector(31 downto 0)
                );
    end component AverageSum;

signal sAVERAGE_SUM_LEFT_CHANNEL : std_logic_vector(31 downto 0);
signal sAVERAGE_SUM_RIGHT_CHANNEL : std_logic_vector(31 downto 0);

begin

	outREADY <= '1';

    SAMPLE_SUM_BLOCK:   AverageSum port map	(
												iCLK                            => iCLK,
												inRST                           => inRST,
												inSAMPLES_DATA                  => inSAMPLES,
												inSAMPLES_DATA_VALID            => inSAMPLES_VALID,       
												outAVERAGE_SUM_LEFT_CHANNEL     => sAVERAGE_SUM_LEFT_CHANNEL,
												outAVERAGE_SUM_RIGHT_CHANNEL    => sAVERAGE_SUM_RIGHT_CHANNEL
											);

end Behavioral;

-------------------------------------------------------------------------------------------------------------
--                                         Revision History
-------------------------------------------------------------------------------------------------------------
--
--  $Log:  $


-------------------------------------------------------------------------------------------------------------