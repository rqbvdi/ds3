library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use std.env.finish;

use work.cpu_constants_pkg.INSTRUCTION_MEM_ADDRESS_TYPE;


entity tb_program_counter is
end entity;


architecture rtl of tb_program_counter is

    signal clk                          : std_logic := '0';
    signal reset                        : std_logic := '1';
    signal instruction_address_offset_in: INSTRUCTION_MEM_ADDRESS_TYPE;
    signal instruction_address_in       : INSTRUCTION_MEM_ADDRESS_TYPE;
    signal instruction_address_out      : INSTRUCTION_MEM_ADDRESS_TYPE;
    signal jal_or_branch_taken_in       : std_logic;
    signal jalr_in                      : std_logic;
    signal cycle                        : integer := 0;

    constant CLK_PERIOD                 : time := 100 ns;

    signal exp: INSTRUCTION_MEM_ADDRESS_TYPE;
    signal exp2: INSTRUCTION_MEM_ADDRESS_TYPE;

begin

    clk_generator: process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;


    uut: entity work.program_counter
    port map (
        CLK                           => clk,
        RESET                         => reset,
        INSTRUCTION_ADDRESS_OFFSET_IN => instruction_address_offset_in,
        INSTRUCTION_ADDRESS_IN        => instruction_address_in,
        JAL_OR_BRANCH_TAKEN_IN        => jal_or_branch_taken_in,
        JALR_IN                       => jalr_in,
        INSTRUCTION_ADDRESS_OUT       => instruction_address_out
    );


    checker: process
        variable cmp: INSTRUCTION_MEM_ADDRESS_TYPE;
    begin
        while true loop
            wait until rising_edge(clk);
            wait for 1 fs;
            if cycle > 1 then
                if instruction_address_out /= exp2 then
                    report "FAIL (instruction_address_out, cycle " &
                        integer'image(cycle) & "): expected 0x" &
                        to_hstring(exp2) &
                        ", got 0x" & to_hstring(instruction_address_out);
                end if;
            end if;
        end loop;
    end process;


    test_runner: process

        file fp: text;
        variable row: line;
        variable char: character;
        variable count: integer := 0;

        variable v_instruction_address_offset_in: INSTRUCTION_MEM_ADDRESS_TYPE;
        variable v_instruction_address_in       : INSTRUCTION_MEM_ADDRESS_TYPE;
        variable v_instruction_address_out      : INSTRUCTION_MEM_ADDRESS_TYPE;
        variable v_last                         : INSTRUCTION_MEM_ADDRESS_TYPE;
        variable v_jal_or_branch_taken_in       : std_logic;
        variable v_jalr_in                      : std_logic;
        variable v_reset                        : std_logic;

        variable first: boolean := true;

    begin
        wait until rising_edge(clk);
        file_open(fp, "stimuli_pc.txt", READ_MODE);
        readline(fp, row);
        while not endfile(fp) loop

            count := count + 1;
            readline(fp, row);
            hread(row, v_instruction_address_offset_in);
            read(row, char);
            hread(row, v_instruction_address_in);
            read(row, char);
            read(row, v_jal_or_branch_taken_in);
            read(row, char);
            read(row, v_jalr_in);
            read(row, char);
            read(row, v_reset);
            read(row, char);
            hread(row, v_instruction_address_out);
            exp <= v_instruction_address_out;
            exp2 <= exp;
            cycle <= count;

            instruction_address_offset_in <= v_instruction_address_offset_in;
            instruction_address_in <= v_instruction_address_in;
            jal_or_branch_taken_in <= v_jal_or_branch_taken_in;
            jalr_in <= v_jalr_in;
            reset <= v_reset;

            wait until rising_edge(clk);
            first := false;
        end loop;
        file_close(fp);
        wait for 1 fs;
        finish;
        wait;
    end process;

end architecture;
