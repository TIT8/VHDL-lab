library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

entity top_sim is
--  Port ( );
end top_sim;

architecture Behavioral of top_sim is

	constant MEM_BIT_WIDTH  : integer := 8;
	constant MEM_BIT_LENGTH : integer := 4;

	component AsyncMemory is
		Port (
			input_data	: in std_logic_vector;
			input_addr	: in std_logic_vector; --Unsigned
			
			output_data	: out std_logic_vector;
			output_addr	: in std_logic_vector --Unsigned
		);
	end component;
	
	signal input_data_int, output_data_int : integer := (2**MEM_BIT_WIDTH)-1;
	signal input_addr_int, output_addr_int : integer := 0;
	
	signal input_data, output_data : std_logic_vector(MEM_BIT_WIDTH-1 DOWNTO 0);
	signal input_addr, output_addr : std_logic_vector(MEM_BIT_LENGTH-1 DOWNTO 0);	
	
begin

	DUT : AsyncMemory
		Port Map(
			input_data	=> input_data,
			input_addr	=> input_addr,
			
			output_data	=> output_data,
			output_addr	=> output_addr
		);
	
	input_data <= std_logic_vector(to_unsigned(input_data_int, input_data'LENGTH));
	output_data_int <= to_integer(unsigned(output_data));
	input_addr <= std_logic_vector(to_unsigned(input_addr_int, input_addr'LENGTH));
	output_addr <= std_logic_vector(to_unsigned(output_addr_int, output_addr'LENGTH));


	process
	begin
	
		while (input_addr_int < 2**MEM_BIT_LENGTH-1 -1) loop
			wait for 10ns;
			input_data_int <= input_data_int - 1;
			input_addr_int <= input_addr_int + 1;
		end loop;
		
			wait for 50ns;
		
		while (output_addr_int < 2**MEM_BIT_LENGTH-1 -1) loop
			wait for 10ns;
			output_addr_int <= output_addr_int + 1;
		end loop;
		
		wait;
		
	end process;
	
end Behavioral;
