----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/17/2018 02:53:06 PM
-- Design Name: 
-- Module Name: HbbTV_Test_IP_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity HbbTV_Test_IP_tb is
--  Port ( );
end HbbTV_Test_IP_tb;

architecture Behavioral of HbbTV_Test_IP_tb is

	component HbbTV_Test_IP_v1_0 is
		generic	(
					-- Parameters of Axi Slave Bus Interface S_AUDIO_AXIS
					C_S_AUDIO_AXIS_TDATA_WIDTH	: integer	:= 32;

					-- Parameters of Axi Master Bus Interface M_AUDIO_AXIS
					C_M_AUDIO_AXIS_TDATA_WIDTH	: integer	:= 32;
					C_M_AUDIO_AXIS_START_COUNT	: integer	:= 32;

					-- Parameters of Axi Slave Bus Interface S_VIDEO_AXIS
					C_S_VIDEO_AXIS_TDATA_WIDTH	: integer	:= 32;

					-- Parameters of Axi Master Bus Interface M_VIDEO_AXIS
					C_M_VIDEO_AXIS_TDATA_WIDTH	: integer	:= 32;
					C_M_VIDEO_AXIS_START_COUNT	: integer	:= 32;

					-- Parameters of Axi Slave Bus Interface S_CTRL_AXI
					C_S_CTRL_AXI_DATA_WIDTH	: integer	:= 32;
					C_S_CTRL_AXI_ADDR_WIDTH	: integer	:= 6
				);
		port	(
					-- Ports of Axi Slave Bus Interface S_AUDIO_AXIS
					audio_aclk			: in std_logic;
					audio_aresetn		: in std_logic;
					s_audio_axis_tready	: out std_logic;
					s_audio_axis_tdata	: in std_logic_vector(C_S_AUDIO_AXIS_TDATA_WIDTH-1 downto 0);
					s_audio_axis_tlast	: in std_logic;
					s_audio_axis_tvalid	: in std_logic;

					-- Ports of Axi Master Bus Interface M_AUDIO_AXIS
					m_audio_axis_tvalid	: out std_logic;
					m_audio_axis_tdata	: out std_logic_vector(C_M_AUDIO_AXIS_TDATA_WIDTH-1 downto 0);
					m_audio_axis_tlast	: out std_logic;
					m_audio_axis_tready	: in std_logic;

					-- Ports of Axi Slave Bus Interface S_VIDEO_AXIS
					video_aclk			: in std_logic;
					video_aresetn		: in std_logic;
					s_video_axis_tready	: out std_logic;
					s_video_axis_tdata	: in std_logic_vector(C_S_VIDEO_AXIS_TDATA_WIDTH-1 downto 0);
					s_video_axis_tlast	: in std_logic;
					s_video_axis_tvalid	: in std_logic;
					s_video_axis_tuser	: in std_logic;

					-- Ports of Axi Master Bus Interface M_VIDEO_AXIS
					m_video_axis_tvalid	: out std_logic;
					m_video_axis_tdata	: out std_logic_vector(C_M_VIDEO_AXIS_TDATA_WIDTH-1 downto 0);
					m_video_axis_tlast	: out std_logic;
					m_video_axis_tuser	: out std_logic;
					m_video_axis_tready	: in std_logic;

			-- Ports of Axi Slave Bus Interface S_CTRL_AXI
			s_ctrl_axi_aclk	: in std_logic;
			s_ctrl_axi_aresetn	: in std_logic;
			s_ctrl_axi_awaddr	: in std_logic_vector(C_S_CTRL_AXI_ADDR_WIDTH-1 downto 0);
			s_ctrl_axi_awprot	: in std_logic_vector(2 downto 0);
			s_ctrl_axi_awvalid	: in std_logic;
			s_ctrl_axi_awready	: out std_logic;
			s_ctrl_axi_wdata	: in std_logic_vector(C_S_CTRL_AXI_DATA_WIDTH-1 downto 0);
			s_ctrl_axi_wstrb	: in std_logic_vector((C_S_CTRL_AXI_DATA_WIDTH/8)-1 downto 0);
			s_ctrl_axi_wvalid	: in std_logic;
			s_ctrl_axi_wready	: out std_logic;
			s_ctrl_axi_bresp	: out std_logic_vector(1 downto 0);
			s_ctrl_axi_bvalid	: out std_logic;
			s_ctrl_axi_bready	: in std_logic;
			s_ctrl_axi_araddr	: in std_logic_vector(C_S_CTRL_AXI_ADDR_WIDTH-1 downto 0);
			s_ctrl_axi_arprot	: in std_logic_vector(2 downto 0);
			s_ctrl_axi_arvalid	: in std_logic;
			s_ctrl_axi_arready	: out std_logic;
			s_ctrl_axi_rdata	: out std_logic_vector(C_S_CTRL_AXI_DATA_WIDTH-1 downto 0);
			s_ctrl_axi_rresp	: out std_logic_vector(1 downto 0);
			s_ctrl_axi_rvalid	: out std_logic;
			s_ctrl_axi_rready	: in std_logic	
				);
	end component HbbTV_Test_IP_v1_0;
				
	component AudioGen is
		port	(
					iCLK : in std_logic;
					inRST : in std_logic;
					m_axis_data_tready  : in  std_logic;
					m_axis_data_tvalid  : out std_logic;
					m_axis_data_tlast   : out std_logic;
					m_axis_data_tdata   : out std_logic_vector(31 downto 0) 
				);
	end component AudioGen;
	
	component VideoGen is
	
		generic	(
					number_of_pictures  : integer;  
					source_file_path1 	: string :="file.txt";					
					width  : integer := 128;  --Image width
					height : integer := 96;   --Image height
					delay  : integer := 12    --Number of clk periods between lines as delay
				);
		port	(
					iCLK                : in  STD_LOGIC;                        --input CLK 
					inRST               : in  STD_LOGIC;                        --active LOW Reset
					m_axis_video_tdata  : out STD_LOGIC_VECTOR (31 downto 0);   --output Video Data 32bits width
					m_axis_video_tvalid : out STD_LOGIC;                        --output Valid signal
					m_axis_video_tready : in  STD_LOGIC;                        --input Ready signal from slave
					m_axis_video_tuser  : out STD_LOGIC;                        --output Start Of Frame pulse signal
					m_axis_video_tlast  : out STD_LOGIC  
				);
	end component VideoGen;
	
