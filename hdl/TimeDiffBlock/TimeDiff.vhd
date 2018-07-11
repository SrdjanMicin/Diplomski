-- File                  : TimeDiff.vhd
-- Author                : Srdjan Micin <Srdjan.Micin@rt-rk.com>
-- Created               : July 5, 2018, 12:56 CDT
--
------------------------------------------------------------------------------------------------------------
--
--    $RCSfile:  $
--   $Revision:  $
--     $Author:  $
--       $Date:  $
--     $Source:  $
--
-- Description:	Measures time difference between flashes and beeps
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TimeDiff is
	Port	(
				iCLK            : in std_logic;
				inRST           : in std_logic;
				inFLASH	        : in std_logic;
				inBEEP          : in std_logic;
				
				outTIME_DIFF    : out std_logic_vector(15 downto 0)
			);
end TimeDiff;

architecture Behavioral of TimeDiff is

signal sTIME 		: integer := 0;
signal sFLASH_TIME	: integer := 0;
signal sBEEP_TIME	: integer := 0;
signal sCOUNT_DIFF	: integer := 1;
signal sDIFF_TIME	: integer := 0;
signal sCONTROL		: std_logic := '0';

begin
	
	time_frame:	process(iCLK)
				begin
					if(iCLK'event and iCLK = '1') then
						if(inRST = '0') then
							sTIME 		<= 0;
							sCONTROL	<= '0';
							sFLASH_TIME	<= 0;
							sBEEP_TIME	<= 0;
							sDIFF_TIME	<= 0;
						else
							if(sTIME >= 1500) then
								sTIME <= 0;
							else
								if(inFLASH = '0' and inBEEP = '0' and sCONTROL = '0') then
									sCONTROL <= '0';
									sCOUNT_DIFF <= 1;
								elsif(inFLASH = '0' and inBEEP = '0' and sCONTROL = '1') then
									sCONTROL <= '1';
									sCOUNT_DIFF <= sCOUNT_DIFF + 1;
								elsif(inFLASH = '0' and inBEEP = '1' and sCONTROL = '0') then
									sCONTROL <= '0';
									sCOUNT_DIFF <= 1;
								elsif(inFLASH = '0' and inBEEP = '1' and sCONTROL = '1') then
									sCONTROL <= '0';
									sCOUNT_DIFF <= 1;
								elsif(inFLASH = '1' and inBEEP = '0' and sCONTROL = '0') then
									sCONTROL <= '1';
									sCOUNT_DIFF <= sCOUNT_DIFF + 1;
								elsif(inFLASH = '1' and inBEEP = '0' and sCONTROL = '1') then
									sCONTROL <= '1';
									sCOUNT_DIFF <= sCOUNT_DIFF + 1;
								else
									sCOUNT_DIFF <= 0;
								end if;
								
								sTIME <= sTIME + 1;
						   end if;
						end if;
					end if;
				end process time_frame;
				
	outTIME_DIFF <= std_logic_vector(to_unsigned(sCOUNT_DIFF,16));
	
end Behavioral;
-------------------------------------------------------------------------------------------------------------
--                                         Revision History
-------------------------------------------------------------------------------------------------------------
--
--  $Log:  $


-------------------------------------------------------------------------------------------------------------