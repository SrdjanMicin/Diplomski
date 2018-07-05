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

entity TimeDiff is
	Port	(
				iCLK	: in std_logic;
				inRST	: in std_logic;
				inFLASH	: in std_logic;
				inBEEP	: in std_logic;
				
				outTIME	: out std_logic_vector(15 downto 0)
			);
end TimeDiff;

architecture Behavioral of TimeDiff is

begin

end Behavioral;
-------------------------------------------------------------------------------------------------------------
--                                         Revision History
-------------------------------------------------------------------------------------------------------------
--
--  $Log:  $


-------------------------------------------------------------------------------------------------------------