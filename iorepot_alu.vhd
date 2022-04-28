------------------------------------------------------------------------
-- Group IORepot
-- Arithmetic Logic Unit with AND, OR, add, slt, slti, sub, sll, srl
------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.all;

entity alu is
    generic(width: integer);
    port(a, b         : in std_logic_vector((width-1) downto 0);
         functionBits : in std_logic_vector(3 downto 0);
         shamt        : in std_logic_vector(3 downto 0);            -- according to our slides
         result       : out std_logic_vector((width-1) downto 0)
         --gtz          : out std_logic;    -- greater than zero
         --ltez         : out std_logic;    -- less than or equal to zero
         --msb          : out std_logic     -- most significant bit
         -- below are for when we eventually connect to our control unit and datapath and other places
         -- immediate:  in std_logic_vector(x downto x);
         -- alucontrol: in std_logic_vector(x downto x);
         -- zero:       out std_logic
    );
end alu;

architecture Behavioral of alu is
    signal const_zero : STD_LOGIC_VECTOR((width-1) downto 0) := (others => '0');
    -- declare shift components
    component shift_left is
    generic (N:integer := 16);     --possibly change to 16 since our instructions are 16-bit?
    port(
        slInput     : in std_logic_vector((N-1) downto 0);
        lshamt       : in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
        slResult    : out std_logic_vector(N-1 downto 0)
    );
    end component;

    component shift_right is
    generic (N:integer := 16);     --possibly change to 16 since our instructions are 16-bit?
    port(
        srInput     : in std_logic_vector(N-1 downto 0);
        rshamt       : in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
        srResult    : out std_logic_vector(N-1 downto 0)
    );
    end component;

    signal sum : std_logic_vector(width-1 downto 0) := ( others => '0');
    signal bout : std_logic_vector(width-1 downto 0) := ( others => '0');
    signal shiftLeft : std_logic_vector(width-1 downto 0) := ( others => '0');
    signal shiftRight : std_logic_vector(width-1 downto 0) := ( others => '0');
    signal slt : std_logic_vector(width-1 downto 0) := ( others => '0');
    signal slti : std_logic_vector(width-1 downto 0) := ( others => '0');
begin
    bout <= b when (functionBits(3) = '0' ) else not b;
    sum <= a + bout + functionBits(3);     -- functionBits(3) for two's complement
    slt  <= ( const_zero(width-1 downto 1) & '1') when sum(0) = '1' else (others =>'0'); 
    slti <= ( const_zero(width-1 downto 1) & '1') when sum((width-1)) = '1' else (others =>'0'); 


     process (a, bout, sum, functionBits, shiftLeft, shiftRight)
     --we use variables for clarity and help with debugging testbunch/alu
     variable var_and : std_logic_vector (15 downto 0);
     variable var_or : std_logic_vector (15 downto 0);
     variable var_sum : std_logic_vector (15 downto 0);
     variable var_slti : std_logic_vector (15 downto 0);
     variable var_shiftL : std_logic_vector (15 downto 0);
     variable var_shiftR : std_logic_vector (15 downto 0);
     variable var_slt : std_logic_vector (15 downto 0);
     variable var_error : std_logic_vector (15 downto 0);

     begin
        var_and := a and bout;
        var_or := a or bout;
        var_sum := sum;
        var_slti := slti; 
        var_shiftL := shiftLeft;
        var_shiftR := shiftRight;
        var_slt := slt;
        var_error := "----------------";
         case functionBits(2 downto 0) is
             when "000" => result <= var_and;
             when "001" => result <= var_or;
             when "010" => result <= var_sum;     -- both addition and subtraction based on top-most function bit
             when "100" => result <= var_shiftL;         -- code for shift left logical XXXchanged from var_shiftL for debugging
             when "101" => result <= var_shiftR;        -- code for shift right logical  XXXchanged from var_shiftR for debugging
             when "110" => result <= var_error;         -- code for shift left logical XXXchanged from var_shiftL for debugging
             
             when "011" => result <= var_slti;    -- set less than immediate, not sure if this will work
             when "111" => result <= var_slt;    -- zero extend for set less than
             when others => result <= var_error;    -- not defined
         end case;
     end process;
    -- implement shifters                                          not sure about this section
    --leftShifter  : shift_left  generic map(N=> 32) port map(leftShiftIn => slInput, leftShamt => lshamt, leftShiftRes => slResult);
    leftShifter  : shift_left  generic map(N=> 16) port map(slInput => b, lshamt => shamt, slResult => shiftLeft);
    rightShifter : shift_right generic map(N=> 16) port map(srInput => b, rshamt => shamt, srResult => shiftRight);
end Behavioral;