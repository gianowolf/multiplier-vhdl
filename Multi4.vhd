
ENTITY Multi4 is
    PORT( 
		STB : IN  BIT;
		CLK : IN  BIT;
		inRA: IN  BIT_VECTOR(3 downto 0);
		inRB: IN  BIT_VECTOR(3 downto 0);
		DONE: OUT BIT;
		RES : OUT BIT_VECTOR(7 downto 0)
    );				
end Multi4;

ARCHITECTURE Structural of Multi4 is	   

	component ShiftN
	  port(
		CLK, CLR, LD, SH, DIR: IN  BIT;
		D                    : IN  BIT_VECTOR;
		Q                    : OUT BIT_VECTOR
	  );
	end component;	
	
	component Latch8
	  port(
		CLK, PRE, CLR: IN  BIT;
		D            : IN  BIT_VECTOR(7 downto 0); 
		Q            : OUT BIT_VECTOR(7 downto 0)
	  );
	end component;	
	
	component Controller
	  port(
        STB, CLK, LSB, STOP   : IN  BIT;
        INIT, SHIFT, ADD, DONE: OUT BIT
      );
	end component;	
	
	component Adder8
	  port(	 
	    A, B: IN  BIT_VECTOR(7 downto 0);
	    Cin : IN  BIT;
		Cout: OUT BIT;
		SUM : OUT BIT_VECTOR(7 downto 0)
	  );
	end component;
	
	SIGNAL INIT,  SHIFT, ADD, STOP, LSB: BIT;
	SIGNAL outRA, outRB, SUM, outACC: BIT_VECTOR(7 downto 0);	  
	SIGNAL Cout: BIT;
	SIGNAL inACC, inR: BIT_VECTOR(7 downto 0);
	
begin 

	RA   : ShiftN     port map(CLK, '0', INIT, SHIFT, '0', inRA, outRA);
	RB   : ShiftN     port map(CLK, '0', INIT, SHIFT, '1', inRB, outRB);  
	SM   : Controller port map(STB, CLK, LSB, STOP, INIT, SHIFT, ADD, DONE);
	ADDER: Adder8     port map(outRB, outACC, '0', Cout, SUM);
	ACC  : Latch8     port map(CLK, '1', '1', inACC, outACC);
	Rout : Latch8     port map(CLK, '1', '1', inR, RES);
	
    -- Esta linea podria obviarse y pasar outRA(0) al port map del SM : Controller
	-- Se utiliza para respetar el formato del multiplicado brindado por la catedra y facilitar su lectura
	LSB <= outRA(0);
	
	-- NOR entre los bits del registro A.
	-- Cuando todos los bits de A son 0, se avanza al STATE: STOP.
	STOP <= not(outRA(7) or outRA(6) or outRA(5) or outRA(4)  or outRA(3) or outRA(2) or outRA(1) or outRA(0));
	
	-- Funciona como señal de LOAD para el Latch que recibe el resultado de la suma
	inACC <= SUM when ADD'event and ADD='1';			 
	
	-- Funciona como señal de LOAD para el Latch Y. carga el resultado cuando se ha finalizado la operacion
	inR <= outACC when STOP'event and STOP='1';
	
end;