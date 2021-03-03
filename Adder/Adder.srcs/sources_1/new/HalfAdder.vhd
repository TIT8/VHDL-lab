library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;

entity HalfAdder is
	Port (	
		in_a	: in  std_logic;
		in_b	: in  std_logic;
		
		sum	    : out std_logic;
		carry	: out std_logic
	);
end HalfAdder;

architecture Behavioral of HalfAdder is
begin
	sum		<= in_a xor in_b;
	carry	<= in_a and in_b;
end Behavioral;