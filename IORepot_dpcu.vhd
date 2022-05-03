-------------------------------------------------------------------------------
-- Group IORepot
-- Data path unit and Control Unit file; our version of the mips.vhd file
-- holds data path unit, and control unit
-- Contributors: Michael Laramie, Nana Boateng, Zakris Pierson, Jeremy Muriungi
-- Last modified: 4/28/2022
-- Sources:
-------------------------------------------------------------------------------

------------------------------------------------------------
-- Entity Declarations
------------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity dpcu is
 -- single cycle IORepot processor
  generic(width: integer);
  port(clk, reset:        in  STD_LOGIC;
       pc:                inout STD_LOGIC_VECTOR((width-1) downto 0);
       instr:             in  STD_LOGIC_VECTOR((width-1) downto 0);
       memwrite:          out STD_LOGIC;
       aluout, writedata: inout STD_LOGIC_VECTOR((width-1) downto 0);
       readdata:          in  STD_LOGIC_VECTOR((width-1) downto 0));
end;

---------------------------------------------------------
-- Architecture Definitions
---------------------------------------------------------
architecture struct of dcpu is
    component controller
        port(op         : in std_logic_vector(3 downto 0);
             -- funct      : in std_logic_vector(3 downto 0);
             zero       : in std_logic;
             lt         : in std_logic;
             memtoreg   : out std_logic;
             memwrite   : out std_logic;
             pcsrc      : out std_logic;
             alusrc     : out std_logic;
             regdst     : out std_logic;
             regwrite   : out std_logic;
             alucontrol : out std_logic_vector(3 downto 0)
             );
    end component;
    
    component datapath generic(width : integer);
        port(clk        : in std_logic;
             reset      : in std_logic;
             memtoreg   : in std_logic;
             pcsrc      : in std_logic;
             alusrc     : in std_logic;
             regdst     : in std_logic;
             regwrite   : in std_logic;
             alucontrol : in std_logic_vector(3 downto 0);
             instr      : in std_logic_vector((width-1) downto 0);
             readdata   : in std_logic_vector((width-1) downto 0);
             pc         : inout std_logic_vector((width-1) downto 0);
             aluout     : inout std_logic_vector((width-1) downto 0);
             writedata  : inout std_logic_vector((width-1) downto 0);
             zero       : out std_logic;
            );
    end component;

    -- Signals to wire the datapath unit to the controller unit
    signal memtoreg, alusrc, regdst, regwrite, pcsrc: STD_LOGIC;
    signal zero: STD_LOGIC;
    signal lt: STD_LOGIC;
    signal alucontrol: STD_LOGIC_VECTOR(3 downto 0);

begin
    lt <= aluout(width-1);
    contUnit : controller port map(op         => instr(width-1) downto 12,
                                   zero       => zero,
                                   memtoreg   => memtoreg,
                                   memwrite   => memwrite,
                                   pcsrc      => pcsrc,
                                   alusrc     => alusrc,
                                   regdst     => regdst,
                                   regwrite   => regwrite,
                                   alucontrol => alucontrol,
                                   lt         => lt);
    dpUnit : datapath generic map(width) port map(
                                   clk        => clk,
                                   reset      => reset,
                                   memtoreg   => memtoreg,
                                   pcsrc      => pcsrc,
                                   alusrc     => alusrc,
                                   regdst     => regdst,
                                   regwrite   => regwrite,
                                   alucontrol => alucontrol,
                                   zero       => zero,
                                   pc         => pc,
                                   instr      => instr,
                                   aluout     => aluout,
                                   writedata  => writedata,
                                   readdata   => readdata);
end;