library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

entity FIFO_sim is
--  Port ( );
end FIFO_sim;

architecture Behavioral of FIFO_sim is

	constant CLK_PERIOD : time := 10 ns;

	constant FIFO_WIDTH : integer := 8;
	constant FIFO_DEPTH : integer := 4;

	component FIFO is
		Generic(
			FIFO_WIDTH : integer := 8;
			FIFO_DEPTH : integer := 16
		);
		Port(
			reset 	: in std_logic;
			clk 	: in std_logic;

			din 	: in std_logic_vector(FIFO_WIDTH-1 DOWNTO 0);
			dout 	: out std_logic_vector(FIFO_WIDTH-1 DOWNTO 0);

			rd_en 	: in std_logic;
			wr_en 	: in std_logic;

			full 	: out std_logic;
			empty 	: out std_logic
		);
	end component;

	component FIFO_var is
		Generic(
			FIFO_WIDTH : integer := 8;
			FIFO_DEPTH : integer := 16
		);
		Port(
			reset 	: in std_logic;
			clk 	: in std_logic;

			din 	: in std_logic_vector(FIFO_WIDTH-1 DOWNTO 0);
			dout 	: out std_logic_vector(FIFO_WIDTH-1 DOWNTO 0);

			rd_en 	: in std_logic;
			wr_en 	: in std_logic;

			full 	: out std_logic;
			empty 	: out std_logic
		);
	end component;

	signal reset 		: std_logic := '0';
	signal clk 			: std_logic := '1';

	signal din, dout 	: std_logic_vector(FIFO_WIDTH-1 DOWNTO 0);
	signal rd_en, wr_en : std_logic := '0';

	signal full, empty 	: std_logic;

	signal dinInteger 	: integer;
begin

	-- Lascio solo il modulo che voglio simulare

	FIFO_inst : FIFO
		Generic Map(
			FIFO_WIDTH => FIFO_WIDTH,
			FIFO_DEPTH => FIFO_DEPTH
		)
		Port Map(
			reset 	=> reset,
			clk 	=> clk,

			din 	=> din,
			dout 	=> dout,

			rd_en 	=> rd_en,
			wr_en 	=> wr_en,
	
			full 	=> full,
			empty 	=> empty
		);

	-- FIFO_var_inst : FIFO_var
	-- 	Generic Map(
	-- 		FIFO_WIDTH => FIFO_WIDTH,
	-- 		FIFO_DEPTH => FIFO_DEPTH
	-- 	)
	-- 	Port Map(
	-- 		reset 	=> reset,
	-- 		clk 	=> clk,
	--
	-- 		din 	=> din,
	-- 		dout 	=> dout,
	--
	-- 		rd_en 	=> rd_en,
	-- 		wr_en 	=> wr_en,
	--
	-- 		full 	=> full,
	-- 		empty 	=> empty
	-- 	);

	clk <= not clk after CLK_PERIOD/2;

	din <= std_logic_vector(to_unsigned(dinInteger,din'LENGTH));


	process
	begin

		reset <= '1';
		dinInteger <= 0;

		for I in 0 to 5 loop
			wait until rising_edge(clk);
		end loop;

		reset <= '0';
		wr_en <= '1';

		for I in 0 to 5 loop
			wait until rising_edge(clk);
			dinInteger <= dinInteger + 1;
		end loop;

		rd_en <= '1';

		for I in 0 to 5 loop
			wait until rising_edge(clk);
			dinInteger <= dinInteger + 1;
		end loop;

		wr_en <= '0';

		for I in 0 to 10 loop
			wait until rising_edge(clk);
		end loop;

		rd_en <= '0';

		wait until rising_edge(clk);

		wait;
	end process;

end Behavioral;
