-- File                  : FlashTest.vhd
-- Author                : Srdjan Micin <Srdjan.Micin@rt-rk.com>
-- Created               : July 4, 2018, 11:50 CDT
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use STD.textio.all;

entity FlashTest_tb is
--  Port ( );
end FlashTest_tb;

architecture Behavioral of FlashTest_tb is

component FlashTest is
  Port  (
            iCLK                    : in std_logic;
            inRST                   : in std_logic;
            inPIXELS                : in std_logic_vector(31 downto 0);
            inLAST_LINE             : in std_logic;
            inVALID_PIXELS          : in std_logic;
            inSTART_TRANSMISSION    : in std_logic;
            inX1_COORDINATE         : in std_logic_vector(31 downto 0); 
            inX2_COORDINATE         : in std_logic_vector(31 downto 0); 
            inX3_COORDINATE         : in std_logic_vector(31 downto 0); 
            inX4_COORDINATE         : in std_logic_vector(31 downto 0); 
            inY1_COORDINATE         : in std_logic_vector(31 downto 0); 
            inY2_COORDINATE         : in std_logic_vector(31 downto 0);
            inBORDER_VALUE          : in std_logic_vector(31 downto 0);
            
            outREADY                : out std_logic 
        );
end component FlashTest;

component VideoGen is
    Generic (
     number_of_pictures     : integer;
     source_file_path1 	    : string :="file.txt";
--     source_file_path2   	: string :="file.txt";
--     source_file_path3 	    : string :="file.txt";
--     source_file_path4 	    : string :="file.txt";
--     source_file_path5 	    : string :="file.txt";
     width  : integer := 1920;   --Image width
     height : integer := 1080;   --Image height
     delay  : integer := 12    --Delay number of clk periods between frames 
    );
    Port ( 
            iCLK                : in  STD_LOGIC;                        --input CLK 
            inRST               : in  STD_LOGIC;                        --active LOW Reset
            m_axis_video_tdata  : out STD_LOGIC_VECTOR (31 downto 0);   --output Video Data 32bits width
            m_axis_video_tvalid : out STD_LOGIC;                        --output Valid signal
            m_axis_video_tready : in  STD_LOGIC;                        --input Ready signal from slave
            m_axis_video_tuser  : out STD_LOGIC;                        --output Start Of Frame pulse signal
            m_axis_video_tlast  : out STD_LOGIC                         --output End of Line pulse signal
         );
end component VideoGen;

-- slike za testiranje vise frejmova
constant slika  : string    := "D:\Diplomski\jpeg test pattern generator\BMPtoYCbCr\Paint_slike"; 

signal clk          : std_logic;
signal reset        : std_logic;
signal pixels       : std_logic_vector(31 downto 0);
signal last_line    : std_logic;
signal valid        : std_logic;
signal start        : std_logic;
signal ready        : std_logic;
signal column       : std_logic_vector(31 downto 0);
signal row          : std_logic_vector(31 downto 0);

signal x1           : std_logic_vector(31 downto 0);            
signal x2           : std_logic_vector(31 downto 0);            
signal x3           : std_logic_vector(31 downto 0);            
signal x4           : std_logic_vector(31 downto 0);            
signal y1           : std_logic_vector(31 downto 0);            
signal y2           : std_logic_vector(31 downto 0);
signal border       : std_logic_vector(31 downto 0);

signal pixels_out   : std_logic_vector(31 downto 0); 

begin

    generator: VideoGen
        Generic map (
                        number_of_pictures  => 116,
                        source_file_path1   => slika,
                        width  => 1920,   
                        height => 1080,   
                        delay  => 12    
                    )
        Port map( 
                iCLK                => clk,
                inRST               => reset,
                m_axis_video_tdata  => pixels,
                m_axis_video_tvalid => valid,
                m_axis_video_tready => ready,
                m_axis_video_tuser  => start,
                m_axis_video_tlast  => last_line
             );
   
UUT: FlashTest port map	(
							iCLK                    => clk,
							inRST                   => reset,                 
							inPIXELS                => pixels,               
							inLAST_LINE             => last_line,     
							inVALID_PIXELS          => valid,
							inSTART_TRANSMISSION    => start,
							inX1_COORDINATE         => x1,        
							inX2_COORDINATE         => x2,
							inX3_COORDINATE         => x3,
							inX4_COORDINATE         => x4,   
							inY1_COORDINATE         => y1,
							inY2_COORDINATE         => y2,
							inBORDER_VALUE          => border,         
							outREADY                => ready                      
						);
                                

                               
            reset <= '1';
            ready <= '1';
            x1 <= std_logic_vector(to_unsigned(318,32));
            x2 <= std_logic_vector(to_unsigned(640,32));
            x3 <= std_logic_vector(to_unsigned(1279,32));
            x4 <= std_logic_vector(to_unsigned(1600,32));
            y1 <= std_logic_vector(to_unsigned(809,32));
            y2 <= std_logic_vector(to_unsigned(1079,32)); 
            border <= std_logic_vector(to_unsigned(5097600,32));

clk_process: process

             begin
                clk <= '0';
                wait for 10ns;
                clk <= '1';
                wait for 10ns;
             end process clk_process;
             
end Behavioral;

-------------------------------------------------------------------------------------------------------------
--                                         Revision History
-------------------------------------------------------------------------------------------------------------
--
--  $Log:  $


-------------------------------------------------------------------------------------------------------------