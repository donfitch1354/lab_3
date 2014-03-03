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
           row : in  unsigned (10 downto 0);
           column : in  unsigned (10 downto 0);
           ascii_to_write : in  unsigned (7 downto 0);
           write_en : in  STD_LOGIC;
           r,g,b : out  std_logic_vector (7 downto 0)
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
			addr : in unsigned (10 downto 0); 
			data: out unsigned ( 7 downto 0)  
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
signal mux_output: std_logic; 
signal data_font: unsigned (7 downto 0); 
signal buffer_out_a, buffer_out_b: std_logic_vector (7 downto 0); 
signal count, count_next: std_logic_vector (11 downto 0); 
signal address_signal, address: std_logic_vector (10 downto 0);
signal row_next, row_reg: std_logic_vector (3 downto 0); 
signal column_reg, column_next, column_next_next: std_logic_vector (2 downto 0); 


signal row_col: std_logic_vector (13 downto 0);
signal row_col_2 : std_logic_vector (11 downto 0); 


begin

Inst_char_screen_buffer: char_screen_buffer PORT MAP(
			clk => clk, 
			we => write_enabled,
			address_a => count,
			address_b => row_col_multiply_12,
			data_in => ascii_to_write,
			data_out_a => open,
			data_out_b => data_b_sig
			);
			
Inst_font_rom: font_rom PORT MAP (
			clk => clk, 
			addr => address_signal,
			data => font_data
			); 
			

Inst_mux: mux PORT MAP (
			data => font_data, 
			sel => col_next_2, 
			output => mux_output
			);

count <= std_logic_vector( unsigned (count_next) + 1) when rising_edge(write_en) else
						count_next; 
						
count_next <= (others => '0') when reset = '1' 
		else 
			count; 





process (mux_output)
begin 
	if (mux_output = '1') then 
		r <= (others => '1');
		g <= (others => '1'); 
		b <= (others => '1');
	else
		r <= (others => '0'); 
		g <= (others => '0');
		b <= (others => '0'); 
	end if; 
end process; 



end Behavioral;

