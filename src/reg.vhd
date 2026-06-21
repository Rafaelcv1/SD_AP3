library ieee;
use ieee.std_logic_1164.all;

entity reg is
    generic (
        N : positive := 32
    );
    port (
        clk: in std_logic;
        reg_enable: in std_logic;
        reg_in: in std_logic_vector(N-1 downto 0);
        reg_out: out std_logic_vector(N-1 downto 0)
    );
end entity reg;

architecture RTL of reg is
    signal Sreg: std_logic_vector(N-1 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reg_enable = '1' then
                Sreg <= reg_in;
            end if;
        end if;
    end process;

    reg_out <= Sreg;
end architecture RTL;
