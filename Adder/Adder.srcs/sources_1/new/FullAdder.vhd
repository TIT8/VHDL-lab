library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;

entity FullAdder is
	Port (
		in_a		: in  std_logic;
		in_b		: in  std_logic;
		carry_in	: in  std_logic;
		sum		: out std_logic;
		carry_out	: out std_logic
	);
end FullAdder;

architecture Behavioral of FullAdder is

	component HalfAdder is
		Port (
				in_a	: in  std_logic;
				in_b	: in  std_logic;

				sum		:  out std_logic;
				carry	: out std_logic
		);
	end component;

	signal sum_2			: std_logic;
	signal carry_1, carry_2	: std_logic;

begin

	HA_inst1 : HalfAdder
		Port Map(
			in_a	=> carry_in,
			in_b	=> sum_2,
			sum		=> sum,
			carry	=> carry_1
		);

	HA_inst2 : HalfAdder
		Port Map(
			in_a	=> in_a,
			in_b	=> in_b,
			sum		=> sum_2,
			carry	=> carry_2
		);

	carry_out	<= carry_1 or carry_2;

end Behavioral;
