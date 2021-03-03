library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

entity MealyEdgeDetector is
	Port (
		clk		: in std_logic;
		reset 	: in std_logic;

		signal_in	: in std_logic;
		upEdge		: out std_logic;
		downEdge	: out std_logic
	);
end MealyEdgeDetector;

architecture Behavioral of MealyEdgeDetector is
	type state_type is (IDLE, WAITING_UP, WAITING_DOWN);

	signal state, nextState : state_type := IDLE;
begin

	synchronousLogic : process (reset, clk)
	begin
		if reset = '1' then
			state <= IDLE;
		elsif rising_edge(clk) then
			state <= nextState;
		end if;

	end process;


	nextStateLogic : process (state, signal_in)
	begin

		case (state) is

			when IDLE =>
				nextState <= WAITING_UP;

			when WAITING_UP =>
				if signal_in = '1' then
					nextState <= WAITING_DOWN;
				else
					nextState <= WAITING_UP;
				end if;

			when WAITING_DOWN =>
				if signal_in = '0' then
					nextState <= WAITING_UP;
				else
					nextState <= WAITING_DOWN;
				end if;

			when Others =>
				nextState <= IDLE;
		end case;

	end process;


	outputLogic : process (state)
	begin

		case (state) is

			when IDLE =>
				upEdge 		<= '0';
				downEdge	<= '0';

			when WAITING_UP =>
				if signal_in = '1' then
					upEdge 		<= '1';
					downEdge	<= '0';
				else
					upEdge 		<= '0';
					downEdge	<= '0';
				end if;

			when WAITING_DOWN =>
				if signal_in = '0' then
					upEdge 		<= '0';
					downEdge	<= '1';
				else
					upEdge 		<= '0';
					downEdge	<= '0';
				end if;

			when Others =>
				upEdge 		<= '0';
				downEdge	<= '0';
		end case;

	end process;
end Behavioral;
