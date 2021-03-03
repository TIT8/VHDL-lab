library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;

entity Example_process is
	Port (
	   clk : in std_logic;
		a : in std_logic_vector(7 downto 0);
		b : out std_logic_vector(7 downto 0)
	);
end Example_process;

architecture Behavioral of Example_process is

begin

	process (clk)
	
	begin
	
	if rising_edge(clk) then
        b <= a;
    end if;
	
	end process;


end Behavioral;
