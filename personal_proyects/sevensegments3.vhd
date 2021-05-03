----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Miguel DIAZ
-- 
-- Create Date: 01/28/2021 03:04:57 PM
-- Design Name: 
-- Module Name: sevenSegments - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity sevensegments is
	port (
    	clk      			: in  std_logic;
    	reset    			: in  std_logic;
    	segment_drive  		: out STD_LOGIC_VECTOR (7-1 downto 0);
		segment_selector	: out STD_LOGIC_VECTOR (4-1 downto 0)
    	);
end sevensegments;
 
architecture rtl of sevensegments is
	
	
	-- Constants
	
	constant c_CNT_1000HZ 	: natural := 50000;
	constant c_CNT_1HZ   	: natural := 50000000;
	constant c_16ms   		: natural := 16;
	constant max_value		: natural := 9999;


	-- Clock signals

	signal r_CNT_1000HZ 	: natural range 0 to c_CNT_1000HZ;
	signal r_CNT_1HZ   		: natural range 0 to c_CNT_1HZ;
	signal r_16ms			: natural range 0 to c_16ms;

	signal r_TOGGLE_1000HZ 	: std_logic 	:= '0';
  	signal r_TOGGLE_1HZ   	: std_logic 	:= '0';

	
	-- Variables
	
	
	signal counter			: natural range 0 to max_value 	:= 0;
	signal digit			: natural range 0 to 9 			:= 0;
	signal segment			: natural range 0 to 4			:= 4;
	signal start			: std_logic :='0';
	signal sleep			: std_logic :='0';
	signal write            : std_logic :='0';
	


begin

	-- Clocks


	p_1000_HZ : process (clk) is	--- 1000Hz clock
  	begin
    	if rising_edge(clk) then
			
      		if r_CNT_1000HZ = c_CNT_1000HZ-1 then  -- -1, since counter starts at 0
				
        		r_TOGGLE_1000HZ <= not r_TOGGLE_1000HZ;
        		r_CNT_1000HZ    <= 0;
		         

      		else
				
        		r_CNT_1000HZ <= r_CNT_1000HZ + 1;
        		
		
      		end if;
				
   		end if;
			
	end process p_1000_HZ;


	p_1_HZ : process (clk) is --- 1Hz clock
 	begin
	  
    	if rising_edge(clk) then
			
      		if r_CNT_1HZ = c_CNT_1HZ-1 then  -- -1, since counter starts at 0
				
        		r_TOGGLE_1HZ <= not r_TOGGLE_1HZ;
        		r_CNT_1HZ    <= 0;
		
      		else
				
        		r_CNT_1HZ <= r_CNT_1HZ + 1;
		
      		end if;
				
    	end if;
			
  	end process p_1_HZ;
			
	
			
	sleep_16ms : process (r_TOGGLE_1000HZ, sleep) is --- 16ms clock
  	begin
		
    	if rising_edge(r_TOGGLE_1000HZ) then
			
      		if r_16ms = c_16ms-1 then  -- -1, since counter starts at 0
				
        		r_16ms  <= 0;        		

      		else
				
				if sleep = '0' then
					
					r_16ms 	<= r_16ms + 1;      
					
				end if;
		
      		end if;      		
				
    	end if;
			
  	end process sleep_16ms;
	
			
	
	-- Outputs
			
	segment_drive <=    "0000001" when (digit = 0) else
                    	"1001111" when (digit = 1) else
                      	"0010010" when (digit = 2) else
                       	"0000110" when (digit = 3) else
                        "1001100" when (digit = 4) else
                        "0100110" when (digit = 5) else
                        "0100000" when (digit = 6) else
                        "0001111" when (digit = 7) else
                        "0000000" when (digit = 8) else
                        "0000100" when (digit = 9) else
                        "0000001";
                            
                            
				
	segment_selector <= "0111" when    (segment = 0) else
                       	"1011" when    (segment = 1) else
                        "1101" when    (segment = 2) else
                        "1110" when    (segment = 3) else
                        "1111";
							
							
							
							
	seven_segment : process (write, start, reset, sleep, r_TOGGLE_1HZ, segment) is
  	begin
		
		if reset = '0' then
			
			if rising_edge(write) or start = '0' then
				
				digit 		<=  counter mod 10;
				segment 	<=  0;
				start 		<= '1';
				sleep		<= '0';
				
			elsif rising_edge(sleep) then 
				
				if segment = 0 then
					
					segment <= 1;
					digit 	<= (counter mod 100)/10;
					sleep	<= '0';					
							
				elsif segment = 1 then
					
					segment <= 2;
					digit 	<= (counter mod 1000)/100;
					sleep	<= '0';

					
				elsif segment = 2 then
					
					segment <= 3;
					digit 	<= counter/1000;
					sleep	<= '0';

				else 
					
					segment <= 4;
					write 	<='0';
					
				end if;
					
			elsif r_16ms = c_16ms-1 then
				
				sleep <= '1';
			
			elsif rising_edge(r_TOGGLE_1HZ) then
				
				write <='1';
					
			end if;
				
			
		else
			
			-- reset todo;
			
		end if;
		
		
	
  	end process seven_segment;
							
							
							
							
							
							
                        		
				
	
	
	
	
	
end rtl;