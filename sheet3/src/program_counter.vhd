library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu_constants_pkg.INSTRUCTION_MEM_ADDRESS_TYPE;
use work.cpu_constants_pkg.INSTRUCTION_MEM_START_ADDRESS;

entity program_counter is
    port(
        CLK : in std_logic;
        RESET : in std_logic;
        INSTRUCTION_ADDRESS_OFFSET_IN: in  INSTRUCTION_MEM_ADDRESS_TYPE;
        INSTRUCTION_ADDRESS_IN: in  INSTRUCTION_MEM_ADDRESS_TYPE;
        JAL_OR_BRANCH_TAKEN_IN: in std_logic;
        JALR_IN: in std_logic;
        INSTRUCTION_ADDRESS_OUT : out INSTRUCTION_MEM_ADDRESS_TYPE
    );
end entity program_counter;

architecture RTL of program_counter is
    signal pc_cs: INSTRUCTION_MEM_ADDRESS_TYPE := (others => '0');
begin

    process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                pc_cs <= (others => '0');
            elsif JAL_OR_BRANCH_TAKEN_IN = '1' then
                pc_cs <= std_logic_vector(unsigned(pc_cs) + unsigned(INSTRUCTION_ADDRESS_OFFSET_IN));
            elsif JALR_IN = '1' then
                pc_cs <= std_logic_vector(unsigned(INSTRUCTION_ADDRESS_IN) + unsigned(INSTRUCTION_ADDRESS_OFFSET_IN));
            else
                pc_cs <= std_logic_vector(unsigned(pc_cs) + 4);
            end if;
        end if;
    end process;

    -- kombinatorischer Ausgang
    INSTRUCTION_ADDRESS_OUT <= pc_cs;

end architecture RTL;
