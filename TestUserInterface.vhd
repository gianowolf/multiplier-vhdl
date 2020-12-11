USE std.textio.all;
USE WORK.Utils.all;

ENTITY TestUserInterface IS
END TestUserInterface;	  

ARCHITECTURE prueba of TestUserInterface IS 			 

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
	
	constant header:     String := "---- VHDL 4-Bit Multiplier ----"; 
	constant msg_op1:    String := "Ingrese Multiplicando 0 a 15";
	constant msg_op2:    String := "Ingrese Multiplicador 0 a 15"; 
	constant msg_err_in: String := "Valores ingresados incorrectos";
	constant msg_err_in2:String := "Ingrese un entero entre 0 y 15"; 
	constant msg_start:  String := "Iniciando multiplicador...";
	constant msg_menu:   String := "Desea realizar otra operación?";  
	constant msg_menu2:  String := "1. Si  \ 2. No";
	constant msg_time:   String := "Tiempo (ns): ";
	
	SIGNAL  QUIT_L1, QUIT_L2, QUIT_MENU: BOOLEAN; 
	SIGNAL  sig_op1, sig_op2, selected_menu: INTEGER;
	
	SIGNAL STB : BIT:='0';
	SIGNAL CLK : BIT;
	SIGNAL DONE: BIT;
	
	SIGNAL MIN : integer;
	SIGNAL MAX : integer;
	SIGNAL AVG : integer;
	signal LAST: integer;
	
	SIGNAL T_MIN: TIME;
	SIGNAL T_MAX: TIME;
	SIGNAL T_AVG: TIME;	 
	SIGNAL T_LAST:TIME;
	
	signal inRA: BIT_VECTOR(3 downto 0);
	signal inRB: BIT_VECTOR(3 downto 0);
	signal RES : BIT_VECTOR(7 downto 0);
	
	signal L : integer := 4;  
	signal Operando1: integer;
	signal Operando2: integer;
	signal Producto : integer;
	
BEGIN						   
	
	UUT: Multi4 port map(STB, CLK, inRA, inRB, DONE, RES);
	TIM: Timer port map(STB, CLK, DONE, MIN, MAX, AVG, LAST);
	
	clock(CLK, 10ns , 10ns);
	
	p1: PROCESS			
    variable linea: line;
	variable v_op1, v_op2, v_opt_menu : integer;
	variable dummy : side;		 
	variable v_good1, v_good2, v_good_menu: boolean;	
	
	BEGIN				
		L1: LOOP --Main Program	
								
		wait for 10ns;
		--iniciamos señales en valores seguros
		QUIT_L1 <= false;
		QUIT_L2 <= false;
		QUIT_MENU <= false;
		SIG_OP1 <= -1;
		SIG_OP2 <= -1;
		SELECTED_MENU <= -1;
		wait for 10ns;
		
			L2: LOOP -- Corrobora que el input ingresado por el usuario sea correcto
				
				--Reading Op 1
				write(linea, msg_op1);writeline(output,linea);
				wait for 20ns;
				readline(input,linea);read(linea, v_op1, v_good1);
			    wait for 20ns;							  
							
				sig_op1 <= v_op1;
				wait for 20ns;
				
				--Reading Op 2 
				write(linea, msg_op2);writeline(output,linea);
				wait for 20ns;
				readline(input,linea);read(linea, v_op2, v_good2);
			    wait for 20ns;
				
				sig_op2 <= v_op2;
				wait for 20ns;
				
				-- Si los operandos ingresados son enteros entre 0 y 15 salimos del loop L2
				QUIT_L2 <= v_good1 and v_good2 and (0 < v_op1) and (v_op1 < 16) and (0 < v_op1) and (v_op1 < 16);
				wait for 20ns;-------------------------------------------------------------
				
				exit L2 when QUIT_L2;
				wait for 20ns;-------------------------------------------------------------
				
				write(linea, msg_err_in);writeline(output,linea);
				write(linea, msg_err_in2);writeline(output,linea);
				wait for 20ns;-------------------------------------------------------------
			END LOOP L2;
			-----------------------------------------------------------------------------
			--          COMIENZO ESPACIO DE TRABAJO DEL MULTIPLICADOR			       --
			-----------------------------------------------------------------------------
			write(linea, msg_start);writeline(output,linea);
			
			inRA <= convert(v_op1,L);	 
			inRB <= convert(v_op2,L);
			wait for 20ns;
			
			STB <= '1';	 
			Operando1 <= v_op1;	--facilitar lectura waveform	 
			Operando2 <= v_op2;	--facilitar lectura waveform 
			
			wait until DONE'EVENT and DONE='1';														 										
			Producto <= convert(RES); -- facilitar lectura waveform	
			
			wait for 20ns;
			write(linea, msg_time);writeline(output,linea);	
			write(linea, LAST*20);writeline(output,linea);	

			-----------------------------------------------------------------------------
			--				FIN DE ESPACIO DE TRABAJO DEL MULTIPLICADOR			       --
			-----------------------------------------------------------------------------
			MENU: LOOP		
				write(linea, msg_menu);writeline(output,linea);
				write(linea, msg_menu2);writeline(output,linea);
				wait for 20 ns;
				readline(input,linea);read(linea, v_opt_menu, v_good_menu);
				wait for 10ns;-------------------------------------------------------------90
				
				if(v_good_menu) then
					SELECTED_MENU <= v_opt_menu;
				end if;
				wait for 10ns;

				if(SELECTED_MENU=2) THEN
					EXIT L1;
				elsif (SELECTED_MENU=1) then
					EXIT MENU;
				end if;
				wait for 10ns; 
				
			END LOOP MENU;	
		END LOOP L1;
		wait;
	END PROCESS;
END PRUEBA;