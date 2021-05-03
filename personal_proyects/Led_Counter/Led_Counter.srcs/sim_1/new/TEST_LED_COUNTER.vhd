----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/17/2021 03:52:38 PM
-- Design Name: 
-- Module Name: TEST_LED_COUNTER - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TEST_LED_COUNTER is

end;

architecture test of test_led_counter is 

component LED_COUNTER

    Port ( Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Led_Out : out STD_LOGIC_VECTOR (15 downto 0));

end component;

signal  Clk     :std_logic :=  '0';   
signal  Reset   :std_logic :=  '1';
signal  Led_Out :std_logic_vector(15 downto 0);

begin

    dev_to_test: LED_COUNTER
        port map (CLk, Reset, Led_Out);
        
    
    clk_stimulus:   process
    
    begin
    
        wait for 1 ns;
        Clk <= not Clk;
    
    end process clk_stimulus; 
   

end test;
   

