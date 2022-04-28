-------------------------------------------------------------------------------
-- Group IORepot
-- Datapath Unit: contains structural VHDL to wire datapath components together
-- Contributors: Michael Laramie, Nana Boateng, Zakris Pierson, Jeremy Muriungi
-- Last modified: 4/28/2022
-- Sources:
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity datapath is  
  port(clk, reset:        in  STD_LOGIC;
       pc:                inout STD_LOGIC_VECTOR(15 downto 0)
  );
end;

architecture struct of datapath is
    -- adder to increment program counter by 2
    -- increment pc by 2 because our instructions are 16 bits = 2 bytes; next instruction will be at pc + 2
    component adder
      port(a, b: in  STD_LOGIC_VECTOR(15 downto 0);
           y:    out STD_LOGIC_VECTOR(15 downto 0));
    end component;
    -- program counter, 16-bit register
    component flopr generic(width: integer);
      port(clk, reset: in  STD_LOGIC;
           d:          in  STD_LOGIC_VECTOR(width-1 downto 0);
           q:          out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;
  
    signal pcnext, pcplus2 : STD_LOGIC_VECTOR(15 downto 0);
  begin
    -- next PC logic
    pcreg: flopr generic map(16) port map(clk, reset, pcnext, pc);
    pcadd1: adder port map(pc, X"0002", pcplus2);
  end;