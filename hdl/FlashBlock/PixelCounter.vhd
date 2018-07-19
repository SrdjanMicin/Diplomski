-- File                  : PixelCounter.vhd
-- Author                : Srdjan Micin <Srdjan.Micin@rt-rk.com>
-- Created               : March 5, 2018, 11:56 CDT
--
------------------------------------------------------------------------------------------------------------
--
--    $RCSfile:  $
--   $Revision:  $
--     $Author:  $
--       $Date:  $
--     $Source:  $
--
-- Description:     Blok za brojanje piksela, tj. za pravljenje ekrana od n-vrsta i n-kolona, gdje broj n zavisi
--                  formata slike koja se dovodi sa AXI4Stream-a. Svaki dolazeci piksel se stavlja na svoju 
--                  poziciju pomocu dva brojaca(jedan za vrste, drugi za kolone) i na taj nacin dobija svoju
--                  poziciju u matrici(ekranu). Kao izlaz imamo piksel i informaciju gdje se on nalazi na ekranu.
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

entity PixelCounter is
  Port  (
            iCLK                    : in  std_logic;                                -- takt signal
            inRST                   : in  std_logic;                                -- reset signal
            inPIXELS                : in  std_logic_vector(31 downto 0);            -- ulazni piksel
            inLAST_LINE             : in  std_logic;                                -- kraj jednog reda(linije)
            inVALID_PIXELS          : in  std_logic;                                -- validni pikseli
            inSTART_TRANSMISSION    : in  std_logic;                                -- pocetak novog frame-a
            inHEIGHT                : in  std_logic_vector(31 downto 0);
            outREADY                : out std_logic;                                -- oznacava da je blok spreman da primi sledeci frame
            outCOLUMN               : out std_logic_vector(31 downto 0);            -- kolona piksela
            outROW                  : out std_logic_vector(31 downto 0);            -- red piksela
            outPIXELS               : out std_logic_vector(31 downto 0)             -- izlazni piksel(dobijen od generatora)
        );
end PixelCounter;

architecture Behavioral of PixelCounter is

signal sCOLUMN          : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(1,32));
signal sROW             : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(1,32));
signal sNEW_COLUMN      : std_logic_vector(1 downto 0);
signal sNEW_ROW         : std_logic_vector(1 downto 0);
signal sPIXELS          : std_logic_vector(31 downto 0);

signal s_height         : unsigned(31 downto 0);

begin
    
    s_height <= unsigned(inHEIGHT) + 1;

    sPIXELS <= inPIXELS;

-- oznacava da je blok uvijek spreman da primi sledeci frame. Trebace uslov koji ovu vrijednost postavlja na '1' tek kada se zavrsi obrada 
-- tekuceg frame-a da ne bi dosli u situaciju da dok obradjujemo jedan frame, drugi krene da dolazi.
    outREADY <= '1';

-- uslov za prelaz u novu kolonu, zavisi od signala sa AXI4Stream magistrale.    
    sNEW_COLUMN <= "11" when inLAST_LINE = '1' and inVALID_PIXELS = '1' else
                   "01" when inSTART_TRANSMISSION = '1' and inVALID_PIXELS = '1' else
                   "10" when inVALID_PIXELS = '0' else
                   "00";

-- uslov za prelaz u novi red, zavisi od signala sa AXI4Stream magistrale. 
    sNEW_ROW    <= "11" when inLAST_LINE = '0' and inVALID_PIXELS = '1' and inSTART_TRANSMISSION = '1' else
                   "10" when inLAST_LINE = '1' and inVALID_PIXELS = '1' and inSTART_TRANSMISSION = '0' else 
                   "01" when inVALID_PIXELS = '0';

-- brojac kolona                   
    columns :           process(iCLK)   
                        begin
                            if(iCLK'event and iCLK = '1') then
                                if(inRST <= '0') then
                                    sCOLUMN <= (others => '0');
                                else
                                    if(sNEW_COLUMN = "11") then
                                        sCOLUMN <= std_logic_vector(to_unsigned(1,32));
                                    elsif(sNEW_COLUMN <= "00" or sNEW_COLUMN <= "01") then
                                        sCOLUMN <= std_logic_vector(unsigned(sCOLUMN) + 1);
                                    end if;
                                end if;
                            end if;
                        end process;

-- brojac redova(vrsta)                        
     rows :             process(iCLK)
                        begin
                            if(iCLK'event and iCLK = '1') then
                                if(inRST <= '0') then
                                    sROW <= (others => '0'); 
                                else
                                    if(sNEW_ROW = "11" or sROW = std_logic_vector(s_height)) then
                                        sROW <= std_logic_vector(to_unsigned(1,32));
                                    elsif(sNEW_ROW = "10") then
                                        sROW <= std_logic_vector(unsigned(sROW) + 1);
                                    end if;
                                end if;
                            end if;
                        end process;

outCOLUMN <= sCOLUMN;
outROW    <= sROW;
outPIXELS <= sPIXELS;

end Behavioral;

-------------------------------------------------------------------------------------------------------------
--                                         Revision History
-------------------------------------------------------------------------------------------------------------
--
--  $Log:  $


-------------------------------------------------------------------------------------------------------------