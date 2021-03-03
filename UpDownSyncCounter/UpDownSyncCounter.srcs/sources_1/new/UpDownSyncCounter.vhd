library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

entity UpDownSyncCounter is
	Generic(
		COUNT_WIDTH	: integer := 4
	);
	Port (
		reset		: in std_logic;
		clk			: in std_logic;

		inc_count	: in std_logic;
		dec_count	: in std_logic;

		count		: out std_logic_vector(COUNT_WIDTH-1 DOWNTO 0) -- Signed
		);
end UpDownSyncCounter;

architecture Behavioral of UpDownSyncCounter is

	component ff_d is
		Port(
			reset	: in std_logic;
			clk		: in std_logic;

			d 	:	in std_logic;
			q 	: out std_logic
		);
	end component;

	signal count_internal	: signed(count'RANGE) := (Others => '0');
	signal count_reg		: signed(count'RANGE) := (Others => '0');

begin

	-- Istanzio la batteria di FF che servono per creare il registro d'uscita
	reg_gen : for I in count'RANGE generate

		ff_d_inst : ff_d
			Port Map(
				reset	=> reset,
				clk		=> clk,

				d 	=> count_internal(I),
				q 	=> count_reg(I)
			);

	end generate;

	count <= std_logic_vector(count_reg);

	count_internal	<= 	count_reg + 1 when inc_count = '1' and dec_count = '0' else
						count_reg - 1 when inc_count = '0' and dec_count = '1' else
						count_reg;
end Behavioral;
