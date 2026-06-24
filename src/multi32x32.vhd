library ieee;
use ieee.std_logic_1164.all;

entity multi32x32 is
    port (
        A, B: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        multi_reg: in std_logic;
        result: out std_logic_vector(31 downto 0);
        ov: out std_logic
    );
end entity multi32x32;

architecture RTL of multi32x32 is
    signal reg1_out, reg2_out, reg3_out, reg4_out: std_logic_vector(31 downto 0);
    signal mult_AHBH_out, mult_AHBL_out, mult_ALBH_out, mult_ALBL_out: std_logic_vector(31 downto 0);
    signal S1_result, S2_result: std_logic_vector(47 downto 0);
    signal S3_result: std_logic_vector(63 downto 0);
begin
    mult_AHBH: entity work.multi16x16
        port map (
            A => A(31 downto 16),
            B => B(31 downto 16),
            result => mult_AHBH_out
        );
    reg1: entity work.reg
        generic map (N => 32)
        port map (
            clk => clk,
            reg_in => mult_AHBH_out,
            reg_out => reg1_out,
            reg_enable => multi_reg
        );

    mult_AHBL: entity work.multi16x16
        port map (
            A => A(31 downto 16),
            B => B(15 downto 0),
            result => mult_AHBL_out
        );
    reg2: entity work.reg
        generic map (N => 32)
        port map (
            clk => clk,
            reg_in => mult_AHBL_out,
            reg_out => reg2_out,
            reg_enable => multi_reg
        );

    mult_ALBH: entity work.multi16x16
        port map (
            A => A(15 downto 0),
            B => B(31 downto 16),
            result => mult_ALBH_out
        );
    reg3: entity work.reg
        generic map (N => 32)
        port map (
            clk => clk,
            reg_in => mult_ALBH_out,
            reg_out => reg3_out,
            reg_enable => multi_reg
        );

    mult_ALBL: entity work.multi16x16
        port map (
            A => A(15 downto 0),
            B => B(15 downto 0),
            result => mult_ALBL_out
        );
    reg4: entity work.reg
        generic map (N => 32)
        port map (
            clk => clk,
            reg_in => mult_ALBL_out,
            reg_out => reg4_out,
            reg_enable => multi_reg
         );

    S_half1: entity work.sumOrDiff
    generic map(N => 48)
    port map(
        A => reg1_out & "0000000000000000",
        B => "0000000000000000" & reg3_out,
        c => '0',
        result => S1_result,
        ov => open
    );

    S_half2: entity work.sumOrDiff
    generic map(N => 48)
    port map(
        A => reg2_out & "0000000000000000",
        B => "0000000000000000" & reg4_out,
        c => '0',
        result => S2_result,
        ov => open
    );
    S_full: entity work.sumOrDiff
    generic map(N => 64)
    port map(
        A => S1_result & "0000000000000000",
        B => "0000000000000000" & S2_result,
        c => '0',
        result => S3_result,
        ov => open
    );
    
    ov <= '1' when S3_result(63 downto 32) /= ("00000000000000000000000000000000") else '0';
    result <= S3_result(31 downto 0);
end architecture RTL;
