USE WORK.Utils.all;

ENTITY TestExhaustivo IS END TestExhaustivo;

ARCHITECTURE Driver of TestMulti4 is 

	component Multi4 
	    port(
	        STB : IN  BIT;
	        CLK : IN  BIT;
	        inRA: IN  BIT_VECTOR(3 downto 0);
	        inRB: IN  BIT_VECTOR(3 downto 0);
	        DONE: OUT BIT;
	        RES : OUT BIT_VECTOR(7 downto 0)
	     );
	end component;	 
	
	component Timer is 
		port(
			STB, CLK, DONE: in BIT;
			min, max, avg, last: out integer
		);
	end component;
	
	signal STB : BIT:='0';
	signal CLK : BIT;
	signal DONE: BIT;
	
	SIGNAL MIN : integer;
	SIGNAL MAX : integer;
	SIGNAL AVG : integer;
	SIGNAL LAST: integer;
	
	SIGNAL T_LAST:TIME;
	SIGNAL T_MIN: TIME;
	SIGNAL T_MAX: TIME;
	SIGNAL T_AVG: TIME;
	
	signal inRA: BIT_VECTOR(3 downto 0);
	signal inRB: BIT_VECTOR(3 downto 0);
	signal RES : BIT_VECTOR(7 downto 0);
	
	signal L : integer := 4;  
	signal Operando1: integer;
	signal Operando2: integer;
	signal Producto : integer;

begin 

    UUT: Multi4 port map(STB, CLK, inRA, inRB, DONE, RES);
	TIM: Timer port map(STB, CLK, DONE, MIN, MAX, AVG,LAST);
	
	clock(CLK, 10ns , 10ns);

    Stimulus: process	
	begin
		for i in 0 to 15 loop 
		inRA <= convert(i,L);
		for j in 0 to 15 loop 	 
			inRB <= convert(j,L);				
			STB <= '1';	 
			Operando1 <= j;	--facilitar lectura waveform	 
			Operando2 <= i;	--facilitar lectura waveform
			wait until DONE'EVENT and DONE='1';
			Producto <= convert(RES); -- facilitar lectura waveform	 
		end loop;
	end loop;
	wait;
	end process;  
	
	T_MIN <= MIN * 20 ns;
	T_MAX <= MAX * 20 ns;
	T_AVG <= MAX * 20 ns;
	T_LAST <= LAST * 20 ns;
	
end;
