library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

entity top_sim is
--  Port ( );
end top_sim;

architecture Behavioral of top_sim is

	constant CLK_PERIOD : Time := 10 ns;
	signal clk :std_logic := '0';
	signal seq_in, detected : std_logic;
	constant sequenza : std_logic_vector(15 downto 0) := "0011101100100110";
	
	component fsm_top is
		Port ( 
			clk : in std_logic;
			
			seq_in : in std_logic;
			
			detected : out std_logic
		);
	end component;

begin

	clk <= not clk after CLK_PERIOD/2;

	DUT : fsm_top
		port map(
			clk => clk,
			seq_in => seq_in,
			detected => detected
		);
	
	process
	begin
		seq_in <= '0';
		wait for 15 ns;
		wait until rising_edge(clk);
		for i in sequenza'range loop
			seq_in <= sequenza(i);
			wait until rising_edge(clk);  -- Inietto ogni colpo di clock
		end loop;
		wait;
	end process;

end Behavioral;
