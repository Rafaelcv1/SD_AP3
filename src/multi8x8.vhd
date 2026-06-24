library ieee;
use ieee.std_logic_1164.all;

entity multi8x8 is
    port (
        A, B: in std_logic_vector(7 downto 0);
        result: out std_logic_vector(15 downto 0)
    );
end entity multi8x8;

architecture RTL of multi8x8 is
    signal mult_AHBH_out, mult_AHBL_out, mult_ALBH_out, mult_ALBL_out: std_logic_vector(7 downto 0);
    signal S1_result, S2_result: std_logic_vector(11 downto 0) := (others => '0');
begin
    mult_AHBH: entity work.multi4x4
        port map (
            A => A(7 downto 4),
            B => B(7 downto 4),
            result => mult_AHBH_out
        );

    mult_AHBL: entity work.multi4x4
        port map (
            A => A(7 downto 4),
            B => B(3 downto 0),
            result => mult_AHBL_out
        );

    mult_ALBH: entity work.multi4x4
        port map (
            A => A(3 downto 0),
            B => B(7 downto 4),
            result => mult_ALBH_out
        );

    mult_ALBL: entity work.multi4x4
        port map (
            A => A(3 downto 0),
            B => B(3 downto 0),
            result => mult_ALBL_out
        );

    S_half1: entity work.sumOrDiff
    generic map(N => 12)
    port map(
        A => mult_AHBH_out & "0000",
        B => "0000" & mult_ALBH_out,
        c => '0',
        result => S1_result,
        ov => open
    );

    S_half2: entity work.sumOrDiff
    generic map(N => 12)
    port map(
        A => mult_AHBL_out & "0000",
        B => "0000" & mult_ALBL_out,
        c => '0',
        result => S2_result,
        ov => open
    );

    S_full: entity work.sumOrDiff
    generic map(N => 16)
    port map(
        A => S1_result & "0000",
        B => "0000" & S2_result,
        c => '0',
        result => result,
        ov => open
    );

end architecture RTL;