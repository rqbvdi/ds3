#!/bin/bash

rm build/*
ghdl -a --std=08 --work=work --workdir=build src/cpu_constants_pkg.vhd && touch build/cpu_constants_pkg.stamp
ghdl -a --std=08 --work=work --workdir=build src/program_counter.vhd && touch build/program_counter.stamp
ghdl -a --std=08 --work=work --workdir=build src_tb/tb_program_counter.vhd && touch build/tb_program_counter.stamp
ghdl -e --std=08 --work=work --workdir=build -o build/tb_program_counter tb_program_counter


OUTPUT=sim_output
./build/tb_program_counter --vcd=wave.vcd > ${OUTPUT} 2>&1
RETCODE=$?
if [[ "$RETCODE" -ne 0 ]]; then
    echo "Failure during testbench execution"
    echo "Take a look at the file ${OUTPUT}:"
    echo "----------"
    cat ${OUTPUT}
    echo "----------"
    exit 1
fi
NUM_FAILS=$(cat ${OUTPUT} | tee /dev/tty | grep FAIL | wc -l)
rm -f ${OUTPUT}
if [[ "$NUM_FAILS" -eq 0 ]]; then
    echo "Tests PASSED \\o/"
    exit 0
else
    echo "Tests failed /o\\"
    exit 1
fi
