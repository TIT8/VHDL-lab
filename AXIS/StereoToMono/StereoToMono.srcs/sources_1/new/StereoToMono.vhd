library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

entity StereoToMono is
		Port (
			reset : in std_logic;
			clk	: in std_logic;

			------AudioIn Slave AXIS Bus-------
			audioIn_tdata 	: in std_logic_vector(32-1 DOWNTO 0);
			audioIn_tvalid 	: in std_logic;
			audioIn_tready 	: out std_logic;
			-----------------------------------

			-----AudioOut Master AXIS Bus------
			audioOut_tdata 	: out std_logic_vector(32-1 DOWNTO 0);
			audioOut_tvalid : out std_logic;
			audioOut_tready : in std_logic
			-----------------------------------
			);
	end StereoToMono;
	
architecture Behavioral of StereoToMono is

	COMPONENT fifo_generator_0
	  PORT (
		clk 	: IN STD_LOGIC;
		srst 	: IN STD_LOGIC;
		din 	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		wr_en 	: IN STD_LOGIC;
		rd_en 	: IN STD_LOGIC;
		dout 	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		full 	: OUT STD_LOGIC;
		empty 	: OUT STD_LOGIC
	  );
	END COMPONENT;

	------------ FIFO Signals ------------
	signal din, dout 	: std_logic_vector(16-1 DOWNTO 0);
	signal wr_en, rd_en : std_logic := '0';
	signal empty, full 	: std_logic;
	--------------------------------------
	
	------------ SCRITTURA ---------------
	signal somma : signed(17-1 DOWNTO 0);
	signal chDX_in, chSX_in : signed(16-1 DOWNTO 0);
	--------------------------------------
	
	------------ LETTURA -----------------
	signal outTemp_tdata 	: std_logic_vector(16-1 DOWNTO 0);
	signal outTemp_tvalid 	: std_logic := '0';
	--------------------------------------
begin

	FIFO_inst : fifo_generator_0
	  PORT MAP (
		clk 	=> clk,
		srst 	=> reset,
		din 	=> din,
		wr_en 	=> wr_en,
		rd_en 	=> rd_en,
		dout 	=> dout,
		full 	=> full,
		empty 	=> empty
	);
	  
	---------- SCRITTURA FIFO -----------
	chDX_in <= signed(AudioIn_tdata(15 DOWNTO 0));
	chSX_in <= signed(AudioIn_tdata(31 DOWNTO 16));
	
	somma <= (chDX_in(chDX_in'LEFT) & chDX_in) + (chSX_in(chSX_in'LEFT) & chSX_in);
	
	din 			<= std_logic_vector(somma(16 DOWNTO 1));
	wr_en			<= AudioIn_tvalid;
	AudioIn_tready 	<= not full;
	-------------------------------------
	
	
	----------- LETTURA FIFO ------------
	outTemp_tdata 	<= dout;
	AudioOut_tdata 	<= outTemp_tdata & outTemp_tdata;
	AudioOut_tvalid	<= outTemp_tvalid;
	
	process(clk, reset)
	begin
		
		if reset = '1' then
			outTemp_tvalid <= '0';
			
		elsif rising_edge(clk) then
			
			if rd_en = '1' then
				-- Se c'è stata una richiesta di lettura dalla FIFO il dato
				-- presente sulla porta dout è sicuramente valido, metto il
				-- outTempo_tvalid alto per segnalare in uscita la possibilità
				-- di leggere un dato valido
				rd_en <= '0';
				outTemp_tvalid <= '1';
			elsif empty = '0' and (outTemp_tvalid = '0' or AudioOut_tready = '1') then
				-- Se la FIFO non è vuota e non ho outTemp_tvalid alto faccio una richiesta 
				-- di lettura della FIFO.
				-- Modifica rispetto a quanto visto in laboratorio:
				-- Richiedo un nuovo dato anche se AudioOut_tready è alto. Così facendo
				-- risparmio un ciclo ci clock perchè so già che nel prossimo ciclo di
				-- clock outTemp_tvalid sarà basso.
				rd_en <= '1';
			end if;
			
			if AudioOut_tready = '1' and outTemp_tvalid = '1' then
				outTemp_tvalid <= '0';
			end if;
			
		end if;
	
	end process;
	-------------------------------------
	 
end Behavioral;
