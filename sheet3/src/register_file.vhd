library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu_constants_pkg.DATA_TYPE;
use work.cpu_constants_pkg.REGISTER_LIST;

entity REGISTER_FILE is
    port(
        CLK : in std_logic;
        REG_A_ADDRESS : in std_logic_vector(4 downto 0);
        REG_A : out DATA_TYPE;
        REG_B_ADDRESS : in std_logic_vector(4 downto 0);
        REG_B : out DATA_TYPE;
        REG_WRITE_ADDRESS : in std_logic_vector(4 downto 0);
        WRITE_DATA : in DATA_TYPE := (others => '0');
        WRITE_ENABLE : in std_logic
    );
end entity REGISTER_FILE;

architecture ARCH of REGISTER_FILE is

    signal registers : REGISTER_LIST := (others => (others => '0'));

begin

    -- Schreibprozess: synchron bei steigender Taktflanke
    process(CLK)
    begin
        if rising_edge(CLK) then
            if WRITE_ENABLE = '1' and REG_WRITE_ADDRESS /= "00000" then
                registers(to_integer(unsigned(REG_WRITE_ADDRESS))) <= WRITE_DATA;
            end if;
        end if;
    end process;

    -- Asynchrone Leseports mit Spezialfall für Register 0
    REG_A <= (others => '0') when REG_A_ADDRESS = "00000"
             else registers(to_integer(unsigned(REG_A_ADDRESS)));

    REG_B <= (others => '0') when REG_B_ADDRESS = "00000"
             else registers(to_integer(unsigned(REG_B_ADDRESS)));

end architecture ARCH;
