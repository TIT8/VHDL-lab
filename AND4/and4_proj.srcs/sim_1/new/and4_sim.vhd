library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;

entity and4_sim is
--  Port ( );
end and4_sim;

architecture Behavioral of and4_sim is

	component and4_completa is
		Port ( 
			a0 	: in std_logic;
			a1 	: in std_logic;
			a2 	: in std_logic;
			a3 	: in std_logic;
			
			b 	: out std_logic
		);
	end component;
	
	signal a0, a1, a2, a3, b: std_logic := '0';
	
begin
	
	dut: and4_completa
		Port Map( 
			a0 	=> a0,
			a1 	=> a1,
			a2 	=> a2,
			a3 	=> a3,
			
			b 	=> b
		);
	
	
	drive_a0 : process
	begin
	
		wait for 400ns;	
		a0 <= '1';
		wait;
	end process;

	drive_a1 : process
		variable i : integer := 0;
	begin
	
		for i in 0 to 3 loop
			wait for 200ns;
			a1 <= not a1;
		end loop;
		wait;
	end process;
	
	drive_a2 : process
		variable i : integer := 0;
	begin
	
		for i in 0 to 7 loop
			wait for 100ns;
			a2 <= not a2;
		end loop;
		wait;
	end process;
	
	drive_a3 : process
		variable i : integer := 0;
	begin
	
		for i in 0 to 15 loop
			wait for 50ns;
			a3 <= not a3;
		end loop;
		wait;
	end process;
	
end Behavioral;
