-- File                  : PixelSum.vhd
-- Author                : Srdjan Micin <Srdjan.Micin@rt-rk.com>
-- Created               : March 5, 2018, 12:13 CDT
--
------------------------------------------------------------------------------------------------------------
--
--    $RCSfile:  $
--   $Revision:  $
--     $Author:  $
--       $Date:  $
--     $Source:  $
--
-- Description:     Ovaj blok sluzi za prihvatanje piksela iz ogranicenih dijelova ekrana, gdje su granice
--                  ovih dijelova uzete iz testne specifikacije napisane od strane HbbTV asocijacije. 
--                  Po prihvatanju piksela, uzimamo samo njegovu Y-komponentu koja nam govori kakvo je
--                  osvjetljenje tog pojedinacnog piksela i sabiramo sa Y-komponentom sledeceg piksela.
--                  Na taj nacin, nakon cijelog frame-a, imamo zbir svih Y-komponenti jedne slike u zeljenim
--                  dijelovima ekrana. Ti dijelovi se ovde nazivaju kvadrati(sqare).
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

entity PixelSum is
  Port  (
            iCLK                    : in  std_logic;
            inRST                   : in  std_logic;
            inCOLUMN                : in  std_logic_vector(31 downto 0);            -- ulazna Y-koordinata 
            inROW                   : in  std_logic_vector(31 downto 0);            -- ulazna X-koordinata
            inSQARE_PIXELS          : in  std_logic_vector(31 downto 0);            -- ulazni pikseli iz generatora
            inX1_COORDINATE         : in  std_logic_vector(31 downto 0);            -- donja granica kvadrata po X-osi
            inX2_COORDINATE         : in  std_logic_vector(31 downto 0);            -- gornja granica kvadrata po X-osi
            inY1_COORDINATE         : in  std_logic_vector(31 downto 0);            -- donja granica kvadrata po Y-osi
            inY2_COORDINATE         : in  std_logic_vector(31 downto 0);            -- gornja granica kvadrata po Y-osi
            inSTART_TRANSMISSION    : in  std_logic;                                -- pocetak frame-a
            outY_COMPONENT_SUM      : out std_logic_vector(31 downto 0)             -- izlazni zbir Y komponenti u zadatim granicama kvadrata
        );
end PixelSum;

architecture Behavioral of PixelSum is

signal sPIXELS      : std_logic_vector(31 downto 0);
signal sY           : std_logic := '0';                 
signal sX           : std_logic := '0';                 
signal KVADRAT      : std_logic := '0';                 
signal sTMP_INTEGER : integer := 0;

signal sY_SUM       : std_logic_vector(31 downto 0) := (others => '0');
signal sY_SUM_OLD : std_logic_vector(31 downto 0) := (others => '0');    

begin

-- kontrolni signal za granice po Y-osi
sY <= '1' when unsigned(inROW) > unsigned(inY1_COORDINATE) and unsigned(inROW) < unsigned(inY2_COORDINATE) else
      '0';

-- kontrolni signal za granice po X-osi
sX <= '1' when (unsigned(inCOLUMN)*2) + 1 > unsigned(inX1_COORDINATE) and (unsigned(inCOLUMN)*2) + 1 < unsigned(inX2_COORDINATE) else
      '0'; 

-- prosledjujemo samo piksele unutar zeljenog kvadrata da bi mogli sabirati samo njihove Y komponente      
sPIXELS <= inSQARE_PIXELS when KVADRAT = '1' else
            (others => '0');     

-- kontrolni signal koji oznacava da se nalazimo u zeljenom dijelu ekrana(kvadratu)        
KVADRAT <= '1' when sY = '1' and sX = '1' else
           '0';

-- pomocni signal za cuvanje prethodne vrijednosti sume.
sY_SUM_OLD <= sY_SUM;
           
    sum:    process(iCLK)
            begin
                if(iCLK'event and iCLK = '1') then
                    if(inRST = '0') then
                        sY_SUM <= (others => '0');
                    else
                        -- sabiranje Y komponenti piksela unutar kvadrata
                        if(KVADRAT = '1') then
                            sY_SUM <= std_logic_vector(unsigned(sPIXELS(7 downto 0)) + unsigned(sPIXELS(23 downto 16)) + unsigned(sY_SUM_OLD));
                        end if;
                        
                        -- sa svakim novim frame-om(slikom) suma je nula
                        if(inSTART_TRANSMISSION = '1') then
                            sY_SUM <= (others => '0');
                        end if;
                    end if;
                end if;
            end process sum;

outY_COMPONENT_SUM <= sY_SUM;
                
end Behavioral;

-------------------------------------------------------------------------------------------------------------
--                                         Revision History
-------------------------------------------------------------------------------------------------------------
--
--  $Log:  $


-------------------------------------------------------------------------------------------------------------