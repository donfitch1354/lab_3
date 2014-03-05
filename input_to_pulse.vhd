----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:41:51 03/03/2014 
-- Design Name: 
-- Module Name:    input_to_pulse - Behavioral 
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

entity input_to_pulse is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           input : in  STD_LOGIC;
           pulse : out  STD_LOGIC);
end input_to_pulse;

architecture Behavioral of input_to_pulse is

	type button_type is (idle, pressed, hold);
	signal button_reg, button_next: button_type; 
	signal button, button_next_sig : std_logic; 
	signal count, count_next: unsigned (19 downto 0);
	
	signal debounce1, debounce2, debounce_input_reg, debounce_input_next : std_logic;
	
	signal debounce_counter_reg, debounce_counter_next : unsigned(14 downto 0);
begin

	process(clk, reset)
	begin
		if reset = '1' then
			debounce1 <= '0';
			debounce2 <= '0';
			debounce_counter_reg <= (others => '0');
			debounce_input_reg <= '0';
		elsif rising_edge(clk) then
			debounce1 <= input;
			debounce2 <= debounce1;
			debounce_counter_reg <= debounce_counter_next;
			debounce_input_reg <= debounce_input_next;
		end if;
	end process;
	
	debounce_counter_next <= 	debounce_counter_reg + 1 when debounce1 = debounce2 else
										(others => '0');
										
	debounce_input_next <= debounce2 when debounce_counter_reg = "111111111111111" else
									debounce_input_reg; --!!

	
	process (clk, reset)
	begin
		if (reset = '1') then
			button_reg <= idle; 
		elsif(rising_edge(clk)) then 
			button_reg <= button_next; 
		end if; 
	end process; 

	
	process (button_reg, debounce_input_reg)
	begin 

		button_next <= button_reg;

		case button_reg is 
			when idle =>
				if (debounce_input_reg = '1') then 
					button_next <= pressed; 
				end if;
			when pressed => 
				if (debounce_input_reg = '1') then 
					button_next <= hold;
				else button_next <= idle;
				end if;
			when hold => 
				if (debounce_input_reg = '1') then
					button_next <= hold; 
				else
					button_next <= idle; 
				end if; 
		end case; 
	end process; 

	process (button_reg)
	begin 

		case button_reg is
			when idle => 
				button_next_sig <= '0'; 
			when pressed => 
				
				button_next_sig <= '1'; 
				
			when hold => 
				button_next_sig <= '0'; 
		end case; 
	end process; 

	pulse <= button_next_sig; 

	
end Behavioral;

