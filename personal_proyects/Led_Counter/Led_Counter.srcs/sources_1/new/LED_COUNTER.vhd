----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Miguel Diaz
-- 
-- Create Date: 01/17/2021 03:12:46 PM
-- Design Name: 
-- Module Name: LED_COUNTER - Behavioral
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
 
entity tutorial_led_blink is
  port (
    i_clock      : in  std_logic;
    i_enable     : in  std_logic;
    i_switch_1   : in  std_logic;
    i_switch_2   : in  std_logic;
    o_led_drive  : out STD_LOGIC_VECTOR (16-1 downto 0)
    );
end tutorial_led_blink;
 
architecture rtl of tutorial_led_blink is
 
  -- Constants to create the frequencies needed:
  -- Formula is: (100 MHz / 100 Hz * 50% duty cycle)
  -- So for 100 Hz: 100,000,000 / 100 * 0.5 = 500 000
  constant c_CNT_100HZ 	: natural := 500000;
  constant c_CNT_50HZ  	: natural := 1000000;
  constant c_CNT_10HZ  	: natural := 5000000;
  constant c_CNT_1HZ   	: natural := 50000000;
  constant max_value	: natural := 65536;
 
 
  -- These signals will be the counters:
  	signal r_CNT_100HZ 	: natural range 0 to c_CNT_100HZ;
	signal r_CNT_50HZ  	: natural range 0 to c_CNT_50HZ;
	signal r_CNT_10HZ  	: natural range 0 to c_CNT_10HZ;
	signal r_CNT_1HZ   	: natural range 0 to c_CNT_1HZ;
	signal led_counter	: natural range 0 to max_value;

   
  -- These signals will toggle at the frequencies needed:
  signal r_TOGGLE_100HZ : std_logic := '0';
  signal r_TOGGLE_50HZ  : std_logic := '0';
  signal r_TOGGLE_10HZ  : std_logic := '0';
  signal r_TOGGLE_1HZ   : std_logic := '0';
 
  -- One bit select wire.
  signal led_pulse : std_logic;
   
begin
 
  -- All processes toggle a specific signal at a different frequency.
  -- They all run continuously even if the switches are
  -- not selecting their particular output.
   
  p_100_HZ : process (i_clock) is
  begin
    if rising_edge(i_clock) then
      if r_CNT_100HZ = c_CNT_100HZ-1 then  -- -1, since counter starts at 0
        r_TOGGLE_100HZ <= not r_TOGGLE_100HZ;
        r_CNT_100HZ    <= 0;
      else
        r_CNT_100HZ <= r_CNT_100HZ + 1;
      end if;
    end if;
  end process p_100_HZ;
 
 
  p_50_HZ : process (i_clock) is
  begin
    if rising_edge(i_clock) then
      if r_CNT_50HZ = c_CNT_50HZ-1 then  -- -1, since counter starts at 0
        r_TOGGLE_50HZ <= not r_TOGGLE_50HZ;
        r_CNT_50HZ    <= 0;
      else
        r_CNT_50HZ <= r_CNT_50HZ + 1;
      end if;
    end if;
  end process p_50_HZ;
 
   
  p_10_HZ : process (i_clock) is
  begin
    if rising_edge(i_clock) then
      if r_CNT_10HZ = c_CNT_10HZ-1 then  -- -1, since counter starts at 0
        r_TOGGLE_10HZ <= not r_TOGGLE_10HZ;
        r_CNT_10HZ    <= 0;
      else
        r_CNT_10HZ <= r_CNT_10HZ + 1;
      end if;
    end if;
  end process p_10_HZ;
 
   
  p_1_HZ : process (i_clock) is
  begin
    if rising_edge(i_clock) then
      if r_CNT_1HZ = c_CNT_1HZ-1 then  -- -1, since counter starts at 0
        r_TOGGLE_1HZ <= not r_TOGGLE_1HZ;
        r_CNT_1HZ    <= 0;
      else
        r_CNT_1HZ <= r_CNT_1HZ + 1;
      end if;
    end if;
  end process p_1_HZ;
 
   
  -- Create a multiplexor based on switch inputs
  led_pulse <= r_TOGGLE_100HZ when (i_switch_1 = '0' and i_switch_2 = '0') else
                  r_TOGGLE_50HZ  when (i_switch_1 = '0' and i_switch_2 = '1') else
                  r_TOGGLE_10HZ  when (i_switch_1 = '1' and i_switch_2 = '0') else
                  r_TOGGLE_1HZ;
 
   
					  
	  led_plusone : process (led_pulse) is
  begin
    if rising_edge(led_pulse) then
      if led_counter = max_value-1 then  -- -1, since counter starts at 0
        led_counter    <= 0;
      else
        led_counter <= led_counter + 1;
      end if;
		
		
    end if;
  end process led_plusone;
		
		
					  
  -- Only allow o_led_drive to drive when i_enable is high (and gate).
  o_led_drive <= std_logic_vector(to_unsigned(led_counter, 16)) ;
 
end rtl;