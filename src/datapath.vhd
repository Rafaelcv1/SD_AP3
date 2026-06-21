library ieee;
use ieee.std_logic_1164.all;

entity datapath is
    generic (
        N : positive := 32
    );
    port (
        A, B: in std_logic_vector(N-1 downto 0);
        clk: in std_logic;
        
        result: out std_logic_vector(N-1 downto 0);
        zero: out std_logic;

        c: in std_logic_vector(2 downto 0);
        reg_result, multi_reg: in std_logic;

        ov: out std_logic
    );
end entity datapath;

architecture RTL of datapath is
    signal or_res, and_res, nor_res, xor_res, sumOrDiff_res, mult_res, slt_res, mux_output : std_logic_vector(N-1 downto 0);
    signal ov_AddOrSub, ov_mult : std_logic;
begin
    or_res <= A or B;
    and_res <= A and B;
    nor_res <= not (A or B);
    xor_res <= A xor B;
    slt_res(slt_res'low) <= sumOrDiff_res(sumOrDiff_res'high) xor ov_AddOrSub;
    slt_res(slt_res'high downto slt_res'low + 1) <= (others => '0');

    AddOrSub: entity work.sumOrDiff
        generic map (N => N)
        port map (
            A => A,
            B => B,
            c => c(0),
            ov => ov_AddOrSub,
            result => sumOrDiff_res
        );
    Mult: entity work.multi32x32
        port map (
            A => A,
            B => B,
            clk => clk,
            multi_reg => multi_reg,
            result => mult_res,
            ov => ov_mult
        );
    Mux: entity work.mux8to1
        generic map (N => N)
        port map (
            in0 => or_res,
            in1 => and_res,
            in2 => nor_res,
            in3 => xor_res,
            in4 => sumOrDiff_res,
            in5 => sumOrDiff_res,
            in6 => mult_res,
            in7 => slt_res,
            sel => c,
            output => mux_output
        );
    register_result: entity work.reg
        generic map (N => N)
        port map (
            clk => clk,
            reg_in => mux_output,
            reg_out => result,
            reg_enable => reg_result
        );
    nor_zero: entity work.nor_zero
        generic map (N => N)
        port map (
            A => mux_output,
            zero => zero
        );
    ov <= ov_AddOrSub when (c = "100" or c = "101") else
        ov_mult when c = "110" else
        '0';
end architecture RTL;
