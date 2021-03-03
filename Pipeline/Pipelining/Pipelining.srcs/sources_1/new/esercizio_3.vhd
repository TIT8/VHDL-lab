library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

entity esercizio_3 is
	Port (
		reset	: in std_logic;
		clk		: in std_logic;


		input_a	: in std_logic_vector(31 DOWNTO 0);
		input_b	: in std_logic_vector(31 DOWNTO 0);
		input_c	: in std_logic_vector(31 DOWNTO 0);

		result	: out std_logic_vector(31 DOWNTO 0)
		);
end esercizio_3;

architecture Behavioral of esercizio_3 is

	component multiplier is
		Port (

		input_a			: in unsigned(31 DOWNTO 0);
		input_b			: in unsigned(31 DOWNTO 0);

		result			: out unsigned(31 DOWNTO 0)

		);
	end component;

	component adder is
		Port (

		input_a			: in unsigned(31 DOWNTO 0);
		input_b			: in unsigned(31 DOWNTO 0);

		result			: out unsigned(31 DOWNTO 0)

		);
	end component;

	signal input_a_int, input_b_int, input_c_int, result_mul_int, result_adder_int : unsigned(31 DOWNTO 0);
	signal input_c_sampled, result_mul_sampled : unsigned(31 DOWNTO 0);
begin

	multiplier_inst : multiplier
		Port Map(

		input_a			=> input_a_int,
		input_b			=> input_b_int,

		result			=> result_mul_int


		);

	adder_inst : adder
			Port Map(

			input_a			=> result_mul_sampled,
			input_b			=> input_c_sampled,

			result			=> result_adder_int


			);

	input_a_int <= unsigned(input_a);
	input_b_int <= unsigned(input_b);
	input_c_int <= unsigned(input_c);
	
	process (clk, reset)
	begin
		if rising_edge(clk) then
		
			input_c_sampled 	<= input_c_int;
			result_mul_sampled 	<= result_mul_int;
			
			result	<= std_logic_vector(result_adder_int);
		end if;
	end process;
	

end Behavioral;
