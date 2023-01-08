----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/26/2022 09:44:46 PM
-- Design Name: 
-- Module Name: VGA - Behavioral
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
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity VGA is

    port(CLK_25MHZ: in std_logic;
         GREEN_S: in std_logic;
         BLUE_S: in std_logic;
         RED_S: in std_logic;
         YELLOW_S: in std_logic;
         VERTICAL_SYNC: out std_logic;      
         HORIZONTAL_SYNC: out std_logic;
         BLUE: out std_logic_vector(3 downto 0);
         GREEN: out std_logic_vector(3 downto 0);
         RED: out std_logic_vector(3 downto 0)
         );
end entity VGA;

architecture Behavioral of VGA is

       constant Horizontal_display_area : integer := 640;
       constant Horizontal_Pulse_width  : integer := 96;
       constant Horizontal_back_porch   : integer := 16;
       constant Horizontal_front_porch  : integer := 48;
       constant TOTAL_HORIZONTAL : integer :=  Horizontal_display_area + Horizontal_Pulse_width + Horizontal_back_porch + Horizontal_front_porch - 1; 
        
       constant Vertical_display_area   : integer := 480;
       constant Vertical_Pulse_width    : integer := 2;
       constant Vertical_back_porch     : integer := 33;
       constant Vertical_front_porch    : integer := 10;
       constant TOTAL_VERTICAL : integer :=  Vertical_display_area + Vertical_Pulse_width + Vertical_back_porch + Vertical_front_porch - 1;

signal HORIZONTAL_COUNTER: unsigned(11 downto 0) := (others=>'0');
signal VERTICAL_COUNTER: unsigned(11 downto 0) := (others=>'0');



begin


process(CLK_25MHZ)
begin
if rising_edge(CLK_25MHZ) then
  if (Horizontal_counter < Total_horizontal) then
    Horizontal_counter <= Horizontal_counter + 1;
    Vertical_counter   <= Vertical_counter;
   
  elsif (Horizontal_counter = Total_horizontal and Vertical_counter < Total_Vertical ) then
    Horizontal_counter <= (others=>'0');
    Vertical_counter   <= Vertical_counter + 1;  
   
   elsif (Horizontal_counter = Total_horizontal and Vertical_counter = Total_Vertical) then
    Horizontal_counter <= (others=>'0');
    Vertical_counter   <= (others=>'0');
   
   else
    Horizontal_counter <= Horizontal_counter;
    Vertical_counter   <= Vertical_counter;
   end if;
 end if;  

end process; 

process(CLK_25MHZ)
begin
if rising_edge(CLK_25MHZ) then
 if (Horizontal_counter >= (Horizontal_Pulse_width + Horizontal_back_porch )and Horizontal_counter < (Horizontal_display_area + Horizontal_Pulse_width + Horizontal_back_porch)
     and (Vertical_counter >= (Vertical_Pulse_width + Vertical_back_porch )and Vertical_counter < (Vertical_display_area +  Vertical_Pulse_width + Vertical_back_porch))) then
  if (Horizontal_counter >=  112 and Horizontal_counter < 432 and Vertical_counter >= 35 and Vertical_counter < 275) then
     if (GREEN_S = '1') then     
      BLUE  <= "0000";  ------ BOX 1 COLOR GREEN
      GREEN <= "1111";
      RED   <= "0000";
     else
      BLUE  <= "0000";  ------ BOX 1 COLOR GREEN
      GREEN <= "1001";
      RED   <= "1001";          
     end if; 
  elsif (Horizontal_counter >=  432 and Horizontal_counter < 752 and Vertical_counter >= 35 and Vertical_counter < 275) then
     if (RED_S = '1') then     
      BLUE  <= "0000";  ----- BOX 2 COLOR RED
      GREEN <= "0000";
      RED   <= "1111";
     else
      BLUE  <= "1001";  ----- BOX 2 COLOR RED
      GREEN <= "0000";
      RED   <= "1000";     
     end if;   
  elsif (Horizontal_counter >=  112 and Horizontal_counter < 432 and Vertical_counter >= 275 and Vertical_counter < 515) then
     if(YELLOW_S = '1') then      
      BLUE  <= "0000";    --- BOX 3 COLOR YELLOW
      GREEN <= "1111";
      RED   <= "1111";
     else
      BLUE  <= "1000";    --- BOX 3 COLOR YELLOW
      GREEN <= "1001";
      RED   <= "0000";       
     end if; 
  else
     if (BLUE_S ='1') then
      BLUE  <= "1111";   ---- BOX 4 COLCOR BLUE
      GREEN <= "0000";
      RED   <= "0000";
     else
      BLUE  <= "1100";   ---- BOX 4 COLCOR BLUE
      GREEN <= "1000";
      RED   <= "1001";     
     end if;  
  end if;
  else
      BLUE  <= "0001";
      GREEN <= "1000";
      RED   <= "0100"; 
  
  
 end if;   
end if;  
end process; 



process(CLK_25MHZ)
begin
if rising_edge(CLK_25MHZ) then
----------------- FOR HSYNC--------------------
 if (Horizontal_counter < Horizontal_Pulse_width) then
  HORIZONTAL_SYNC <= '0';
 else
  HORIZONTAL_SYNC <= '1';
 end if; 
 
  
----------------- FOR VSYNC -------------------
 if (Vertical_counter < Vertical_Pulse_width) then
  VERTICAL_SYNC<= '0';
 else
  VERTICAL_SYNC <= '1';
  end if;   
----------------------------
 end if;  
end process; 
end Behavioral;
