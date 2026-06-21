library ieee;
use ieee.std_logic_1164.all;

entity ula is
    generic (
        N : positive := 32
    );
    port (
        A, B: in std_logic_vector(N-1 downto 0);
        operation: in std_logic_vector(2 downto 0);
        clk, start, reset: in std_logic;
        zero, overflow, done: out std_logic;
        result: out std_logic_vector(N-1 downto 0)
    );
end entity ula;

architecture RTL of ula is
    signal c: std_logic_vector(2 downto 0);
    signal ov, reg_result, multi_reg: std_logic;
begin
    ctlr: entity work.control
        port map (
            operation => operation,
            start => start,
            reset => reset,
            clk => clk,
            reg_result => reg_result,
            multi_reg => multi_reg,
            done => done,
            ov => ov,
            overflow => overflow,
            c => c
        );
    dtpath: entity work.datapath
        generic map (N => N)
        port map (
            A => A,
            B => B,
            c => c,
            clk => clk,
            reg_result => reg_result,
            multi_reg => multi_reg,

            ov => ov,
            result => result,
            zero => zero
        );
end architecture RTL;