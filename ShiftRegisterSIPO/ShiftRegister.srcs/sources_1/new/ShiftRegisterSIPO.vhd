library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;

entity ShiftRegisterSIPO is
	Generic(
		SR_WIDTH	: integer := 4
	);
	Port(
		reset		: in std_logic;
		clk			: in std_logic;

		data_in		: in std_logic;

		data_out	: out std_logic_vector(SR_WIDTH-1 DOWNTO 0)

	);
end ShiftRegisterSIPO;

architecture Behavioral of ShiftRegisterSIPO is

	component ff_d is
		Port(
			reset	: in std_logic;
			clk		: in std_logic;

			d 	:	in std_logic;
			q 	: out std_logic
		);
	end component;

	signal data_reg : std_logic_vector(data_out'RANGE);

begin

	REG_GEN : for I in data_out'RANGE generate

		FIRST_FF_GEN : if I = data_out'LEFT generate

			ff_d_inst :  ff_d
				Port Map(
					reset	=> reset,
					clk		=> clk,

					d 	=> data_in,
					q 	=> data_reg(I)
				);

		end generate;

		OTHERS_FF_GEN : if I /= data_out'LEFT generate

			ff_d_inst :  ff_d
				Port Map(
					reset	=> reset,
					clk		=> clk,

					d 	=> data_reg(I + 1),
					q 	=> data_reg(I)
				);

		end generate;

	end generate;

	data_out	<= data_reg;
end Behavioral;
