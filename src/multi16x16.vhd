library ieee;
use ieee.std_logic_1164.all;

entity multi16x16 is
    port (
        A, B: in std_logic_vector(15 downto 0);
        result: out std_logic_vector(31 downto 0)
    );
end entity multi16x16;

architecture RTL of multi16x16 is
    signal mult_AHBH_out, mult_AHBL_out, mult_ALBH_out, mult_ALBL_out: std_logic_vector(15 downto 0);
    signal S1_result, S2_result: std_logic_vector(23 downto 0) := (others => '0');
begin
    mult_AHBH: entity work.multi8x8
        port map (
            A => A(15 downto 8),
            B => B(15 downto 8),
            result => mult_AHBH_out
        );

    mult_AHBL: entity work.multi8x8
        port map (
            A => A(15 downto 8),
            B => B(7 downto 0),
            result => mult_AHBL_out
        );

    mult_ALBH: entity work.multi8x8
        port map (
            A => A(7 downto 0),
            B => B(15 downto 8),
            result => mult_ALBH_out
        );

    mult_ALBL: entity work.multi8x8
        port map (
            A => A(7 downto 0),
            B => B(7 downto 0),
            result => mult_ALBL_out
        );

    S_half1: entity work.sumOrDiff
    generic map(N => 24)
    port map(
        A => mult_AHBH_out & "00000000",
        B => "00000000" & mult_ALBH_out,
        c => '0',
        result => S1_result,
        ov => open
    );

    S_half2: entity work.sumOrDiff
    generic map(N => 24)
    port map(
        A => mult_AHBL_out & "00000000",
        B => "00000000" & mult_ALBL_out,
        c => '0',
        result => S2_result,
        ov => open
    );

    S_full: entity work.sumOrDiff
    generic map(N => 32)
    port map(
        A => S1_result & "00000000",
        B => "00000000" & S2_result,
        c => '0',
        result => result,
        ov => open
    );

end architecture RTL;