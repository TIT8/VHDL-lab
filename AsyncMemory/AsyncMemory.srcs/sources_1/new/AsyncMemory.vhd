library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

entity AsyncMemory is
	Port (
		input_data : in std_logic_vector;
		input_addr : in std_logic_vector;	--Unsigned
		
		output_data : out std_logic_vector;
		output_addr : in std_logic_vector	--Unsigned
	);
end AsyncMemory;

architecture Behavioral of AsyncMemory is

	type memory is array(0 TO 2**input_addr'LENGTH-1) of std_logic_vector(input_data'RANGE);
	signal mymem : memory := (others => (Others => '0'));

begin
	
	mymem(to_integer(unsigned(input_addr))) <= input_data;
	output_data <= mymem(to_integer(unsigned(output_addr)));

end Behavioral;
