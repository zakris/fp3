library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity IORepot_top is -- top-level design for testing
  port( 
       clk          : in STD_LOGIC;
       reset        : in STD_LOGIC;
       out_port   : out STD_LOGIC_VECTOR(15 downto 0)
	   );
end;

architecture IORepot_top of IORepot_top is

    component alu generic(width: integer);
        port(a, b           : in std_logic_vector(15 downto 0);
             functionBits   : in std_logic_vector(3 downto 0);
             shamt          : in std_logic_vector(3 downto 0);
             result         : out std_logic_vector(15 downto 0)
        );
    end component;
signal a, b         : std_logic_vector(15 downto 0);
signal functionBits : std_logic_vector(3 downto 0);
signal shamt : std_logic_vector(3 downto 0);
signal top_result : std_logic_vector(15 downto 0);
begin
    alu1: alu generic map(16) port map(a => a, b => b, functionBits => functionBits,
                                       shamt => shamt, result => top_result);
end IORepot_top;