-- File                  : AudioGen.vhd
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
use IEEE.STD_LOGIC_UNSIGNED.all;

use STD.textio.all;

entity AudioGen is
  Port  (
            iCLK : in std_logic;
            inRST : in std_logic;
            m_axis_data_tready  : in  std_logic;
            m_axis_data_tvalid  : out std_logic;
            m_axis_data_tlast   : out std_logic;
            m_axis_data_tdata   : out std_logic_vector(31 downto 0) 
        );
end AudioGen;

architecture Behavioral of AudioGen is

signal sFILE : std_logic := '0';
signal stmp1 : std_logic_vector(15 downto 0);
signal s_out_data : std_logic_vector(31 downto 0);

begin

    read_txt_file:  process(iCLK)
                    
                    file file_pointer : text;
                    file out_file_pointer : text;
                    variable out_line_num : line;
                    variable line_num : line;
                    variable tmp      : integer;
                    variable tmp1      : integer;
                    
                    begin
                    if(iCLK'event and iCLK = '1') then
                        if(inRST = '0') then
                            m_axis_data_tvalid <= '0';
                            m_axis_data_tlast <= '0';
                            m_axis_data_tdata <= (others => '0');
                            sFILE <= '0';
                        elsif(sFILE = '0') then
                            file_open(file_pointer,"D:\Diplomski\AudioSignalGenerator\RawData.txt",READ_MODE);
                            sFILE <= '1';
                        elsif(sFILE = '1') then
                            if(m_axis_data_tready = '1') then
                                    m_axis_data_tvalid <= '1';
                                    readline(file_pointer, line_num);
                                    READ(line_num, tmp);
                                    -- right channel
                                    m_axis_data_tdata(15 downto 0) <= std_logic_vector(to_signed(tmp,16));
                                    readline(file_pointer, line_num);
                                    READ(line_num, tmp1);
                                    -- left channel
                                    m_axis_data_tdata(31 downto 16)<= std_logic_vector(to_signed(tmp1,16));
                            else
                                m_axis_data_tvalid <= '0'; 
                                file_close(file_pointer);  --After reading all the lines close the file.
                                sFILE <= '0';  
                            end if; 
                        end if;
                    end if;                    
                    end process read_txt_file;

--m_axis_data_tvalid <= '1' when m_axis_data_tready = '1' else
                     -- '0';

end Behavioral;

-------------------------------------------------------------------------------------------------------------
--                                         Revision History
-------------------------------------------------------------------------------------------------------------
--
--  $Log:  $


-------------------------------------------------------------------------------------------------------------