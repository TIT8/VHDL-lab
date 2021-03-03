library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

entity top_sim is
--  Port ( );
end top_sim;

architecture Behavioral of top_sim is
	constant CLK_FREQ : time := 10 ns;

	component StereoToMono is
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
	end component;

	signal reset	: std_logic := '0';
	signal clk		: std_logic := '1';

	------AudioIn Slave AXIS Bus-------
	signal audioIn_tdata 	: std_logic_vector(32-1 DOWNTO 0);
	signal audioIn_tvalid 	: std_logic := '0';
	signal audioIn_tready 	: std_logic;

	signal audioIn_tdata_leftCh		: std_logic_vector(16-1 DOWNTO 0); -- Solo per Waveform
	signal audioIn_tdata_rightCh	: std_logic_vector(16-1 DOWNTO 0); -- Solo per Waveform
	-----------------------------------

	-----AudioOut Master AXIS Bus------
	signal audioOut_tdata 	: std_logic_vector(32-1 DOWNTO 0);
	signal audioOut_tvalid 	: std_logic;
	signal audioOut_tready 	: std_logic := '0';

	signal audioOut_tdata_leftCh	: std_logic_vector(16-1 DOWNTO 0); -- Solo per Waveform
	signal audioOut_tdata_rightCh	: std_logic_vector(16-1 DOWNTO 0); -- Solo per Waveform
	-----------------------------------

	constant MAX_SAMPLES			: integer := 20;
	signal writecount, readCount	: integer := 0;

	type audioSample_type is record
		rightCh : integer;
		leftCh	: integer;
	end record;

	type LUTAudioOut_type is array (natural range <>) of audioSample_type;

	signal LUTAudioOut : LUTAudioOut_type(0 TO MAX_SAMPLES-1) := (	(rightCh => 0, leftCh => 9),
																	(rightCh => 1, leftCh => 1),
																	(rightCh => 2, leftCh => 2),
																	(rightCh => 3, leftCh => 3),
																	(rightCh => 4, leftCh => 4),
																	(rightCh => 10, leftCh => 5),
																	(rightCh => 5, leftCh => 10),
																	(rightCh => 100, leftCh => 100),
																	(rightCh => 1, leftCh => 1),
																	(rightCh => 2, leftCh => 1),
																	(rightCh => 3, leftCh => 1),
																	(rightCh => 4, leftCh => 1),
																	(rightCh => 5, leftCh => 1),
																	(rightCh => 6, leftCh => 1),
																	(rightCh => 1, leftCh => 1),
																	(rightCh => 1, leftCh => 2),
																	(rightCh => 1, leftCh => 3),
																	(rightCh => 1, leftCh => 4),
																	(rightCh => 1, leftCh => 5),
																	(rightCh => 1, leftCh => 6));
