----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:00:33 02/21/2014 
-- Design Name: 
-- Module Name:    atlys_lab_font_controller - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity atlys_lab_font_controller is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           start : in  STD_LOGIC;
			  button_input : in std_logic;
           switch : in  STD_LOGIC_VECTOR (7 downto 0);
           led : out  STD_LOGIC_VECTOR (7 downto 0);
           tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0));
end atlys_lab_font_controller;

architecture Behavioral of atlys_lab_font_controller is

	signal  blue_s, red_s, green_s, enable,  pixel_clk,  v_sync_sig, 
	v_sync_sig_1, v_sync_sig_2, h_sync_sig, h_sync_sig_1, h_sync_sig_2, 
	v_completed_sig, blank, clock_s, serialize_clk, serialize_clk_n: std_logic;  
	signal   red, green, blue, ascii: std_logic_vector (7 downto 0); 
	signal column_connection, row_connection, row_sig, row_sig_1, row_sig_2, column_sig, column_sig_1, column_sig_2: std_logic_vector (10 downto 0); 
	signal blank_sig, blank_sig_1, blank_sig_2: std_logic; 
	
	
COMPONENT character_gen 
	PORT(
			 clk : in  STD_LOGIC;
			 reset: in STD_LOGIC; 
           blank : in  STD_LOGIC;
           row : in std_logic_vector (10 downto 0);
           column : in  std_logic_vector (10 downto 0);
           ascii_to_write : in  std_logic_vector (7 downto 0);
           write_en : in  STD_LOGIC;
           r,g,b : out  std_logic_vector (7 downto 0)
			  );
END COMPONENT; 

component vga_sync 
     
     Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           h_sync : out  STD_LOGIC;
           v_sync : out  STD_LOGIC;
           v_completed : out  STD_LOGIC;
           blank : out  STD_LOGIC;
           row :  out std_logic_vector(10 downto 0);
           column :  out std_logic_vector(10 downto 0));
  end component vga_sync ;

COMPONENT input_to_pulse
		PORT (
			clk: in std_logic; 
			reset: in std_logic; 
			input: in std_logic; 
			pulse: out std_logic 
			);
end component; 
begin

    -- Clock divider - creates pixel clock from 100MHz clock
    inst_DCM_pixel: DCM
    generic map(
                   CLKFX_MULTIPLY => 2,
                   CLKFX_DIVIDE   => 8,
                   CLK_FEEDBACK   => "1X"
               )
    port map(
                clkin => clk,
                rst   => reset,
                clkfx => pixel_clk
            );

    -- Clock divider - creates HDMI serial output clock
    inst_DCM_serialize: DCM
    generic map(
                   CLKFX_MULTIPLY => 10, -- 5x speed of pixel clock
                   CLKFX_DIVIDE   => 8,
                   CLK_FEEDBACK   => "1X"
               )
    port map(
                clkin => clk,
                rst   => reset,
                clkfx => serialize_clk,
                clkfx180 => serialize_clk_n
            );

    -- TODO: VGA component instantiation
	

	  Inst_vga_sync: vga_sync PORT MAP(
				clk => pixel_clk,
				reset => reset, 
				h_sync => h_sync_sig, 
				v_sync=> v_sync_sig, 
				v_completed =>  open, 
				blank => blank_sig, 
				row => row_connection,
				column => column_connection
	         																						
				);
		Inst_character_gen: character_gen PORT MAP (
					clk => pixel_clk,
					blank => blank_sig_2,
					reset => reset, 
					row => std_logic_vector(row_connection),
					column=> std_logic_vector (column_connection),
					ascii_to_write => switch, 
					write_en => enable, 
					r => red,
					g => green, 
					b => blue
					);
					
	
		inst_input_to_pulse: input_to_pulse PORT MAP (
					clk => pixel_clk,
					reset => reset, 
					input => button_input, 
					pulse => enable
					); 
	 

    inst_dvid: entity work.dvid 
    port map(
                clk       => serialize_clk,
                clk_n     => serialize_clk_n, 
                clk_pixel => pixel_clk,
                red_p     => red,
                green_p   => green,
                blue_p    => blue,
                blank     => blank_sig_2,
                hsync     => h_sync_sig_2,
                vsync     => v_sync_sig_2,
                -- outputs to TMDS drivers
                red_s     => red_s,
                green_s   => green_s,
                blue_s    => blue_s,
                clock_s   => clock_s
            );

    -- Output the HDMI data on differential signalling pins
    OBUFDS_blue  : OBUFDS port map
        ( O  => TMDS(0), OB => TMDSB(0), I  => blue_s  );
    OBUFDS_red   : OBUFDS port map
        ( O  => TMDS(1), OB => TMDSB(1), I  => green_s );
    OBUFDS_green : OBUFDS port map
        ( O  => TMDS(2), OB => TMDSB(2), I  => red_s   );
    OBUFDS_clock : OBUFDS port map
        ( O  => TMDS(3), OB => TMDSB(3), I  => clock_s );
		  
		  
		  
		  
		  
		  --- adding upper level delays (2x): 
		  process( pixel_clk)
				begin 
					if (rising_edge(pixel_clk)) then 
						blank_sig_1 <= blank_sig;
						h_sync_sig_1 <= h_sync_sig; 
						v_sync_sig_1 <= v_sync_sig; 
					end if;
			end process; 
			
			process (pixel_clk)
				begin 
					if (rising_edge(pixel_clk)) then 
						blank_sig_2 <= blank_sig_1;
						h_sync_sig_2 <= h_sync_sig_1; 
						v_sync_sig_2 <= v_sync_sig_1; 
					end if; 
			end process; 
		  

end Behavioral;



