-- File                  : FlashTest.vhd
-- Author                : Srdjan Micin <Srdjan.Micin@rt-rk.com>
-- Created               : July 4, 2018, 11:45 CDT
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
use ieee.numeric_std.all;

entity FlashTest is
  Port  (
            iCLK                    : in std_logic;
            inRST                   : in std_logic;
            inPIXELS                : in std_logic_vector(31 downto 0);         -- ulazni pikseli
            inLAST_LINE             : in std_logic;                             -- kraj reda
            inVALID_PIXELS          : in std_logic;                             -- validni pikseli
            inSTART_TRANSMISSION    : in std_logic;                             -- pocetak novog frame-a(slike)
            inX1_COORDINATE         : in std_logic_vector(31 downto 0);         -- donja granica prvog kvadrata po X-osi
            inX2_COORDINATE         : in std_logic_vector(31 downto 0);         -- gornja granica prvog kvadrata po X-osi
            inX3_COORDINATE         : in std_logic_vector(31 downto 0);         -- donja granica drugog kvadrata po X-osi
            inX4_COORDINATE         : in std_logic_vector(31 downto 0);         -- gornja granica drugog kvadrata po X-osi
            inY1_COORDINATE         : in std_logic_vector(31 downto 0);         -- donja granica prvog i drugog kvadrata po Y-osi
            inY2_COORDINATE         : in std_logic_vector(31 downto 0);         -- gornja granica prvog i drugog kvadrata po Y-osi
            inBORDER_VALUE          : in std_logic_vector(31 downto 0);         -- srednja vrednost Y komponenti za odredjivanje bljeska 
            
            outREADY                : out std_logic                             -- blok je spreman da primi sledecu sliku
        );
end FlashTest;

architecture Behavioral of FlashTest is

component PixelCounter is
  Port  (
            iCLK                    : in  std_logic;
            inRST                   : in  std_logic;
            inPIXELS                : in  std_logic_vector(31 downto 0);
            inLAST_LINE             : in  std_logic;
            inVALID_PIXELS          : in  std_logic;
            inSTART_TRANSMISSION    : in  std_logic;
            outREADY                : out std_logic;
            outCOLUMN               : out std_logic_vector(31 downto 0);
            outROW                  : out std_logic_vector(31 downto 0);
            outPIXELS               : out std_logic_vector(31 downto 0)
        );
end component PixelCounter;

component PixelSum is
  Port  (
            iCLK                    : in  std_logic;
            inRST                   : in  std_logic;
            inCOLUMN                : in  std_logic_vector(31 downto 0);
            inROW                   : in  std_logic_vector(31 downto 0);
            inSQARE_PIXELS          : in  std_logic_vector(31 downto 0);
            inX1_COORDINATE         : in  std_logic_vector(31 downto 0);
            inX2_COORDINATE         : in  std_logic_vector(31 downto 0);
            inY1_COORDINATE         : in  std_logic_vector(31 downto 0);
            inY2_COORDINATE         : in  std_logic_vector(31 downto 0);
            inSTART_TRANSMISSION    : in  std_logic;
            outY_COMPONENT_SUM      : out std_logic_vector(31 downto 0)
        );
end component PixelSum;

component FlashCheck is
  Port  (
            iCLK                : in  std_logic;
            inRST               : in  std_logic;
            inY_FRAME_SUM       : in  std_logic_vector(31 downto 0);
            inBORDER_VALUE      : in  std_logic_vector(31 downto 0);
            inSOF               : in  std_logic;
            inEOF               : in  std_logic;
            outRESULT           : out std_logic
        );
end component FlashCheck;

signal sROW             : std_logic_vector(31 downto 0);
signal sCOLUMN          : std_logic_vector(31 downto 0);
signal sPIXELS          : std_logic_vector(31 downto 0);
signal sSUM_Y_SQARE_1   : std_logic_vector(31 downto 0);
signal sSUM_Y_SQARE_2   : std_logic_vector(31 downto 0);
signal sEND_OF_FRAME    : std_logic;
signal sRESULT_1        : std_logic;
signal sRESULT_2        : std_logic;

begin

--end of frame signal
sEND_OF_FRAME <=    '1' when unsigned(sCOLUMN) = 960 and unsigned(sROW) = 1080 and inLAST_LINE = '1' else
                    '0'; 

-- column and row counter
    COUNTER_BLOCK:  PixelCounter port map   (
                                                iCLK                    => iCLK,
                                                inRST                   => inRST,
                                                inPIXELS                => inPIXELS,
                                                inLAST_LINE             => inLAST_LINE,
                                                inVALID_PIXELS          => inVALID_PIXELS,
                                                inSTART_TRANSMISSION    => inSTART_TRANSMISSION,
                                                outREADY                => outREADY,
                                                outROW                  => sROW,
                                                outCOLUMN               => sCOLUMN,
                                                outPIXELS               => sPIXELS
                                            );
-- first square                                  
    SUMATOR_1: PixelSum port map    (
                                        iCLK                    => iCLK,
                                        inRST                   => inRST,
                                        inCOLUMN                => sCOLUMN,
                                        inROW                   => sROW,
                                        inSQARE_PIXELS          => sPIXELS,
                                        inX1_COORDINATE         => inX1_COORDINATE,
                                        inX2_COORDINATE         => inX2_COORDINATE,
                                        inY1_COORDINATE         => inY1_COORDINATE,
                                        inY2_COORDINATE         => inY2_COORDINATE,
                                        inSTART_TRANSMISSION    => inSTART_TRANSMISSION,
                                        outY_COMPONENT_SUM      => sSUM_Y_SQARE_1
                                    );
-- second square                                    
    SUMATOR_2:  PixelSum port map   (
                                        iCLK                    => iCLK,
                                        inRST                   => inRST,
                                        inCOLUMN                => sCOLUMN,
                                        inROW                   => sROW,
                                        inSQARE_PIXELS          => sPIXELS,
                                        inX1_COORDINATE         => inX3_COORDINATE,
                                        inX2_COORDINATE         => inX4_COORDINATE,
                                        inY1_COORDINATE         => inY1_COORDINATE,
                                        inY2_COORDINATE         => inY2_COORDINATE,
                                        inSTART_TRANSMISSION    => inSTART_TRANSMISSION,
                                        outY_COMPONENT_SUM      => sSUM_Y_SQARE_2 
                                    );
    FLASH_SQARE_1: FlashCheck port map	(
											iCLK            => iCLK,
											inRST           => inRST,
											inY_FRAME_SUM   => sSUM_Y_SQARE_1,
											inBORDER_VALUE  => inBORDER_VALUE,
											inSOF           => inSTART_TRANSMISSION,
											inEOF           => sEND_OF_FRAME,
											outRESULT       => sRESULT_1
										);
    FLASH_SQARE_2: FlashCheck port map 	(
											iCLK            => iCLK,
											inRST           => inRST,
											inY_FRAME_SUM   => sSUM_Y_SQARE_2,
											inBORDER_VALUE  => inBORDER_VALUE,
											inSOF           => inSTART_TRANSMISSION,
											inEOF           => sEND_OF_FRAME,
											outRESULT       => sRESULT_2
										);

end Behavioral;

-------------------------------------------------------------------------------------------------------------
--                                         Revision History
-------------------------------------------------------------------------------------------------------------
--
--  $Log:  $


-------------------------------------------------------------------------------------------------------------