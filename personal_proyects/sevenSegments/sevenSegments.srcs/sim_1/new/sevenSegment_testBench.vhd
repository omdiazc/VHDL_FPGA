----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Miguel DIAZ
-- 
-- Create Date: 01/28/2021 03:53:25 PM
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

entity sevensegment_testbench is

end;
	
architecture test of sevensegment_testbench is 
	
component sevensegments
	port (
		reset                : in  std_logic;
		clk                  : in  std_logic;
        segment_drive        : out STD_LOGIC_VECTOR (7-1 downto 0);
		segment_selector	 : out STD_LOGIC_VECTOR (4-1 downto 0)
    	);
    	
end component;

signal reset            :std_logic :=   '0';
signal clk              :std_logic :=   '1';

signal segment_drive    :std_logic_vector   (7-1 downto 0);
signal segment_selector :STD_LOGIC_VECTOR   (4-1 downto 0);



begin
	
	dev_to_test: sevensegments
		port map ( reset              => reset,
		           clk                => clk,
		           segment_drive      => segment_drive,
		           segment_selector   => segment_selector);
	
	clk_stimulus:	process
	
	begin
		wait for 5 ns;
		clk <= not clk;
	end process clk_stimulus;
	
	

end test;