library ieee;
use ieee.std_logic_1164.all;


package cpu_constants_pkg is
    
    type ALU_OP_TYPE is (
        ALU_AND, 
        ALU_OR, 
        ALU_XOR,
        ALU_SLT, -- Set Less Then Signed
        ALU_SLTU,-- Set Less Then Unsigned
        ALU_ADD, 
        ALU_SUB,
        ALU_SRL, 
        ALU_SLL, 
        ALU_SRA, 
        ALU_UNUSED
    );

    constant REG_LEN   : positive := 32;

    constant FUNCT7_LEN: positive := 7;
    constant IMM_LEN   : positive := 12;
    constant INSTRUCTION_MEM_SIZE : positive := 16;
    
    subtype DATA_TYPE is std_logic_vector(REG_LEN-1 downto 0);
    subtype INSTRUCTION_TYPE is std_logic_vector(31 downto 0);
    subtype INSTRUCTION_MEM_ADDRESS_TYPE is std_logic_vector(31 downto 0); 
    
    --type ROM_TYPE is array (0 to 65536) of std_logic_vector(7 downto 0);
    
    subtype REG_SOURCE_TYPE is std_logic_vector(1 downto 0);
    constant FROM_WRITE_BACK : REG_SOURCE_TYPE := "00";
    constant FROM_PC_PLUS_4 : REG_SOURCE_TYPE := "01";
    constant FROM_IMMEDIATE : REG_SOURCE_TYPE := "10";
    constant FROM_PC_PLUS_IMM : REG_SOURCE_TYPE := "11";
    
    constant INSTRUCTION_MEM_START_ADDRESS : INSTRUCTION_MEM_ADDRESS_TYPE := (others => '0');
    
    type REGISTER_LIST is array(31 downto 0) of std_logic_vector(31 downto 0);
end package;