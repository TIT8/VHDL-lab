library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

entity PWM is
	Port (
		reset 	: in std_logic;
		clk		: in std_logic;

		t_on	: in std_logic_vector(8-1 DOWNTO 0);	-- UNSIGNED
		t_total	: in std_logic_vector(8-1 DOWNTO 0);	-- UNSIGNED

		pwm_out	: out std_logic
	);
end PWM;

architecture Behavioral of PWM is

	signal count 		: unsigned(t_total'RANGE) := to_unsigned(0, t_total'LENGTH); --Oppure (Others => '0')

	signal t_on_reg		: std_logic_vector(t_on'RANGE) := (Others => '0');
	signal t_total_reg	: std_logic_vector(t_total'RANGE) := (Others => '0');

begin

	process(clk, reset)
	begin

		if reset = '1' then

			count 		<= to_unsigned(0, t_total'LENGTH);

			t_on_reg 	<= t_on;
			t_total_reg	<= t_total;

			pwm_out	<= '0';

		elsif rising_edge(clk) then

			count <= count + 1;

			if count = unsigned(t_total_reg) then
				-- Se è verificata questa condizione il PWM è a fine periodo
				count <= to_unsigned(0, count'LENGTH);
				pwm_out <= '1';

				-- Registro i parametri in ingresso per il prossimo ciclo
				t_on_reg 	<= t_on;
				t_total_reg	<= t_total;

			elsif count = unsigned(t_on_reg) then
				-- Se è verificata questa condizione è finito il t_on
				pwm_out <= '0';

			end if;

		end if;

	end process;

end Behavioral;
