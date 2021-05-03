

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity sevensegments is
	port (
    	clk      			: in  std_logic;
    	reset    			: in  std_logic;
    	segment_drive  		: out STD_LOGIC_VECTOR (7-1 downto 0)
		segment_selector	: out STD_LOGIC_VECTOR (4-1 downto 0)
    	);
end sevensegments;
 
architecture rtl of sevensegments is
 
  -- Constants to create the frequencies needed:
  -- Formula is: (25 MHz / 100 Hz * 50% duty cycle)sevensegments	
  -- So for 100 Hz: 25,000,000 / 100 * 0.5 = 125,000
	
  constant c_CNT_1000HZ : natural := 50000;
  constant c_CNT_1HZ   	: natural := 50000000;
  constant c_16ms   	: natural := 16;
  constant max_value	: natural := 9999;
 
 
  -- These signals will be the counters:
  	signal r_CNT_1000HZ 					: natural range 0 to c_CNT_1000HZ;
	signal r_CNT_1HZ   						: natural range 0 to c_CNT_1HZ;
	signal r_16ms							: natural range 0 to c_16ms;
	signal seven_segment_number				: natural range 0 to max_value;
	signal seven_segment_out_num			: STD_LOGIC_VECTOR (7-1 downto 0) := '0000000';
	signal seven_segment_out_single			: natural:=0;
	signal seven_segment_enabled			: STD_LOGIC_VECTOR (4-1 downto 0) := '1111';
	signal seven_segments_enabled_natural 	: natural = 0;
	signal write 							: std_logic	:=0;
	signal sleep							: std_logic :=1;
	

   
  -- These signals will toggle at the frequencies needed:
	signal r_TOGGLE_1000HZ 	: std_logic 	:= '0';
  	signal r_TOGGLE_1HZ   	: std_logic 	:= '0';
 
  -- One bit select wire.
  signal pulse : std_logic;
   
begin
 
  -- All processes toggle a specific signal at a different frequency.
  -- They all run continuously even if the switches are
  -- not selecting their particular output.
   
	
	--- Clocks
	
	
	
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
			
			
			
	sleep_16ms : process (r_TOGGLE_1000HZ) is --- 16ms clock
  	begin
		
    	if rising_edge(r_TOGGLE_1000HZ) then
			
      		if r_16ms = c_16ms-1 then  -- -1, since counter starts at 0
				
        		sleep 	<= 1;
        		r_16ms  <= 0;
		
      		else
				
        		r_16ms 	<= r_16ms + 1;
		
      		end if;
				
    	end if;
			
  end process sleep_16ms;
 
			
			
			
   
  -- Create a multiplexor based on switch inputs
  pulse <= r_TOGGLE_1HZ;
				
				
				
				
				
				
				
 
case seven_segment_out_single is
  	
	when 0 		=>  seven_segment_out_num 	<= '0000001';
  	when 1		=>  seven_segment_out_num 	<= '1001111';
  	when 2		=>  seven_segment_out_num	<= '0010010';
  	when 3		=>  seven_segment_out_num 	<= '0000110';
	when 4		=>  seven_segment_out_num	<= '1001100';
  	when 5		=>  seven_segment_out_num	<= '1001100';
  	when 6		=>  seven_segment_out_num	<= '0100000';
  	when 7		=>  seven_segment_out_num	<= '0001111';
  	when 8		=>  seven_segment_out_num	<= '0000000';
	when 9		=>  seven_segment_out_num	<= '0000100';
	when others	=>  seven_segment_out_num 	<= '0000001';
		  
	
end case;
	
case seven_segments_enabled_natural is
  	
	when 0 		=>  seven_segment_enabled 	<= '0111';
  	when 1		=>  seven_segment_enabled 	<= '1011';
  	when 2		=>  seven_segment_enabled	<= '1101';
  	when 3		=>  seven_segment_enabled 	<= '1110';
	when others	=>  seven_segment_enabled 	<= '1111';
		  
	
end case;	
	
	
	first_seven_segment : process (write) is
  	begin
    	if rising_edge(write) then
			if sleep = 1 then
				seven_segment_out_single 		<=  seven_segment_number mod 10;
				seven_segments_enabled_natural 	<=	0;
				sleep 							<= 0;
			end if;
			
      
    	end if;
  	end process first_seven_segment;
	
			
			
	second_seven_segment : process (sleep) is
  	begin
    	if rising_edge(sleep) then
			
			if seven_segments_enabled_natural = 0 then
				
				seven_segment_out_single 		<=  (seven_segment_number mod 100)/10;
				seven_segments_enabled_natural 	<=	1;
				sleep <= 0;
		
			elsif seven_segments_enabled_natural = 1 then
				
				seven_segment_out_single 		<=  (seven_segment_number mod 1000)/100;
				seven_segments_enabled_natural 	<=	2;
				sleep <= 0;
			elsif seven_segments_enabled_natural = 2 then
				
				seven_segment_out_single 		<=  seven_segment_number /1000;
				seven_segments_enabled_natural 	<=	3;
				sleep <= 0;
				write <= 0;

			end if;
			
      
    	end if;
  	end process second_seven_segment;
			

	
   
					  
	value_plusone : process (pulse) is
  	begin
		
    	if rising_edge(pulse) then
			
      		if seven_segment_number = max_value-1 then  -- -1, since counter starts at 0
				
        		seven_segment_number    <= 0;
				write <= 1;

			
      		else
				
        		seven_segment_number <= seven_segment_number + 1;
				write <= 1;

			
      		end if;		
		
    	end if;
  	end process value_plusone;
		
		
					  
  -- Only allow o_led_drive to drive when i_enable is high (and gate).
	segment_drive 		<= seven_segment_out_num;
	segment_selector	<= seven_segment_enabled;
 
end rtl;