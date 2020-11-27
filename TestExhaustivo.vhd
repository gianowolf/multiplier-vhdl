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
	
	signal STB : BIT:='0';
	signal CLK : BIT;
	signal DONE: BIT;			  
	
	signal inRA: BIT_VECTOR(3 downto 0);
	signal inRB: BIT_VECTOR(3 downto 0);
	signal RES : BIT_VECTOR(7 downto 0);
	
	signal L : NATURAL := 4;  
	signal Operando1 : NATURAL := 0;
	signal Operando2 : NATURAL := 0;
	signal Producto : NATURAL;

begin 

    UUT: Multi4 port map(STB, CLK, inRA, inRB, DONE, RES);
	
	clock(CLK, 30ns , 30ns);

    Stimulus: process	
	begin
		for i in 0 to 15 loop 
			inRA <= convert(i,L);
			for j in 0 to 15 loop 
				inRB <= convert(j,L);
				Operando1 <= j;		 
				Operando2 <= i;
				STB <= '1';
				wait for 20ns;
				STB <= '0';
				wait until DONE'EVENT and DONE='1'; 
				Producto <= convert(RES);
			end loop;
		end loop;
		wait;
	end process;
end;