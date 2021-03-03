library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;

entity Adder_4bit is
Port(

	a	: in std_logic_vector(3 DOWNTO 0);
	b	: in std_logic_vector(3 DOWNTO 0);

	sum	: out std_logic_vector(3 DOWNTO 0)
);
end Adder_4bit;

architecture Behavioral of Adder_4bit is

	component HalfAdder is
		Port (
			in_a	: in  std_logic;
			in_b	: in  std_logic;

			sum	    : out std_logic;
			carry	: out std_logic
		);
	end component;

	component FullAdder is
		Port (
			in_a		: in  std_logic;
			in_b		: in  std_logic;
			carry_in	: in  std_logic;
			sum			: out std_logic;
			carry_out	: out std_logic
		);
	end component;

	signal carries : std_logic_vector(3-1 DOWNTO 0);

begin

	node_1 : HalfAdder
		Port map(
			in_a	=> a(0),
			in_b	=> b(0),

			sum	    => sum(0),
			carry	=> carries(0)
		);


	node_2 : FullAdder
		Port map(
			in_a		=> a(1),
			in_b		=> b(1),
			carry_in	=> carries(0),
			sum			=> sum(1),
			carry_out	=> carries(1)
		);

	node_3 : FullAdder
		Port map(
			in_a		=> a(2),
			in_b		=> b(2),
			carry_in	=> carries(1),
			sum			=> sum(2),
			carry_out	=> carries(2)
		);

	node_4 : FullAdder
		Port map(
			in_a		=> a(3),
			in_b		=> b(3),
			carry_in	=> carries(2),
			sum			=> sum(3),
			carry_out	=> open
		);
end Behavioral;
