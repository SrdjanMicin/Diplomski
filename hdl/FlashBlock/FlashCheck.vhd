-- File                  : FlashCheck.vhd
-- Author                : Srdjan Micin <Srdjan.Micin@rt-rk.com>
-- Created               : March 5, 2018, 12:23 CDT
--
------------------------------------------------------------------------------------------------------------
--
--    $RCSfile:  $
--   $Revision:  $
--     $Author:  $
--       $Date:  $
--     $Source:  $
--
-- Description:     Blok koji prihvata sumu iz PixelSum bloka i provjerava da li ima bljeska(flash).
--                  Granica koja nam pokazuje da li dovedena suma predstavlja bljesak ili ne se dobija
--                  iz ARM Cortex A9 procesora preko AXI-Lite magistrale. 
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

entity FlashCheck is
  Port  (
            iCLK            : in  std_logic;
            inRST           : in  std_logic;
            inY_FRAME_SUM   : in  std_logic_vector(31 downto 0);            -- suma Y komponenti
            inBORDER_VALUE  : in  std_logic_vector(31 downto 0);            -- granica za odredjivanje bljeska
            inSOF           : in  std_logic;                                -- pocetak nove slike
            inEOF           : in  std_logic;                                -- kraj prethodne slike
            outRESULT       : out std_logic                                 -- pokazuje da li ima bljeska('1') ili ne('0')
        );
end FlashCheck;

architecture Behavioral of FlashCheck is

signal sY_FRAME_SUM : std_logic_vector(31 downto 0);

begin

-- Uzimanje zbira Y-komponenti svakog kvadrata 
    load_sum_value  :   process(iCLK)
                        begin
                            if(iCLK'event and iCLK = '1') then
                                if(inRST = '0') then
                                    sY_FRAME_SUM <= (others => '0');
                                elsif(inEOF = '1') then
                                    sY_FRAME_SUM <= inY_FRAME_SUM;
                                elsif(inSOF = '1') then
                                    sY_FRAME_SUM <= (others => '0');
                                else
                                    sY_FRAME_SUM <= (others => '0');
                                end if;
                            end if;
                        end process load_sum_value;

-- provjera da li je doslo do bljeska. 
outRESULT <=    '1' when unsigned(sY_FRAME_SUM) > unsigned(inBORDER_VALUE) else
                '0';
 
end Behavioral;

-------------------------------------------------------------------------------------------------------------
--                                         Revision History
-------------------------------------------------------------------------------------------------------------
--
--  $Log:  $


-------------------------------------------------------------------------------------------------------------