begin

	audioIn_tdata_leftCh	<= audioIn_tdata(31 DOWNTO 16); -- Solo per Waveform
	audioIn_tdata_rightCh	<= audioIn_tdata(15 DOWNTO 0); -- Solo per Waveform

	audioOut_tdata_leftCh	<= audioOut_tdata(31 DOWNTO 16); -- Solo per Waveform
	audioOut_tdata_rightCh	<= audioOut_tdata(15 DOWNTO 0); -- Solo per Waveform


	DUT : StereoToMono
	Port Map(
		reset 	=> reset,
		clk		=> clk,

		------AudioIn Slave AXIS Bus-------
		audioIn_tdata 	=> audioIn_tdata,
		audioIn_tvalid 	=> audioIn_tvalid,
		audioIn_tready 	=> audioIn_tready,
		-----------------------------------

		-----AudioOut Master AXIS Bus------
		audioOut_tdata 	=> audioOut_tdata,
		audioOut_tvalid => audioOut_tvalid,
		audioOut_tready => audioOut_tready
		-----------------------------------
		);


	clk <= not clk after CLK_FREQ/2;


	audioIn_tdata <= std_logic_vector(to_signed(LUTAudioOut(writecount).LeftCh, 16)) & std_logic_vector(to_signed(LUTAudioOut(writecount).RightCh, 16));
	sendDataProcess: process
	begin
		wait for 20 ns;

		audioIn_tvalid <= '1';

		while True loop
			if audioIn_tready = '1' and audioIn_tvalid = '1' then
				report "AUDIO INPUT => Transazione in ingresso completata. Right Channel: " & integer'image(LUTAudioOut(writecount).rightCh) & " Left Channel: " & integer'image(LUTAudioOut(writecount).LeftCh);
				writecount <= writecount + 1;
				audioIn_tvalid <= '0';

				exit;
			end if;
			wait until rising_edge(clk);
		end loop;

		for I in 0 to 10 loop
			wait until rising_edge(clk);
		end loop;

		audioIn_tvalid <= '1';

		while True loop

			if audioIn_tready = '1' and audioIn_tvalid = '1' then
				report "AUDIO INPUT => Transazione in ingresso completata. Right Channel: " & integer'image(LUTAudioOut(writecount).rightCh) & " Left Channel: " & integer'image(LUTAudioOut(writecount).LeftCh);
				writecount <= writecount + 1;
				if writecount >= MAX_SAMPLES -1 then
					writecount <= MAX_SAMPLES -1;
					report "AUDIO INPUT => Sono stati mandati tutti i campioni disponibili";
					audioIn_tvalid <= '0';
					exit;
				end if;
			end if;

			wait until rising_edge(clk);

		end loop;
		wait;
	end process;


	receiveDataProcess : process
		variable rightChIn, leftChIn, rightChOut, leftChOut : integer;
	begin

		wait for 20 ns;

		audioOut_tready <= '1';

		while True loop

			if audioOut_tready = '1' and audioOut_tvalid = '1' then
				--------Check Values---------
				rightChIn	:= LUTAudioOut(readCount).rightCh;
				leftChIn	:= LUTAudioOut(readCount).LeftCh;
				leftChOut	:= to_integer(signed(audioOut_tdata(31 DOWNTO 16)));
				rightChOut	:= to_integer(signed(audioOut_tdata(15 DOWNTO 0)));

				assert leftChOut = rightChOut report "AUDIO OUTPUT => Canale destro e sinistro in uscita non sono uguali!" severity ERROR;
				assert (rightChIn + leftChIn) / 2 = rightChOut or (rightChIn / 2 + leftChIn / 2) = rightChOut report "AUDIO OUTPUT => L'operazione Stereo to Mono contiene degli errori!" severity ERROR;
				-----------------------------

				report "AUDIO OUTPUT => Transazione in uscita completata. Right Channel: " & integer'image(rightChOut) & " Left Channel: " & integer'image(leftChOut);

				readCount <= readCount + 1;
				audioOut_tready <= '0';

				exit;
			end if;
			wait until rising_edge(clk);
		end loop;

		for I in 0 to 10 loop
			wait until rising_edge(clk);
		end loop;

		audioOut_tready <= '1';

		while True loop

			if audioOut_tready = '1' and audioOut_tvalid = '1' then

				--------Check Values---------
				rightChIn	:= LUTAudioOut(readCount).rightCh;
				leftChIn	:= LUTAudioOut(readCount).LeftCh;
				leftChOut	:= to_integer(signed(audioOut_tdata(31 DOWNTO 16)));
				rightChOut	:= to_integer(signed(audioOut_tdata(15 DOWNTO 0)));

				assert leftChOut = rightChOut report "AUDIO OUTPUT => Canale destro e sinistro in uscita non sono uguali!" severity ERROR;
				assert (rightChIn + leftChIn) / 2 = rightChOut or (rightChIn / 2 + leftChIn / 2) = rightChOut report "AUDIO OUTPUT => L'operazione Stereo to Mono contiene degli errori!" severity ERROR;
				-----------------------------

				report "AUDIO OUTPUT => Transazione in uscita completata. Right Channel: " & integer'image(rightChOut) & " Left Channel: " & integer'image(leftChOut);

				readCount <= readCount + 1;
				if readCount >= MAX_SAMPLES -1 then
					readCount <= MAX_SAMPLES -1;
					report "AUDIO OUTPUT => Sono stati ricevuti tutti i campioni disponibili";
					audioOut_tready <= '0';
					exit;
				end if;
			end if;

			wait until rising_edge(clk);

		end loop;

		assert FALSE Report "Simulation Finished" severity FAILURE;

		wait;

	end process;
end Behavioral;
