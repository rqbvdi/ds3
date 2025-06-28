library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use std.env.finish;

use work.cpu_constants_pkg.DATA_TYPE;
use work.cpu_constants_pkg.REG_LEN;


entity tb_register_file is
end entity;


architecture rtl of tb_register_file is

    constant CLK_PERIOD: time := 100 ns;

    signal clk              : std_logic := '0';
    signal reg_a_address    : std_logic_vector(4 downto 0) := (others => '0');
    signal reg_b_address    : std_logic_vector(4 downto 0) := (others => '0');
    signal reg_write_address: std_logic_vector(4 downto 0);
    signal write_enable     : std_logic;
    signal write_data       : std_logic_vector(REG_LEN-1 downto 0);
    signal reg_a            : std_logic_vector(REG_LEN-1 downto 0);
    signal reg_b            : std_logic_vector(REG_LEN-1 downto 0);
    signal cycle            : integer := 0;

begin

    uut: entity work.register_file
    port map (
        clk               => clk,
        reg_a_address     => reg_a_address,
        reg_b_address     => reg_b_address,
        reg_write_address => reg_write_address,
        write_enable      => write_enable,
        write_data        => write_data,
        reg_a             => reg_a,
        reg_b             => reg_b
    );


    clk_generator: process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;


    test_runner: process
        variable v_reg_a_address    : std_logic_vector(4 downto 0);
        variable v_reg_b_address    : std_logic_vector(4 downto 0);
        variable v_reg_write_address: std_logic_vector(4 downto 0);
        variable v_write_enable     : std_logic;
        variable v_write_data       : std_logic_vector(REG_LEN-1 downto 0);
        variable v_reg_a            : std_logic_vector(REG_LEN-1 downto 0);
        variable v_reg_b            : std_logic_vector(REG_LEN-1 downto 0);

        file fp: text;
        variable row: line;
        variable char: character;
        variable count: integer;
    begin
        --wait until clk = '0';
        wait until rising_edge(clk);
        count := 0;
        file_open(fp, "stimuli_reg.txt", READ_MODE);
        readline(fp, row);
        while not endfile(fp) loop
            readline(fp, row);
            hread(row, v_reg_a_address);
            read(row, char);
            hread(row, v_reg_b_address);
            read(row, char);
            hread(row, v_reg_write_address);
            read(row, char);
            read(row, v_write_enable);
            read(row, char);
            hread(row, v_write_data);
            read(row, char);
            hread(row, v_reg_a);
            read(row, char);
            hread(row, v_reg_b);
            count := count + 1;
            cycle <= count;

            reg_a_address <= v_reg_a_address;
            reg_b_address <= v_reg_b_address;
            reg_write_address <= v_reg_write_address;
            write_enable <= v_write_enable;
            write_data <= v_write_data;

            wait for 1 fs;

            if reg_a /= v_reg_a then
                report "FAIL (reg_a, cycle " &
                    integer'image(count) & "): expected 0x" &
                    to_hstring(v_reg_a) &
                    ", got 0x" & to_hstring(reg_a);
            end if;

            if reg_b /= v_reg_b then
                report "FAIL (reg_b, cycle " &
                    integer'image(count) & "): expected 0x" &
                    to_hstring(v_reg_b) &
                    ", got 0x" & to_hstring(reg_b);
            end if;

            wait for CLK_PERIOD;
        end loop;
        file_close(fp);
        finish;
        wait;
    end process;

end architecture;
