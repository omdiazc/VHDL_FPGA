----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Miguel DIAZ
-- 
-- Create Date: 01/29/2021 03:04:57 PM
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
    	clk      		: in  std_logic;
    	enable    			: in  std_logic;
    	dutty_cycle 		: in STD_LOGIC_VECTOR (7-1 downto 0);
		pwm					: out std_logic
    	);
end sevensegments;
 
architecture rtl of sevensegments is
	
	
	constant c_CNT_1000HZ 	: natural := 50000;
	constant c_PWM			: natural := 256;
	


	signal r_CNT_1000HZ 	: natural range 0 to c_CNT_1000HZ;
	signal r_TOGGLE_1000HZ  : std_logic :='0';
	signal r_PWM			: natural range 0 to 255 := 0; 
 

begin



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
			
			

	pwm_process : process (r_TOGGLE_1000HZ, dutty_cycle, enable) is
	begin
		
		if rising_edge(r_TOGGLE_1000HZ) and enable then
			
			if r_PWM>=to_integer(unsigned(dutty_cycle)) then 
				
				pwm <= '0';
			
			else 
				
				pwm <= '1';
				
			end if;
			
			 if r_PWM = c_PWM-1 then  -- -1, since counter starts at 0
				
        		r_PWM    <= 0;

      		else
				
        		r_PWM <= r_PWM + 1;
        		
		
      		end if;
			
		end if;
				
	end process pwm_process;
			
			
	
end rtl;