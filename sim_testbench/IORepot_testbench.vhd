library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity IORepot_sim is
end  IORepot_sim;

architecture behavioral of IORepot_sim is
    -- input signals
    signal a_sim         : std_logic_vector(15 downto 0) := X"0000";
    signal b_sim         : std_logic_vector(15 downto 0) := X"0000";
    signal function_bits : std_logic_vector(3 downto 0) := "0000";
    signal shift_amount  : std_logic_vector(3 downto 0) := "0000";
    
    -- output signals
    signal sim_result    : std_logic_vector(15 downto 0) := X"0000";
    -- signal for generating inputs; 
    -- abfs = a_sim, b_sim, function_bits, shift_amount concatenated together
    -- signal abfs : std_logic_vector(15 downto 0) := "0000000000000000";
    signal abfs : std_logic_vector(39 downto 0) := "0000000000000000000000000000000000000000";
    -- test signals for left and right shifters
    signal test_shift_r : std_logic_vector(15 downto 0) := X"0000";
    signal test_shift_l : std_logic_vector(15 downto 0) := X"0000";

----------------------------------------------------------------------------------------
  -- Function to_string for testbench
  -- convert a STD Logic vector to a string so we can report it in the testbench console
  -- output.
  -- source: https://stackoverflow.com/questions/15406887/vhdl-convert-vector-to-string
  -----------------------------------------------------------------------------------------
  function to_string ( a: std_logic_vector) return string is
    variable b : string (1 to a'length) := (others => NUL);
    variable stri : integer := 1; 
    begin
        for i in a'range loop
            b(stri) := std_logic'image(a((i)))(2);
        stri := stri+1;
        end loop;
    return b;
  end function;

  begin
    uut : entity work.alu generic map (width => 16)
    port map (a => a_sim, b => b_sim, functionBits => function_bits,
              shamt => shift_amount, result => sim_result);
    
    stim_proc: process
        -- variable i: INTEGER range 0 to 1099511627775
        variable i: INTEGER range 0 to 65535;
        variable alu_test : std_logic_vector(39 downto 0); -- we will compare this value to sim_result
    begin
        for i in 0 to 65535 loop
            -- convert i to 16-bit std logic vector and connect signal to abfs
            abfs(15 downto 0)  <= std_logic_vector(to_unsigned(i, 16));
            abfs(31 downto 16) <= std_logic_vector(to_unsigned((65535-i), 16));
            abfs(35 downto 32) <= std_logic_vector(to_unsigned(i, 4));
            abfs(39 downto 36) <= std_logic_vector(to_unsigned((i mod 17), 4));
            -- connect bits 0 - 3  of abfs to shift_amount
            a_sim <= abfs(15 downto 0);
            b_sim <= abfs(31 downto 16);
            function_bits <= abfs(35 downto 32);
            shift_amount <= abfs(39 downto 36);
            
            test_shift_r <= std_logic_vector(shift_right(unsigned(b_sim), (to_integer(unsigned(shift_amount)))));
            
            --wait for 40 ns; -- to stabilize values
                        
            test_shift_l <= std_logic_vector(shift_left(unsigned(b_sim), (to_integer(unsigned(shift_amount)))));

            --wait for 40 ns; -- to stabilize values

            -- validate signal
            alu_test := (a_sim) & (b_sim) & (function_bits) & (shift_amount);
            
            wait for 80 ns; -- to stabilize values


            end loop;
    end process;

end behavioral;