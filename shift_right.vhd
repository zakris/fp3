------------------------------------------------
-- Module Name: shift_right - Behavioral 
-- This module uses a for loop to create N 
-- n parallel comparators!
------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;

entity shift_right is
   generic ( N : integer := 16 );   --possibly change to 16 since our instructions are 16-bit?
   Port (   srInput : in  STD_LOGIC_VECTOR(N-1 downto 0);
	        rshamt : in STD_LOGIC_VECTOR(integer(ceil(log2(real(N))))-1 downto 0);
            srResult : out  STD_LOGIC_VECTOR(N-1 downto 0) );
end shift_right;

architecture Behavioral of shift_right is
begin
 process(srInput, rshamt)
 begin
    for i in 0 to N-1 loop  -- make several shift components
        if rshamt = std_logic_vector(to_unsigned(i,N)) then  -- does shift ammount equal i? 
            srResult <= std_logic_vector( unsigned(srInput) srl i );
        end if;
    end loop;
 end process;
 
end Behavioral;