----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2022 12:56:43 AM
-- Design Name: 
-- Module Name: Edge_Detector - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
library xil_defaultlib;
use xil_defaultlib.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Edge_Detector is
  Port ( CLK_25MHZ: in std_logic;
         BUTTON_IN: in std_logic;
         PULSE: out std_logic
         );
end Edge_Detector;

architecture Behavioral of Edge_Detector is
signal counter: unsigned(19 downto 0):= (others=>'0');
signal D0,D1,D2: std_logic;

begin
PULSE <= D1 and (not D2);


process(CLK_25MHZ)
begin
if rising_edge(CLK_25MHZ) then
   if (counter < 1000000) then
 --     if (counter < 100) then
    counter <= counter + 1;
    D0 <= D0;
   else
    counter <= (others=>'0');
    D0 <= BUTTON_IN;
   end if;
 end if;
end process; 

process(CLK_25MHZ) 
begin
if rising_edge(CLK_25MHZ) then
D1 <= D0;
D2 <= D1;
end if;
end process;

end Behavioral;
