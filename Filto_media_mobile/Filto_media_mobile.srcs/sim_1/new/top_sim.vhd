library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

entity top_sim is
--  Port ( );
end top_sim;

architecture Behavioral of top_sim is

	constant DATA_WIDTH : integer := 8;
	constant MEAN_LENGTH2 : integer := 2;
	
	component MM is
		generic(
			MEAN_LENGTH2	: integer := 2;
			DATA_WIDTH	: integer := 8
		);
		Port (
			clk		: in std_logic;

			data_in		: in unsigned(DATA_WIDTH-1 DOWNTO 0);
			data_out	: out unsigned(DATA_WIDTH-1 DOWNTO 0)
		);
	end component;
	
	signal clk : std_logic := '0';
	signal data_in, data_out : unsigned(DATA_WIDTH-1 DOWNTO 0) := (Others => '0');
    signal data : integer := 0;

begin

	MM_inst : MM
		Generic Map(
			DATA_WIDTH => DATA_WIDTH,
			MEAN_LENGTH2 => MEAN_LENGTH2
		)
		Port Map(
			clk => clk,
			data_in => data_in,
			data_out => data_out
		);
	
	clk <= not clk after 20 ns;
	data_in <= to_unsigned(data, data_in'LENGTH);
	
	process
	begin
        data <= data + 2;
		wait until rising_edge(clk);
	end process;

end Behavioral;
