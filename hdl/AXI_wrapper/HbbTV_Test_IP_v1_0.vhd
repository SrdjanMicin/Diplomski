library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HbbTV_Test_IP_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


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
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S_AUDIO_AXIS
		s_audio_axis_aclk	: in std_logic;
		s_audio_axis_aresetn	: in std_logic;
		s_audio_axis_tready	: out std_logic;
		s_audio_axis_tdata	: in std_logic_vector(C_S_AUDIO_AXIS_TDATA_WIDTH-1 downto 0);
		s_audio_axis_tstrb	: in std_logic_vector((C_S_AUDIO_AXIS_TDATA_WIDTH/8)-1 downto 0);
		s_audio_axis_tlast	: in std_logic;
		s_audio_axis_tvalid	: in std_logic;

		-- Ports of Axi Master Bus Interface M_AUDIO_AXIS
		m_audio_axis_aclk	: in std_logic;
		m_audio_axis_aresetn	: in std_logic;
		m_audio_axis_tvalid	: out std_logic;
		m_audio_axis_tdata	: out std_logic_vector(C_M_AUDIO_AXIS_TDATA_WIDTH-1 downto 0);
		m_audio_axis_tstrb	: out std_logic_vector((C_M_AUDIO_AXIS_TDATA_WIDTH/8)-1 downto 0);
		m_audio_axis_tlast	: out std_logic;
		m_audio_axis_tready	: in std_logic;

		-- Ports of Axi Slave Bus Interface S_VIDEO_AXIS
		s_video_axis_aclk	: in std_logic;
		s_video_axis_aresetn	: in std_logic;
		s_video_axis_tready	: out std_logic;
		s_video_axis_tdata	: in std_logic_vector(C_S_VIDEO_AXIS_TDATA_WIDTH-1 downto 0);
		s_video_axis_tstrb	: in std_logic_vector((C_S_VIDEO_AXIS_TDATA_WIDTH/8)-1 downto 0);
		s_video_axis_tlast	: in std_logic;
		s_video_axis_tvalid	: in std_logic;

		-- Ports of Axi Master Bus Interface M_VIDEO_AXIS
		m_video_axis_aclk	: in std_logic;
		m_video_axis_aresetn	: in std_logic;
		m_video_axis_tvalid	: out std_logic;
		m_video_axis_tdata	: out std_logic_vector(C_M_VIDEO_AXIS_TDATA_WIDTH-1 downto 0);
		m_video_axis_tstrb	: out std_logic_vector((C_M_VIDEO_AXIS_TDATA_WIDTH/8)-1 downto 0);
		m_video_axis_tlast	: out std_logic;
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
end HbbTV_Test_IP_v1_0;

architecture arch_imp of HbbTV_Test_IP_v1_0 is

		signal HbbTV_audio_ready	: std_logic;
		signal HbbTV_video_ready	: std_logic;

		signal audio_data	: std_logic_vector(31 downto 0);
		signal audio_valid	: std_logic;
		signal audio_ready	: std_logic;
		
		signal video_data	: std_logic_vector(31 downto 0);
		signal video_valid	: std_logic;
		signal video_ready	: std_logic;
		signal video_last	: std_logic;
		signal video_start	: std_logic;
		
		signal synch_time	: std_logic_vector(15 downto 0);
	
	component HbbTV_Test is
		port	(
					iCLK					: in  std_logic;
					inRST					: in  std_logic;
					inPIXELS				: in  std_logic_vector(31 downto 0);
					inLAST_LINE				: in  std_logic;
					inVALID_PIXELS			: in  std_logic;
					inSTART_TRANSMISSION	: in  std_logic;
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

	component HbbTV_Test_IP_v1_0_S_CTRL_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 6
		);
		port (
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component HbbTV_Test_IP_v1_0_S_CTRL_AXI;

begin

-- Instantiation of Axi Bus Interface S_CTRL_AXI
HbbTV_Test_IP_v1_0_S_CTRL_AXI_inst : HbbTV_Test_IP_v1_0_S_CTRL_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S_CTRL_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S_CTRL_AXI_ADDR_WIDTH
	)
	port map (
		S_AXI_ACLK	=> s_ctrl_axi_aclk,
		S_AXI_ARESETN	=> s_ctrl_axi_aresetn,
		S_AXI_AWADDR	=> s_ctrl_axi_awaddr,
		S_AXI_AWPROT	=> s_ctrl_axi_awprot,
		S_AXI_AWVALID	=> s_ctrl_axi_awvalid,
		S_AXI_AWREADY	=> s_ctrl_axi_awready,
		S_AXI_WDATA	=> s_ctrl_axi_wdata,
		S_AXI_WSTRB	=> s_ctrl_axi_wstrb,
		S_AXI_WVALID	=> s_ctrl_axi_wvalid,
		S_AXI_WREADY	=> s_ctrl_axi_wready,
		S_AXI_BRESP	=> s_ctrl_axi_bresp,
		S_AXI_BVALID	=> s_ctrl_axi_bvalid,
		S_AXI_BREADY	=> s_ctrl_axi_bready,
		S_AXI_ARADDR	=> s_ctrl_axi_araddr,
		S_AXI_ARPROT	=> s_ctrl_axi_arprot,
		S_AXI_ARVALID	=> s_ctrl_axi_arvalid,
		S_AXI_ARREADY	=> s_ctrl_axi_arready,
		S_AXI_RDATA	=> s_ctrl_axi_rdata,
		S_AXI_RRESP	=> s_ctrl_axi_rresp,
		S_AXI_RVALID	=> s_ctrl_axi_rvalid,
		S_AXI_RREADY	=> s_ctrl_axi_rready
	);

	-- Add user logic here
HbbTV_Test_inst:	HbbTV_Test port map	(
											iCLK					=> s_video_axis_aclk,
											inRST					=> s_video_axis_aresetn,
											inPIXELS				=> video_data,
											inLAST_LINE				=> video_last,
											inVALID_PIXELS			=> video_valid,
											inSTART_TRANSMISSION	=> video_start,
											inX1_COORDINATE			=>
											inX2_COORDINATE			=>
											inX3_COORDINATE			=>
											inX4_COORDINATE			=>
											inY1_COORDINATE			=>
											inY2_COORDINATE			=>
											inVIDEO_BORDER			=>
											
											inSAMPLES				=> audio_data,
											inSAMPLES_VALID			=> audio_valid,
											inAUDIO_BORDER			=> 
											
											outVIDEO_READY			=> HbbTV_audio_ready,
											outAUDIO_READY			=> HbbTV_video_ready,
											outTIME					=> synch_time
										);
	audio_data	<= s_audio_axis_tdata;
	audio_valid	<= s_audio_axis_tvalid;
	audio_ready <= HbbTV_audio_ready and m_audio_axis_tready;
	m_audio_axis_tstrb	<= s_audio_axis_tstrb;
	m_audio_axis_tlast	<= s_audio_axis_tlast;
	
	video_data	<= s_video_axis_tdata;
	video_valid	<= s_video_axis_tvalid;
	video_ready	<= HbbTV_video_ready and m_video_axis_tready;
	video_last	<= s_video_axis_tlast;
	m_video_axis_tstrb	<= s_video_axis_tstrb;
	-- User logic ends

end arch_imp;
