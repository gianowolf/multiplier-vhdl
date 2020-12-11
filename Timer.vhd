ENTITY Timer is 
	port(
		STB, CLK, DONE: in BIT;
		MIN, MAX, AVG, LAST: out integer
	);							  
END Timer;

Architecture Medidor of Timer is 

	signal current_ticks:integer := 0;
	signal total_ticks : integer := 0;
	signal total_dones : integer := -1;
	signal min_ticks   : integer := 999;
	signal max_ticks   : integer := 0;
	signal avg_ticks   : integer;
	
begin
	
	process(STB, CLK, DONE) is 
	begin		
		
		if CLK'Event and CLK = '0' then 
			total_ticks <= total_ticks + 1;	
			current_ticks <= current_ticks + 1;
		end if;	
		
		if DONE'event AND DONE = '1' then 
		LAST <= current_ticks;
			if (current_ticks < min_ticks) and (current_ticks > 0) then 
				min_ticks <= current_ticks;
			end if;
			if current_ticks > max_ticks then 
				max_ticks <= current_ticks;	
			end if;
		end if;
		
		if DONE'event AND DONE = '0' then
			total_dones <=  total_dones + 1;
			current_ticks <= 0;
		end if;	
				 
		 
		MIN <= min_ticks; 
		MAX <= max_ticks; 
		if total_dones > 1 then
			AVG <= total_ticks / total_dones;
		end if;

	end process;
	
end architecture;