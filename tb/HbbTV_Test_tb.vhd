-- File                  : HbbTV_Test_tb.vhd
-- Author                : Srdjan Micin <Srdjan.Micin@rt-rk.com>
-- Created               : July 6, 2018, 11:02 CDT
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity HbbTV_Test_tb is
--	Port	();
end HbbTV_Test_tb;

architecture Behavioral of HbbTV_Test_tb is

component HbbTV_Test is
	Port	(
				iCLK					: in  std_logic;
				inRST					: in  std_logic;
				inPIXELS				: in  std_logic_vector(31 downto 0);
				inLAST_LINE				: in  std_logic;
				inVALID_PIXELS			: in  std_logic;
				inSTART_TRANSMISSION	: in  std_logic;
				inWIDTH                 : in  std_logic_vector(31 downto 0);
				inHEIGHT                : in  std_logic_vector(31 downto 0);
				inX1_COORDINATE			: in  std_logic_vector(31 downto 0);
				inX2_COORDINATE			: in  std_logic_vector(31 downto 0);
				inX3_COORDINATE			: in  std_logic_vector(31 downto 0);
				inX4_COORDINATE			: in  std_logic_vector(31 downto 0);
				inY1_COORDINATE			: in  std_logic_vector(31 downto 0);
				inY2_COORDINATE			: in  std_logic_vector(31 downto 0);
				inVIDEO_BORDER			: in  std_logic_vector(31 downto 0);
				
				inSAMPLES				: in  std_logic_vector(31 downto 0);
				inSAMPLES_VALID			: in  std_logic;
				inAUDIO_BORDER			: in  std_logic_vector(31 downto 0);
				
				outVIDEO_READY			: out std_logic;
				outAUDIO_READY			: out std_logic;
				outTIME					: out std_logic_vector(15 downto 0)
			);
end component HbbTV_Test;

component VideoGen is
	Generic	(
				source_file_path	: string := "file.txt";
				width	: integer := 1280;
				height	: integer := 720;
				delay	: integer := 12				
			);
	Port	(
				iCLK				: in  std_logic;
				inRST				: in  std_logic;
				inREAD_PIC          : in  std_logic;
				m_axis_video_tready	: in  std_logic;
				m_axis_video_tdata	: out std_logic_vector(31 downto 0);
				m_axis_video_tvalid	: out std_logic;
				m_axis_video_tuser	: out std_logic;
				m_axis_video_tlast	: out std_logic
			);
end component VideoGen;

component AudioGen is
	Port	(
				iCLK				: in  std_logic;
				inRST				: in  std_logic;
				m_axis_data_tready	: in  std_logic;
				m_axis_data_tvalid	: out std_logic;
				m_axis_data_tlast	: out std_logic;
				m_axis_data_tdata	: out std_logic_vector(31 downto 0)
			);
end component AudioGen;

-- signali za video signal
signal pic_start      : std_logic := '0';

signal video_clk			: std_logic;
signal reset			: std_logic := '0';
signal pixels			: std_logic_vector(31 downto 0);
signal video_last_line	: std_logic;
signal video_valid		: std_logic;
signal video_start		: std_logic;
signal video_ready		: std_logic;
signal column			: std_logic_vector(31 downto 0);
signal row				: std_logic_vector(31 downto 0);
signal width            : std_logic_vector(31 downto 0);
signal height           : std_logic_vector(31 downto 0);
signal x1				: std_logic_vector(31 downto 0);
signal x2				: std_logic_vector(31 downto 0);
signal x3				: std_logic_vector(31 downto 0);
signal x4				: std_logic_vector(31 downto 0);
signal y1				: std_logic_vector(31 downto 0);
signal y2				: std_logic_vector(31 downto 0);
signal video_border		: std_logic_vector(31 downto 0);
signal pixels_out		: std_logic_vector(31 downto 0);

-- signali za audio signal

signal audio_clk        : std_logic;
signal audio_ready		: std_logic;
signal audio_valid		: std_logic;
signal audio_last		: std_logic;
signal audio_data		: std_logic_vector(31 downto 0);
signal audio_border		: std_logic_vector(31 downto 0);

-- signali za timing blok
signal time_diff		: std_logic_vector(15 downto 0);
begin

	video_generator:	VideoGen generic map	(
													source_file_path	=> "D:\DiplomskiHbbTV\docs",
													width	=> 1280,
													height	=> 720,
													delay	=> 12
												)
								port map	(
												iCLK				=> video_clk,
												inRST				=> reset,
												inREAD_PIC          => pic_start,
												m_axis_video_tdata	=> pixels,
												m_axis_video_tvalid	=> video_valid,
												m_axis_video_tready	=> video_ready,
												m_axis_video_tuser	=> video_start,
												m_axis_video_tlast	=> video_last_line
											);
											
	audio_generator:	AudioGen port map	(
												iCLK 				=> audio_clk,
												inRST				=> reset,
												m_axis_data_tready	=> audio_ready,
												m_axis_data_tvalid	=> audio_valid,
												m_axis_data_tlast	=> audio_last,
												m_axis_data_tdata	=> audio_data
											);
											
UUT	:HbbTV_Test port map	(
								iCLK 					=> video_clk,
								inRST					=> reset,
								inPIXELS				=> pixels,
								inLAST_LINE				=> video_last_line,
								inVALID_PIXELS			=> video_valid,
								inSTART_TRANSMISSION	=> video_start,
								inWIDTH                 => width,
								inHEIGHT                => height,
								inX1_COORDINATE			=> x1,
								inX2_COORDINATE			=> x2,
								inX3_COORDINATE			=> x3,
								inX4_COORDINATE			=> x4,
								inY1_COORDINATE			=> y1,
								inY2_COORDINATE			=> y2,
								inVIDEO_BORDER			=> video_border,
								inSAMPLES				=> audio_data,
								inSAMPLES_VALID			=> audio_valid,
								inAUDIO_BORDER			=> audio_border,
								outVIDEO_READY			=> video_ready,
								outAUDIO_READY			=> audio_ready,
								outTIME					=> time_diff	
							);
							
	video_ready <= '1';
	audio_ready <= '1';
	width  <= std_logic_vector(to_unsigned(1280/2,32));
	height <= std_logic_vector(to_unsigned(720,32)); 
	x1 <= std_logic_vector(to_unsigned(211,32));
	x2 <= std_logic_vector(to_unsigned(427,32));
	x3 <= std_logic_vector(to_unsigned(852,32));
	x4 <= std_logic_vector(to_unsigned(1067,32));
	y1 <= std_logic_vector(to_unsigned(539,32));
	y2 <= std_logic_vector(to_unsigned(719,32));
	video_border <= std_logic_vector(to_unsigned(1742923,32));
	audio_border <= std_logic_vector(to_unsigned(8586,32));

clk_process:	process
				begin
					video_clk <= '0';
					audio_clk <= '0';
					wait for 10ns;
					video_clk <= '1';
					audio_clk <= '1';
					wait for 10ns;
				end process clk_process;
				
	   start:  process
	           begin
	               reset <= '0';
	               wait for 50ns;
	               reset <= '1';
	               pic_start <= '1';
	               wait for 70ns;
	               pic_start <= '0';
	               wait;
	           end process;
	
end Behavioral;

-------------------------------------------------------------------------------------------------------------
--                                         Revision History
-------------------------------------------------------------------------------------------------------------
--
--  $Log:  $


-------------------------------------------------------------------------------------------------------------