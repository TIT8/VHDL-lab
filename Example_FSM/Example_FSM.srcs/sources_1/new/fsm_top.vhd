library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;

entity fsm_top is
	Port ( 
		clk : in std_logic;
		
		seq_in : in std_logic;
		
		detected : out std_logic
	);
end fsm_top;

architecture Behavioral of fsm_top is

	type state_type is (init, S0, S1, det);

	signal state, next_state : state_type := init ;

begin

	sync_logic : process (clk)
	begin
		if rising_edge(clk) then
			state <= next_state;
		end if;
	end process;

	output_logic : process (state)
	begin
		case state is 
			when init =>
				detected <= '0';
			when S0 =>
				detected <= '0';
			when S1 =>
				detected <= '0';
			when det =>
				detected <= '1';
			when others =>			-- Sempre deve esserci, paracadute
				detected <=	'0';
		end case;
	end process;
	
	transition_logic : process (state, seq_in)
	begin
		case state is 
			when init =>
				if seq_in = '1' then
					next_state <= init;
				else
					next_state <= S0;
				end if;
			when S0 =>
				if seq_in = '0' then
					next_state <= S0;
				else
					next_state <= S1;
				end if;
			when S1 =>
				if seq_in = '0' then
					next_state <= S0;
				else
					next_state <= det;
				end if;				
			when det =>
				if seq_in = '0' then
					next_state <= S0;
				else
					next_state <= init;
				end if;
			when others =>			-- Sempre deve esserci, paracadute
				next_state <= init;
		end case;
	end process;

end Behavioral;
