----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/31/2020 12:49:40 PM
-- Design Name: 
-- Module Name: button_led - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity button_led is
 Generic (
    NUM_BUTTONS : integer := 15);

 
 Port (
        led     :   out std_logic_vector(NUM_BUTTONS - 1 downto 0);
        sw   :   in  std_logic_vector(NUM_BUTTONS - 1 downto 0);
        Enable      :   in  std_logic);
        
end button_led;

architecture Behavioral of button_led is

begin

-- set the output of the LED's
    
    led <= sw when Enable = '0' else (others  => '0');
    

end Behavioral;
