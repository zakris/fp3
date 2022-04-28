-------------------------------------------------------------------------------
-- Group IORepot
-- Building blocks library of hardware components
-- Contributors: Michael Laramie, Nana Boateng, Zakris Pierson, Jeremy Muriungi
-- Last modified: 4/28/2022
-- Sources:
-------------------------------------------------------------------------------

-- *** each entity must have its own separate library and use statements *** --
library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity adder is -- adder
  port(a, b: in  STD_LOGIC_VECTOR(15 downto 0);
       y:    out STD_LOGIC_VECTOR(15 downto 0));
end;

-- *** each entity must have its own separate library and use statements *** --
library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity flopr is -- flip-flop with synchronous reset
  generic(width: integer);
  port(clk, reset: in  STD_LOGIC;
       d:          in  STD_LOGIC_VECTOR(width-1 downto 0);
       q:          out STD_LOGIC_VECTOR(width-1 downto 0));
end;

architecture behave of adder is
    begin
      y <= a + b;
    end;
    
architecture asynchronous of flopr is
begin
    process(clk, reset) begin
    if reset = '1' then  q <= std_logic_vector(to_unsigned(0,16));
    elsif clk'event and clk = '1' then
        q <= d;
    end if;
    end process;
end;