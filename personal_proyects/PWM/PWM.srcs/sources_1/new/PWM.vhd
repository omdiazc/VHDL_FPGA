----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Miguel DIAZ
-- 
-- Create Date: 01/29/2021 03:04:57 PM
-- Design Name: 
-- Module Name: pwm - Behavioral
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
 
entity pwm is
	port (
    	clk      		    : in  std_logic;
    	enable    			: in  std_logic;
    	dutty_cycle 		: in STD_LOGIC_VECTOR (8-1 downto 0);
		pwm_signal			: out std_logic
    	);
end pwm;
 
architecture rtl of pwm is
	
	
	constant c_CNT_10000HZ 	: natural := 5000;
	constant c_PWM			: natural := 256;
	


	signal r_CNT_10000HZ 	: natural range 0 to c_CNT_10000HZ;
	signal r_TOGGLE_10000HZ  : std_logic :='0';
	signal r_PWM			: natural range 0 to 255 := 0; 
 

begin



	p_10000_HZ : process (clk) is	--- 10000HZ clock
  	begin
    	if rising_edge(clk) then
			
      		if r_CNT_10000HZ = c_CNT_10000HZ-1 then  -- -1, since counter starts at 0
				
        		r_TOGGLE_10000HZ <= not r_TOGGLE_10000HZ;
        		r_CNT_10000HZ    <= 0;

      		else
				
        		r_CNT_10000HZ <= r_CNT_10000HZ + 1;
        		
		
      		end if;
				
   		end if;
			
	end process p_10000_HZ;
			
			

	pwm_process : process (r_TOGGLE_10000HZ, dutty_cycle, enable) is
	begin
		
		if rising_edge(r_TOGGLE_10000HZ) then
			
			if r_PWM>=to_integer(unsigned(dutty_cycle)) then 
				
				pwm_signal <= '0';
			
			else 
				
				pwm_signal <= '1';
				
			end if;
			
			 if r_PWM = c_PWM-1 then  -- -1, since counter starts at 0
				
        		r_PWM    <= 0;

      		else
				
        		r_PWM <= r_PWM + 1;
        		
		
      		end if;
			
		end if;
				
	end process pwm_process;
			
			
	
end rtl;