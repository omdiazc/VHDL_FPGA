----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Miguel DIAZ
-- 
-- Create Date: 01/29/2021 09:53:25 PM
-- Design Name: 
-- Module Name: sevenSegment_testBench - Behavioral
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity pwm_testbench is

end;
	
architecture test of pwm_testbench is 
	
component pwm
	port (
    	clk      			: in  std_logic;
    	enable    			: in  std_logic;
    	dutty_cycle 		: in STD_LOGIC_VECTOR (7-1 downto 0);
		pwm					: out std_logic;
    	);
    	
end component;

signal enable           :std_logic :=   '1';
signal clk              :std_logic :=   '1';

signal dutty_cycle    	:std_logic_vector  (7-1 downto 0) = "00000010";
signal pwm 				:std_logic;


--		internal variables

constant c_pwm			: natural := 256;
signal	 r_pwm			: natural := 0;


begin
	
	
	dev_to_test: pwm
		port map ( enable             => enable,
		           clk                => clk,
		           dutty_cycle     	  => dutty_cycle,
		           pwm   			  => pwm);
	
	clk_stimulus:	process
	
	begin
		
		wait for 5 ns;
		clk <= not clk;
		
	end process clk_stimulus;
	
		
		
	data_stimulus:	process
	begin
		
		wait for 10ms;
		
		if r_pwm = c_pwm -1 then
			
			r_pwm <= 0;

		else
			
			r_pwm <= r_pwm + 1;

		end if;
	
	end process data_stimulus;
		
		
		
	

end test;