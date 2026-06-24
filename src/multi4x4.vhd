library ieee;
use ieee.std_logic_1164.all;

entity multi4x4 is
    port (
        A, B: in std_logic_vector(3 downto 0);
        result: out std_logic_vector(7 downto 0)
    );
end entity multi4x4;

architecture RTL of multi4x4 is
    signal mult_AHBH_out, mult_AHBL_out, mult_ALBH_out, mult_ALBL_out: std_logic_vector(3 downto 0);
    signal S1_result, S2_result: std_logic_vector(5 downto 0) := (others => '0');
begin
    mult_AHBH: entity work.multi2x2
        port map (
            A => A(3 downto 2),
            B => B(3 downto 2),
            result => mult_AHBH_out
        );

    mult_AHBL: entity work.multi2x2
        port map (
            A => A(3 downto 2),
            B => B(1 downto 0),
            result => mult_AHBL_out
        );

    mult_ALBH: entity work.multi2x2
        port map (
            A => A(1 downto 0),
            B => B(3 downto 2),
            result => mult_ALBH_out
        );

    mult_ALBL: entity work.multi2x2
        port map (
            A => A(1 downto 0),
            B => B(1 downto 0),
            result => mult_ALBL_out
        );

    S_half1: entity work.sumOrDiff
    generic map(N => 6)
    port map(
        A => mult_AHBH_out & "00",
        B => "00" & mult_ALBH_out,
        c => '0',
        result => S1_result,
        ov => open
    );

    S_half2: entity work.sumOrDiff
    generic map(N => 6)
    port map(
        A => mult_AHBL_out & "00",
        B => "00" & mult_ALBL_out,
        c => '0',
        result => S2_result,
        ov => open
    );

    S_full: entity work.sumOrDiff
    generic map(N => 8)
    port map(
        A => S1_result & "00",
        B => "00" & S2_result,
        c => '0',
        result => result,
        ov => open
    );

end architecture RTL;