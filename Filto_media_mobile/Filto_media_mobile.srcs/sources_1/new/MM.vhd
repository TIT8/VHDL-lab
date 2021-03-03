library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

entity MM is
	generic(
		MEAN_LENGTH2	: integer := 2;
		DATA_WIDTH	: integer := 8
	);
	Port (
		clk		: in std_logic;

		data_in		: in unsigned(DATA_WIDTH-1 DOWNTO 0);
		data_out	: out unsigned(DATA_WIDTH-1 DOWNTO 0)
	);
end MM;

architecture Behavioral of MM is

	type mem_type is array (0 TO 2**MEAN_LENGTH2-1) of unsigned(data_in'RANGE);
	signal mem : mem_type := (Others => (Others => '0'));

begin

	process (clk)
		variable var : unsigned(data_in'LENGTH DOWNTO 0) := (Others => '0');
	begin
		if rising_edge(clk) then
			mem <= data_in & mem(0 TO mem'RIGHT-1);
			
			var := (Others => '0');
			for I in 0 TO 2**MEAN_LENGTH2-1 loop
				
					var := var + (mem(I)(data_in'HIGH) & mem(I));
				
			end loop;
			
			var(MEAN_LENGTH2-1 DOWNTO 0) := (Others => '0');
			data_out <= var(MEAN_LENGTH2-1 DOWNTO 0) & var(var'LEFT-1 DOWNTO MEAN_LENGTH2);
			
		end if;
	end process;

end Behavioral;
