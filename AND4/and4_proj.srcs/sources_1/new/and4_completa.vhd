library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;

entity and4_completa is
	Port ( 
		a0 	: in std_logic;
		a1 	: in std_logic;
		a2 	: in std_logic;
		a3 	: in std_logic;
		
		b 	: out std_logic
	);
end and4_completa;

architecture Behavioral of and4_completa is

begin

	b <= a0 and a1 and a2 and a3;

end Behavioral;