constant picture : string := "D:\Diplomski\jpeg test pattern generator\BMPtoYCbCr\Paint_slike";
	
signal audio_clock 		: std_logic;
signal audio_reset		: std_logic;
signal out_audio_valid	: std_logic;
signal out_audio_data	: std_logic_vector(31 downto 0);
signal out_audio_last	: std_logic;
signal out_audio_ready	: std_logic := '1';

signal gen_audio_valid	: std_logic;
signal gen_audio_last	: std_logic;
signal gen_audio_data	: std_logic_vector(31 downto 0);
signal gen_audio_ready	: std_logic;

signal video_clock 	: std_logic;
signal video_reset 	: std_logic;
signal out_video_valid	: std_logic;
signal out_video_data	: std_logic_vector(31 downto 0);
signal out_video_last	: std_logic;
signal out_video_sof	: std_logic;
signal out_video_ready	: std_logic := '1';	

signal gen_video_valid	: std_logic;
signal gen_video_last	: std_logic;
signal gen_video_data	: std_logic_vector(31 downto 0);
signal gen_video_ready	: std_logic;
signal gen_video_user	: std_logic;

signal ctrl_clock		: std_logic;
signal ctrl_reset		: std_logic;


begin

	audio_generator: AudioGen port map	(
											iCLK => audio_clock,
											inRST => audio_reset,
											m_axis_data_tready  => gen_audio_ready,
											m_axis_data_tvalid  => gen_audio_valid,
											m_axis_data_tlast   => gen_audio_last,
											m_axis_data_tdata   => gen_audio_data
										);
	
	video_generator: VideoGen generic map	(
												number_of_pictures	=> 116,
												source_file_path1	=> picture,
												width	=> 1920,
												height	=> 1080,
												delay	=> 12
											)
							  port map	(
											iCLK	=> video_clock,
											inRST   => video_reset,      
											m_axis_video_tdata  => gen_video_data,
											m_axis_video_tvalid => gen_video_valid,                      
											m_axis_video_tready => gen_video_ready,
											m_axis_video_tuser  => gen_video_user,
											m_axis_video_tlast  => gen_video_last	
										);
	
	HbbTV_IP_Block:	HbbTV_Test_IP_v1_0 generic map	(
														C_S_AUDIO_AXIS_TDATA_WIDTH	=> 32,

														C_M_AUDIO_AXIS_TDATA_WIDTH	=> 32,

														C_S_VIDEO_AXIS_TDATA_WIDTH	=> 32,

														C_M_VIDEO_AXIS_TDATA_WIDTH	=> 32,

														C_S_CTRL_AXI_DATA_WIDTH		=> 32,
														C_S_CTRL_AXI_ADDR_WIDTH		=> 6
														
													)
										port map	(
														audio_aclk			=> audio_clock,		
														audio_aresetn		=> audio_reset,
														s_audio_axis_tready	=> gen_audio_ready,	
														s_audio_axis_tdata	=> gen_audio_data, 
														s_audio_axis_tlast	=> gen_audio_last,
														s_audio_axis_tvalid	=> gen_audio_valid,
														
														m_audio_axis_tvalid	=> out_audio_valid,
														m_audio_axis_tdata	=> out_audio_data,	
														m_audio_axis_tlast	=> out_audio_last,
														m_audio_axis_tready	=> out_audio_ready,
														
														video_aclk			=> video_clock,
														video_aresetn		=> video_reset,
														s_video_axis_tready	=> gen_video_ready,
														s_video_axis_tdata	=> gen_video_data,
														s_video_axis_tlast	=> gen_video_last,
														s_video_axis_tvalid	=> gen_video_valid,
														s_video_axis_tuser	=> gen_video_user,
														
														m_video_axis_tvalid	=> out_video_valid,
														m_video_axis_tdata	=> out_video_data,
														m_video_axis_tlast	=> out_video_last,
														m_video_axis_tuser	=> out_video_sof,
														m_video_axis_tready	=> out_video_ready,
														
														s_ctrl_axi_aclk   	=> ctrl_clock,
														s_ctrl_axi_aresetn	=> ctrl_reset,
														s_ctrl_axi_awaddr	: in std_logic_vector(C_S_CTRL_AXI_ADDR_WIDTH-1 downto 0);
														s_ctrl_axi_awprot	: in std_logic_vector(2 downto 0);
														s_ctrl_axi_awvalid	: in std_logic;
														s_ctrl_axi_awready	: out std_logic;
														s_ctrl_axi_wdata	: in std_logic_vector(C_S_CTRL_AXI_DATA_WIDTH-1 downto 0);
														s_ctrl_axi_wstrb	: in std_logic_vector((C_S_CTRL_AXI_DATA_WIDTH/8)-1 downto 0);
														s_ctrl_axi_wvalid	: in std_logic;
														s_ctrl_axi_wready	: out std_logic;
														s_ctrl_axi_bresp	: out std_logic_vector(1 downto 0);
														s_ctrl_axi_bvalid	: out std_logic;
														s_ctrl_axi_bready	: in std_logic;
														s_ctrl_axi_araddr	: in std_logic_vector(C_S_CTRL_AXI_ADDR_WIDTH-1 downto 0);
														s_ctrl_axi_arprot	: in std_logic_vector(2 downto 0);
														s_ctrl_axi_arvalid	: in std_logic;
														s_ctrl_axi_arready	: out std_logic;
														s_ctrl_axi_rdata	: out std_logic_vector(C_S_CTRL_AXI_DATA_WIDTH-1 downto 0);
														s_ctrl_axi_rresp	: out std_logic_vector(1 downto 0);
														s_ctrl_axi_rvalid	: out std_logic;
														s_ctrl_axi_rready	: in std_logic
													);

end Behavioral;
