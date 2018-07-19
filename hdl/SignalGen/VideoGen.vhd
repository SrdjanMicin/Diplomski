-- File                  : VideoGen.vhd
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
-- $RCSfile: $
-- $Revision: $
-- $Author: $
-- $Date: $
-- $Source: $
--
-- Description:	Video Generator
--              The Video Generator generates test patterns
--              by reading text file and streaming data on  AXI4-Stream 
--              video interface. 
--              Text file is a packed with raw YCbCr 4:2:2 format samples
--              in which a pair of consecutive pixels is represented by 
--              1 Y sample each but share a Cb sample and a Cr sample.            
--              This type of data may be packaged in a container format 
--              with a FourCC of YUY2 which indicates the following 
--              byte formatting: Cb Y0 Cr Y1
--              The first pixel is a a function of (Y0, Cb, Cr) and the 
--              second pixel is a function of (Y1, Cb, Cr). 
--
---------------------------------------------------------------------------
-- The following is Company Confidential Information.
-- Copyright (c) 2006
-- All rights reserved. This program is protectedas an
-- unpublished work under the Copyright Act of 1976 and the ComputerSoftware
-- Act of 1980. This program is also considered a trade secret. It is not to
-- be disclosed or used by parties who have not received written authorization
-- from Company, Inc.
------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.textio.all;
use IEEE.NUMERIC_STD.ALL;


entity VideoGen is
    Generic ( 
                source_file_path 	: string :="file.txt";					
                width  : integer 	:= 1280;  --Image width
                height : integer 	:= 720;   --Image height
                delay  : integer 	:= 12    --Number of clk periods between lines as delay
            );
    Port ( 
            iCLK                : in  STD_LOGIC;                        --input CLK 
            inRST               : in  STD_LOGIC;                        --active LOW Reset
			inREAD_PIC		    : in  std_logic;
            m_axis_video_tdata  : out STD_LOGIC_VECTOR (31 downto 0);   --output Video Data 32bits width
            m_axis_video_tvalid : out STD_LOGIC;                        --output Valid signal
            m_axis_video_tready : in  STD_LOGIC;                        --input Ready signal from slave
            m_axis_video_tuser  : out STD_LOGIC;                        --output Start Of Frame pulse signal
            m_axis_video_tlast  : out STD_LOGIC                         --output End of Line pulse signal
         );
end VideoGen;

architecture Behavioral of VideoGen is

    signal cnt_x	: integer :=0;
    signal cnt_y	: integer :=0;
    signal cnt_d	: integer :=1;
    signal sFILE 	: std_logic := '0';
    signal file_select: std_logic := '0';
    signal proceed: std_logic := '0';
    
begin
   
-- Flash generator
    process (iCLK)
        file     file_pointer : text;
        variable line_num     : line;
        variable Cb : integer := 0;
        variable Cr : integer := 0;
        variable Y0 : integer := 0;
        variable Y1 : integer := 0;    
  
    begin
        if (iCLK'event and iCLK='1') then
            if (inRST='0') then
                cnt_x   <= 0;    
                cnt_y   <= 0; 
				cnt_d   <= 1;
			elsif(inREAD_PIC = '1' and file_select='0' and proceed='0') then
			    sFILE <= '0';
				file_open(file_pointer, source_file_path & "\flash.txt", READ_MODE); 
				proceed <= '1';
			elsif(file_select='1' and proceed='0') then
				sFILE <= '0';
				file_open(file_pointer, source_file_path & "\no_flash.txt", READ_MODE); 
				proceed <= '1';			
		    elsif proceed = '1' then	
                if (m_axis_video_tready = '1') then 	
				    if (cnt_y < height) then							
				        if (cnt_x < width) then                    			  
									  
					       cnt_x <= cnt_x + 2; -- 2 pixel/clk
					      			 
					       -- read Cb
					       readline (file_pointer,line_num);   --Read next line from the file.
					       READ (line_num, Cb);                --Read the contents of the line from the file into a variable.
					       m_axis_video_tdata(15 downto 8) <= std_logic_vector(to_unsigned(Cb,8));
                            													 
					       -- read Y0
					       readline (file_pointer,line_num);
					       READ (line_num, Y0);      
					       m_axis_video_tdata(7 downto 0) <= std_logic_vector(to_unsigned(Y0,8));
					          
					       -- read Cr
                            readline (file_pointer,line_num);   
                            READ (line_num, Cr);               
                            m_axis_video_tdata(31 downto 24) <= std_logic_vector(to_unsigned(Cr,8));
                           
                            -- read Y1
                            readline (file_pointer,line_num);
                            READ (line_num, Y1);      
                            m_axis_video_tdata(23 downto 16) <= std_logic_vector(to_unsigned(Y1,8));
                           
						    --delay between lines
						elsif (cnt_d < delay) then
							cnt_d <= cnt_d + 1;
						else
							cnt_x <= 0;
							cnt_d <= 1;
							cnt_y <= cnt_y + 1;
						end if;                                  
					else
						cnt_y <= 0;
						file_close(file_pointer);   --After reading all the lines close the file.
						sFILE <= '1'; 
						proceed <= '0';
						file_select <= not file_select;
					end if;
				end if;
            end if; 
        end if;
    end process;
	

    m_axis_video_tuser <= '1' when (cnt_x = 2 and cnt_y = 0) else '0';                                                      -- Start Of Frame
    m_axis_video_tlast <= '1' when (cnt_x = width  and cnt_d = 1 ) else '0';                                                -- End Of Line
    m_axis_video_tvalid <= '1' when (cnt_x > 0 and cnt_x < width+1 and cnt_d = 1 and m_axis_video_tready = '1') else '0';   -- Valid
    

end Behavioral;
