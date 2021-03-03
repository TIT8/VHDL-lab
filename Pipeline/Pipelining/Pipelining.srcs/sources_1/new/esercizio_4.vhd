library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

entity esercizio_4 is
	Port (
		reset	: in std_logic;
		clk		: in std_logic;


		input_a	: in std_logic_vector(31 DOWNTO 0);
		input_b	: in std_logic_vector(31 DOWNTO 0);
		input_c	: in std_logic_vector(31 DOWNTO 0);

		result	: out std_logic_vector(31 DOWNTO 0)
		);
end esercizio_4;

architecture Behavioral of esercizio_4 is

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

	
	
	signal input_a_int, input_b_int, input_c_int : unsigned(31 DOWNTO 0);
	signal result_adder_int : unsigned(31 DOWNTO 0);
	
	-------- Signals for synchronization --------
	type ShiftRegisterMem_type is array (0 TO 2) of unsigned(31 DOWNTO 0);
	signal shiftRegister_input_c : ShiftRegisterMem_type := (Others => (Others => '0'));
	--------------------------------------------
	
	-------- Signals for Multipliers ---------
	type multipliers_data_array_type is array (0 TO 1) of unsigned(31 DOWNTO 0);
	signal mul_input_a, mul_input_b, mul_result : multipliers_data_array_type;
	------------------------------------------
	
	-------- Signals for Multiplexing --------
	signal mux_position 	: integer range 0 to 1:= 0;
	signal mux_mul_result 	: unsigned(31 DOWNTO 0);
	------------------------------------------
begin

	multiplier_A_inst : multiplier
		Port Map(

		input_a			=> mul_input_a(0),
		input_b			=> mul_input_b(0),

		result			=> mul_result(0)


		);

	multiplier_B_inst : multiplier
			Port Map(

			input_a			=> mul_input_a(1),
			input_b			=> mul_input_b(1),

			result			=> mul_result(1)


			);

	adder_inst : adder
			Port Map(

			input_a			=> mux_mul_result,
			input_b			=> shiftRegister_input_c(2),

			result			=> result_adder_int


			);

	input_a_int <= unsigned(input_a);
	input_b_int <= unsigned(input_b);
	input_c_int <= unsigned(input_c);
	
	-- Shift Register per la sincronizzazione dei dati in ingresso input_c
	shiftRegister : process (clk, reset)
	begin
		if rising_edge(clk) then
			shiftRegister_input_c(0) 		<= input_c_int;
			shiftRegister_input_c(1 TO 2) 	<= shiftRegister_input_c(0 TO 1);
		end if;
	end process;
	
	outputSampling : process (clk, reset)
	begin
		if rising_edge(clk) then
			result	<= std_logic_vector(result_adder_int);
		end if;
	end process;
	
	muxing : process (clk, reset)
	begin
		if rising_edge(clk) then
			
			if mux_position = 0 then
				mux_position	<= 1;
			else
				mux_position 	<= 0;
			end if;
			
			mux_mul_result	<= mul_result(mux_position);
			
			mul_input_a(mux_position) <= input_a_int;
			mul_input_b(mux_position) <= input_b_int;
			
		end if;
	end process;
	

end Behavioral;


















