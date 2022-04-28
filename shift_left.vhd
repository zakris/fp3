------------------------------------------------
-- Module Name: shift_left - Behavioral 
-- This module uses a for loop to create N 
-- n parallel comparators!
------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;

entity shift_left is
   generic ( N : integer := 16 );   --possibly change to 16 since our instructions are 16-bit?
   Port (   slInput : in  STD_LOGIC_VECTOR(N-1 downto 0);
	        lshamt : in STD_LOGIC_VECTOR(integer(ceil(log2(real(N))))-1 downto 0);
            slResult : out  STD_LOGIC_VECTOR(N-1 downto 0) );
end shift_left;

architecture Behavioral of shift_left is
begin
 process(slInput, lshamt)
 begin
    for i in 0 to N-1 loop  -- make several shift components
        if lshamt = std_logic_vector(to_unsigned(i,N)) then
            slResult <= std_logic_vector( unsigned(slInput) sll i );
        end if;
    end loop;
 end process;
 
end Behavioral;
