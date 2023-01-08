----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2022 01:46:18 AM
-- Design Name: 
-- Module Name: GAME - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GAME is
    Port ( G_BUTTON : in STD_LOGIC;
           R_BUTTON : in STD_LOGIC;
           Y_BUTTON : in STD_LOGIC;
           B_BUTTON : in STD_LOGIC;
           START    : in STD_LOGIC;
           G_SIGNAL : in STD_LOGIC;
           R_SIGNAL : in STD_LOGIC;
           Y_SIGNAL : in STD_LOGIC;
           B_SIGNAL : in STD_LOGIC;
           GREEN_S : out STD_LOGIC;
           RED_S : out STD_LOGIC;
           YELLOW_S : out STD_LOGIC;
           BLUE_S : out STD_LOGIC;
           START_IDEAL: out STD_LOGIC;
           CLK25MHZ : in STD_LOGIC);
end GAME;

architecture Behavioral of GAME is

constant TIME_VALUE : integer := 50000000;  --------- 2SEC
--constant TIME_VALUE : integer := 1250;  --------- 0.5SEC
signal GREEN, RED , YELLOW , BLUE : std_logic;
signal WAIT_0_5_SEC: unsigned(26 downto 0) := (others=>'0');
signal SAVE_SEQUENCE_COLOR: unsigned(179 downto 0) := (others=>'0');
signal SAVE_SEQUENCE_BUTTON: unsigned(179 downto 0) := (others=>'0');
signal LEVEL_CHECK: unsigned(5 downto 0) := (others=>'0');
signal CHECK_COUNTER: unsigned(5 downto 0) := (others=>'0');
type SIMON_STATES is (IDEAL , DELAY, SHOW_COLOR , COLOR_SAVE_SEQUENCE , BUTTONS , CHECK_LEVEL , LEVEL);
	signal SIMON_STATE: SIMON_STATES;
begin
GREEN_S  <= GREEN;
RED_S    <= RED;
YELLOW_S <= YELLOW;
BLUE_S   <= BLUE;	  	  
---------------------------------------------------------------------------------------------    
---------------------------------------------------------------------------------------------  
------------------------- STATE MACHINE -----------------------------------------------------
---------------------------------------------------------------------------------------------
process (CLK25MHz)
  begin
   if rising_edge(CLK25MHz) then  
    case SIMON_STATE is
-------------WAIT FOR THE START SIGNAL---------------------------------------
	 
	  when IDEAL => 
	      GREEN  <= '0';
	      RED    <= '0';
	      YELLOW <= '0';
	      BLUE   <= '0';
	      START_IDEAL <= '1';
	      LEVEL_CHECK <= "000001";	 
	      WAIT_0_5_SEC <= (others=>'0');
	      CHECK_COUNTER <= (others=>'0');    
         if (START = '1') then  
		     SIMON_STATE  <= DELAY;
         else
		     SIMON_STATE  <= IDEAL;	
		  
	    end if;

------------------WAIT FOR 0.125SEC---------------------------------------		
     when DELAY =>
	      GREEN  <= '0';
	      RED    <= '0';
	      YELLOW <= '0';
	      BLUE   <= '0'; 
	      START_IDEAL <= '0';    
       if (WAIT_0_5_SEC < TIME_VALUE/3) then
        WAIT_0_5_SEC <= WAIT_0_5_SEC + 1;
        SIMON_STATE  <= DELAY;
       else  
        WAIT_0_5_SEC <= (others=>'0'); 
        SIMON_STATE  <= SHOW_COLOR;
       end if;
       
-------------------SHOW COLOR----------------------------------------------- 
     when SHOW_COLOR =>      
       	  GREEN  <= G_SIGNAL;
	      RED    <= R_SIGNAL;
	      YELLOW <= Y_SIGNAL;
	      BLUE   <= B_SIGNAL;
	      SIMON_STATE  <= COLOR_SAVE_SEQUENCE;
	      CHECK_COUNTER <= CHECK_COUNTER + 1;
	      WAIT_0_5_SEC <= (others=>'0'); 
-------------------DISPLAY COLOR FOR 0.5 SEC AND SAVE COLOR SEQUENCE---------------- 	      
     when COLOR_SAVE_SEQUENCE =>      
     	  if (WAIT_0_5_SEC < TIME_VALUE) then
            WAIT_0_5_SEC <= WAIT_0_5_SEC + 1;
            SIMON_STATE  <= COLOR_SAVE_SEQUENCE;
          elsif (CHECK_COUNTER < LEVEL_CHECK) then
            SIMON_STATE  <= DELAY;
            WAIT_0_5_SEC <= (others=>'0');
            SAVE_SEQUENCE_COLOR <= SAVE_SEQUENCE_COLOR(176 downto 0) & (YELLOW or GREEN) & (BLUE or GREEN) & (RED);
          else
            SIMON_STATE  <= BUTTONS;
            CHECK_COUNTER <= (others=>'0'); 
            WAIT_0_5_SEC <= (others=>'0');
            SAVE_SEQUENCE_COLOR <= SAVE_SEQUENCE_COLOR(176 downto 0) & (YELLOW or GREEN) & (BLUE or GREEN) & (RED);
          end if; 
--------------------------------------------------------------------------------------------- 
--------------------------------------------------------------------------------------------- 
--------------------------------------------------------------------------------------------- 
--------------------------------------------------------------------------------------------- 
-------------------------WAIT FOR INPUT OF BUTTONS------------------------------------------- 
     when BUTTONS =>
     	  GREEN  <= '0';
	      RED    <= '0';
	      YELLOW <= '0';
	      BLUE   <= '0';  
      WAIT_0_5_SEC <= (others=>'0');  
        if (G_BUTTON = '1' or R_BUTTON = '1' or B_BUTTON = '1' or Y_BUTTON = '1') then       
            SIMON_STATE  <= CHECK_LEVEL;  
            CHECK_COUNTER <= CHECK_COUNTER + 1;       
            SAVE_SEQUENCE_BUTTON <= SAVE_SEQUENCE_BUTTON(176 downto 0) & (Y_BUTTON or G_BUTTON) & (B_BUTTON or G_BUTTON) & (R_BUTTON);  
        else
            SIMON_STATE  <= BUTTONS;                       
        end if;
--------------------------------------------------------------------------------------------- 
-------------------------CHECK_LEVEL---------------------------------------------------------         
      when CHECK_LEVEL =>
        if (CHECK_COUNTER <  LEVEL_CHECK) then
            SIMON_STATE  <= BUTTONS;  
        else
             SIMON_STATE  <= LEVEL;                       
        end if;
--------------------------------------------------------------------------------------------- 
-------------------------CHECK_SEQUENCE---------------------------------------------------------            
      when LEVEL => 
        CHECK_COUNTER <= (others=>'0');  	
        if (SAVE_SEQUENCE_BUTTON = SAVE_SEQUENCE_COLOR)	then
 	       LEVEL_CHECK <= LEVEL_CHECK + 1;
 	       SIMON_STATE  <= DELAY;
 	    else
 	       SIMON_STATE  <= IDEAL;
 	       SAVE_SEQUENCE_BUTTON <= (others=>'0'); 
 	       SAVE_SEQUENCE_COLOR <= (others=>'0');
 	   end if;       
 	end case;
  end if;	
end process;	  
--------------------------------------------------------------------------------------------- 
--------------------------------------------------------------------------------------------- 
--------------------------------------------------------------------------------------------- 


end Behavioral;
