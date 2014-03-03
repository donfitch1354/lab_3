----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:59:47 02/21/2014 
-- Design Name: 
-- Module Name:    character_gen - Behavioral 
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

use IEEE.NUMERIC_STD.ALL;


library UNISIM;
use UNISIM.VComponents.all;

entity character_gen is
    Port ( clk : in  STD_LOGIC;
           blank : in  STD_LOGIC;
           row : in  std_logic_vector (10 downto 0);
           column : in  std_logic_vector (10 downto 0);
           ascii_to_write : in  std_logic_vector (7 downto 0);
           write_en : in  STD_LOGIC;
           r,g,b : out  std_logic_vector (7 downto 0);
			  reset: in std_logic
			  );
end character_gen;

architecture Behavioral of character_gen is


COMPONENT Mux 
port (
			data: in unsigned ( 7 downto 0);
			sel : in unsigned (2 downto 0);
			output: out std_logic
	);
END COMPONENT;
 

COMPONENT font_rom
PORT (
			clk : in std_logic;
			addr : in std_logic_vector (10 downto 0); 
			data: out std_logic_vector ( 7 downto 0)  
		); 
END COMPONENT;

COMPONENT char_screen_buffer
PORT (
			
			clk        : in std_logic;
         we         : in std_logic;                     -- write enable
         address_a  : in std_logic_vector(11 downto 0); -- write address, primary read address
         address_b  : in std_logic_vector(11 downto 0); -- dual read address
         data_in    : in std_logic_vector(7 downto 0);  -- data input
         data_out_a : out std_logic_vector(7 downto 0); -- primary data output
         data_out_b : out std_logic_vector(7 downto 0) 
			);
END COMPONENT;
signal mux_output, write_enabled, output : std_logic; 
signal data_font: unsigned (7 downto 0); 
signal buffer_out_a, buffer_out_b, font_data: std_logic_vector (7 downto 0); 
signal count, count_next: std_logic_vector (11 downto 0); 
signal address_signal, address, font_addr: std_logic_vector (10 downto 0);
signal row_sig, row_sig_next: std_logic_vector (3 downto 0); 
signal col_sig, col_sig_next, sel: std_logic_vector (2 downto 0); 
signal address_b_12: std_logic_vector (11 downto 0); 
signal address_b_sig: std_logic_vector ( 13 downto 0); 
signal data_b_sig: std_logic_vector (7 downto 0);
signal font_add: std_logic_vector (10 downto 0); 



begin

Inst_char_screen_buffer: char_screen_buffer PORT MAP(
			clk => clk, 
			we => write_enabled,
			address_a => count,
			address_b => address_b_12,
			data_in => ascii_to_write,
			data_out_a => open,
			data_out_b => data_b_sig
			);
			
Inst_font_rom: font_rom PORT MAP (
			clk => clk, 
			addr => font_addr,
			data => font_data
			); 
			




	count <= std_logic_vector( unsigned (count_next) + 1) when rising_edge(write_en) else
						count_next; 
						
	count_next <= (others => '0') when reset = '1' 
		else 
			count; 

	sel <= col_sig_next(2 downto 0);

	process (font_data, sel)
	begin 
		case sel is 
				when "000" => 
					output <= font_data(7);
				when "001" => 
					output <= font_data(6);
				when "010" => 
					output <= font_data(5);	
				when "011" => 
					output <= font_data(4);	
				when "100" => 
					output <= font_data(3);
				when "101" => 
					output <= font_data(2);
				when "110" => 
					output <= font_data(1);
				when "111" => 
					output <= font_data(0);
		end case; 
	end process; 

-- insert processes for row_col, row_col2, etc
font_add <= data_b_sig(6 downto 0) & row_sig; 


	r <= (others => '1') when output = '1' else 
			(others => '0');
			

	g <= (others => '0'); 
	r <= (others => '0'); 
	
	
	
	address_b_sig <=  std_logic_vector(((unsigned(column(10 downto 3)))+unsigned (row(10 downto 4))*80));
	address_b_12 <= address_b_sig (11 downto 0); 
	
	
	
	
	
	
	process(clk)
		begin 
			if (rising_edge(clk)) then 
				row_sig <= row(3 downto 0); 
				col_sig <= column(2 downto 0); 
			end if; 
	end process; 
	
	process (clk)
		begin 
			if (rising_edge(clk)) then 
				col_sig_next <= col_sig (2 downto 0);
			end if; 
	end process; 
	
	










--not using mux on first run

--process (mux_output)
--begin 
--	if (mux_output = '1') then 
	--	r <= (others => '1');
	--	g <= (others => '1'); 
	--	b <= (others => '1');
--	else
--		r <= (others => '0'); 
--		g <= (others => '0');
--		b <= (others => '0'); 
--	end if; 
--end process; 



end Behavioral;

