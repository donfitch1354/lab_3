----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:37:50 02/25/2014 
-- Design Name: 
-- Module Name:    Mux - Behavioral 
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

entity Mux is
    Port ( sel : in  unsigned (2 downto 0);
           data : in  unsigned (7 downto 0);
           output : out  STD_LOGIC);
end Mux;

architecture Behavioral of Mux is

begin
 process (sel, data) is 
	begin 
	
	if (sel = "000") then 
		output <= data(7);
	elsif (sel = "001") then 
		output <= data(6);
	elsif(sel = "010") then 
		output <= data(5);
	elsif(sel = "011") then 
		output <= data(4);
	elsif(sel = "100") then 
		output <= data(3);
	elsif (sel = "101") then 
		output <= data(2);
	elsif(sel = "110") then 
		output <= data(1);
	elsif(sel = "111") then 
		output <= data(0);
	end if; 
end process; 

end Behavioral;

