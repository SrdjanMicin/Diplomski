-- File                  : HbbTV_Test.vhd
-- Author                : Srdjan Micin <Srdjan.Micin@rt-rk.com>
-- Created               : July 5, 2018, 13:12 CDT
--
------------------------------------------------------------------------------------------------------------
--
--    $RCSfile:  $
--   $Revision:  $
--     $Author:  $
--       $Date:  $
--     $Source:  $
--
-- Description:     
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

entity HbbTV_Test is
	Port	(
				iCLK					: in  std_logic;
				inRST					: in  std_logic;
				inPIXELS				: in  std_logic_vector(31 downto 0);
				inLAST_LINE				: in  std_logic;
				inVALID_PIXELS			: in  std_logic;
				inSTART_TRANSMISSION	: in  std_logic;
				inX1_COORDINATE			: in  std_logic_vector(31 downto 0);
				inX2_COORDINATE			: in  std_logic_vector(31 downto 0);
				inX3_COORDINATE			: in  std_logic_vector(31 downto 0);
				inX4_COORDINATE			: in  std_logic_vector(31 downto 0);
				inY1_COORDINATE			: in  std_logic_vector(31 downto 0);
				inY2_COORDINATE			: in  std_logic_vector(31 downto 0);
				inVIDEO_BORDER			: in  std_logic_vector(31 downto 0);
				
				inSAMPLES				: in  std_logic_vector(31 downto 0);
				inSAMPLES_VALID			: in  std_logic;
				
				outVIDEO_READY			: out std_logic;
				outAUDIO_READY			: out std_logic;
				outTIME					: out std_logic_vector(31 downto 0)				-- provjeriti kolika duzina vektora je dovoljna
			);
end HbbTV_Test;

architecture Behavioral of HbbTV_Test is

component FlashTest is
	Port	(
				iCLK					: in  std_logic;
				inRST					: in  std_logic;
				inPIXELS				: in  std_logic_vector(31 downto 0);
				inLAST_LINE				: in  std_logic;
				inVALID_PIXELS			: in  std_logic;
				inSTART_TRANSMISSION	: in  std_logic;
				inX1_COORDINATE			: in  std_logic_vector(31 downto 0);
				inX2_COORDINATE			: in  std_logic_vector(31 downto 0);
				inX3_COORDINATE			: in  std_logic_vector(31 downto 0);
				inX4_COORDINATE			: in  std_logic_vector(31 downto 0);
				inY1_COORDINATE			: in  std_logic_vector(31 downto 0);
				inY2_COORDINATE			: in  std_logic_vector(31 downto 0);
				inBORDER_VALUE			: in  std_logic_vector(31 downto 0);
				
				outRESULT				: out std_logic;
				outREADY				: out std_logic
			);
end component FlashTest;			
component BeepTest is
	Port	(
				iCLK				: in  std_logic;
				inRST				: in  std_logic;
				inSAMPLES			: in  std_logic_vector(31 downto 0);
				inSAMPLES_VALID		: in  std_logic;
				outREADY			: out std_logic;
				outCOMPARE_RESULT	: out std_logic
			);
end component BeepTest;
			
component TimeDiff is
	Port	(
				iCLK 	: in  std_logic;
				inRST	: in  std_logic;
				inFLASH	: in  std_logic;
				inBEEP	: in  std_logic;
				
				outTIME : out std_logic_vector(15 downto 0)
			);
end component TimeDiff;
			
signal sFLASH_RESULT	: std_logic;
signal sBEEP_RESULT		: std_logic;

-- ovaj signal je samo privremen dok ne vidimo sta cemo sa izlazom TimeDiff bloka.
signal tmpTIME : std_logic_vector(15 downto 0);

begin
	
	video_block:	FlashTest port map 	(
											iCLK 					=> iCLK,
											inRST 					=> inRST,
											inPIXELS 				=> inPIXELS,
											inLAST_LINE 			=> inLAST_LINE,
											inVALID_PIXELS 			=> inVALID_PIXELS,
											inSTART_TRANSMISSION	=> inSTART_TRANSMISSION,
											inX1_COORDINATE 		=> inX1_COORDINATE,
											inX2_COORDINATE 		=> inX2_COORDINATE,
											inX3_COORDINATE 		=> inX3_COORDINATE,
											inX4_COORDINATE 		=> inX4_COORDINATE,
											inY1_COORDINATE 		=> inY1_COORDINATE,
											inY2_COORDINATE			=> inY2_COORDINATE,
											inBORDER_VALUE 			=> inVIDEO_BORDER,
											outRESULT 				=> sFLASH_RESULT,
											outREADY 				=> outVIDEO_READY
										);	
										
	audio_block:	BeepTest port map	(
											iCLK 			     => iCLK,
											inRST                => inRST,
											inSAMPLES 		     => inSAMPLES,
											inSAMPLES_VALID	     => inSAMPLES_VALID,
											outREADY             => outAUDIO_READY,
											outCOMPARE_RESULT    => sBEEP_RESULT
										);
										
	timing_block:	TimeDiff port map	(
											iCLK 	=> iCLK,
											inRST 	=> inRST,
											inFLASH	=> sFLASH_RESULT,
											inBEEP 	=> sBEEP_RESULT,
											outTIME => tmpTIME
										);
end Behavioral;
-------------------------------------------------------------------------------------------------------------
--                                         Revision History
-------------------------------------------------------------------------------------------------------------
--
--  $Log:  $


-------------------------------------------------------------------------------------------------------------