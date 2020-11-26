USE WORK.Utils.all;

ENTITY TestMulti4 IS END TestMulti4;

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
	
	signal A_nat : NATURAL := 7;
	signal B_nat : NATURAL := 7;
	
	signal inRA: BIT_VECTOR(3 downto 0);
	signal inRB: BIT_VECTOR(3 downto 0);
	signal RES : BIT_VECTOR(7 downto 0);
	
	signal L : NATURAL := 4;

begin 

    UUT: Multi4 port map(STB, CLK, inRA, inRB, DONE, RES);
	
	-- Utilizamos el Package Utils
	inRA <= convert(A_nat,L);
	inRB <= convert(B_nat,L);
	
	clock(CLK, 5ns , 5ns);

    Stimulus: process	
	begin			 
		STB <= '0', '1' after 10ns, '0' after 20ns;
		wait on DONE;
		wait;
	end process;
end;