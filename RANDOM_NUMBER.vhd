----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2022 10:47:14 PM
-- Design Name: 
-- Module Name: RANDOM_NUMBER - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
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

entity RANDOM_NUMBER is
    port(CLK_25MHZ: in std_logic;
         GREEN: out std_logic;
         YELLOW: out std_logic;
         RED: out std_logic;
         BLUE: out std_logic
         
         );
end RANDOM_NUMBER;

architecture Behavioral of RANDOM_NUMBER is


signal D0, D1, D2: std_logic;
signal Q5, Q4, Q3 ,Q2 ,Q1: std_logic;
signal RANDOM_NUMBER: std_logic_vector(4 downto 0);
signal NUMBER: integer range 0 to 30;


type STATES is (IDEAL , WORK);
	signal STATE: STATES;
begin
--------------------------------------------------
--------------------------------------------------
D0 <= Q5 xnor Q3;
D1 <= Q5 and Q4 and Q3 and Q2 and Q1;
D2 <= D0 xor D1;
RANDOM_NUMBER <= Q5 & Q4 & Q3 & Q2 & Q1;
NUMBER <= CONV_INTEGER (RANDOM_NUMBER);
--------------------------------------------------
--------------------------------------------------

--------------------------------------------------
--------------------------------------------------

GREEN <= '1' when (NUMBER = 0) or (NUMBER = 14)or (NUMBER = 4)or (NUMBER = 5)or (NUMBER = 23)
                  or (NUMBER = 13) or (NUMBER = 20) or (NUMBER = 16)
         else '0';
 
RED <= '1' when (NUMBER = 1) or (NUMBER = 28)or (NUMBER = 8)or (NUMBER = 29)or (NUMBER = 15)
                  or (NUMBER = 26) or (NUMBER = 9) or (NUMBER = 24)
         else '0';  
         
YELLOW <= '1' when (NUMBER = 3) or (NUMBER = 25)or (NUMBER = 17)or (NUMBER = 21)or (NUMBER = 30)
                  or (NUMBER = 27) or (NUMBER = 19) or (NUMBER = 12)
         else '0';
        
BLUE <= '1' when (NUMBER = 7) or (NUMBER = 18)or (NUMBER = 2)or (NUMBER = 11)or (NUMBER = 10)
                  or (NUMBER = 22) or (NUMBER = 6)
         else '0';         
                           
--------------------------------------------------
--------------------------------------------------


process(CLK_25MHZ)
begin
if rising_edge(CLK_25MHZ) then
     case STATE is	 
	  when IDEAL => 
          Q1 <= '0';
          Q2 <= '0';
          Q3 <= '0';
          Q4 <= '0';
          Q5 <= '0';
          STATE <= WORK;
      when WORK =>
          Q1 <= D2;
          Q2 <= Q1;
          Q3 <= Q2;
          Q4 <= Q3;
          Q5 <= Q4;
          STATE <= WORK;      
  	end case;         
 end if;  

end process; 

end Behavioral;
