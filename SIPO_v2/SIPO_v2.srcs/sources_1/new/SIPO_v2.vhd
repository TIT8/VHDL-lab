library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SIPO_v2 is
	Port (
		reset : in std_logic;
		clk : in std_logic;
		
		data_in : in std_logic;
		data_out : out std_logic_vector(3 downto 0)
	);
end SIPO_v2;

architecture Behavioral of SIPO_v2 is

	signal data : std_logic_vector(data_out'RANGE) := (others => '0');

begin

	data_out <= data;

	process (clk, reset)
	begin
	
		if reset = '1' then
			data <= (others => '0');
		elsif rising_edge(clk) then
			-- data(data'LEFT) <= data_in;
			-- data(data'LEFT-1 DOWNTO 0) <= data(data'LEFT DOWNTO 1);
			data <= data_in & data(data'LEFT DOWNTO 1);
		end if;
		
	end process;

end Behavioral;
