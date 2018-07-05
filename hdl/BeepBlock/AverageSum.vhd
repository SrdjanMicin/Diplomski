-- File                  : AverageSum.vhd
-- Author                : Srdjan Micin <Srdjan.Micin@rt-rk.com>
-- Created               : May 29, 2018, 13:31 CDT
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
use IEEE.NUMERIC_STD.ALL;

entity AverageSum is
  Port  (
            iCLK                            : in  std_logic;
            inRST                           : in  std_logic;
            inSAMPLES_DATA                  : in  std_logic_vector(31 downto 0);
            inSAMPLES_DATA_VALID            : in  std_logic;
            outAVERAGE_SUM_LEFT_CHANNEL     : out std_logic_vector(31 downto 0);
            outAVERAGE_SUM_RIGHT_CHANNEL    : out std_logic_vector(31 downto 0) 
        );
end AverageSum;

architecture Behavioral of SAS_AV is

signal tmp_right : signed(31 downto 0) := (others => '0');
signal tmp_left : signed(31 downto 0) := (others => '0');
signal n : integer := 0;

signal tmp_right_shifted : signed(31 downto 0) := (others => '0');
signal tmp_left_shifted : signed(31 downto 0) := (others => '0');

signal sRIGHT_SAMPLES : std_logic_vector(15 downto 0) := (others => '0');
signal sLEFT_SAMPLES : std_logic_vector(15 downto 0) := (others => '0');

signal sAVERAGE_SUM_LEFT_CHANNEL : signed(15 downto 0);
signal sAVERAGE_SUM_RIGHT_CHANNEL : signed(15 downto 0);

begin

    sRIGHT_SAMPLES <= inSAMPLES_DATA(15 downto 0);
    sLEFT_SAMPLES <= inSAMPLES_DATA(31 downto 16);   

    put_samples_in_array_and_take_average_sum:  process(iCLK)
                            
                                                --variable n : integer := 0;
                                                
                                                begin
                                                    if(iCLK'event and iCLK = '1') then
                                                        if(inRST = '0') then
                                                            tmp_right <= (others => '0');    
                                                            tmp_left <= (others => '0');    
                                                        elsif(inSAMPLES_DATA_VALID = '1') then
                                                            if(n < 32) then
                                                                tmp_right <= tmp_right + abs(signed(sRIGHT_SAMPLES));
                                                                tmp_left <= tmp_left + abs(signed(sLEFT_SAMPLES)); 
                                                                n <= n + 1;
                                                            else
                                                                n <= 0;
                                                                tmp_right <= (others => '0');
                                                                tmp_left <= (others => '0');
                                                            end if;
                                                        else
                                                            tmp_right <= (others => '0');
                                                            tmp_left <= (others => '0');    
                                                        end if;
                                                    end if;
                                                end process put_samples_in_array_and_take_average_sum;

tmp_right_shifted <= shift_right(tmp_right, 5);
tmp_left_shifted <= shift_right(tmp_left, 5);

outAVERAGE_SUM_LEFT_CHANNEL <= std_logic_vector(tmp_left_shifted);
outAVERAGE_SUM_RIGHT_CHANNEL <= std_logic_vector(tmp_right_shifted);
       
end Behavioral;

-------------------------------------------------------------------------------------------------------------
--                                         Revision History
-------------------------------------------------------------------------------------------------------------
--
--  $Log:  $


-------------------------------------------------------------------------------------------------------------