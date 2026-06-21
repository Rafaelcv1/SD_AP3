library ieee;
use ieee.std_logic_1164.all;

entity multi8x8 is
    port (
        A, B: in std_logic_vector(7 downto 0);
        -- clk: in std_logic;
        -- multi_reg: in std_logic;
        result: out std_logic_vector(15 downto 0);
        ov: out std_logic
    );
end entity multi8x8;

architecture RTL of multi8x8 is
    -- signal reg1_out, reg2_out, reg3_out, reg4_out: std_logic_vector(15 downto 0);
    signal mult_AHBH_out, mult_AHBL_out, mult_ALBH_out, mult_ALBL_out: std_logic_vector(7 downto 0);
    signal AHBH_ALBL, S1_result, S2_result: std_logic_vector(15 downto 0) := (others => '0');
    signal ov_vec: std_logic_vector(4 downto 0);
begin
    mult_AHBH: entity work.multi4x4
        port map (
            A => A(7 downto 4),
            B => B(7 downto 4),
            result => mult_AHBH_out,
            ov => ov_vec(3)
        );
    -- reg1: entity work.reg
    --     generic map (N => 16)
    --     port map (
    --         clk => clk,
    --         reg_in => mult_AHBH_out,
    --         reg_out => reg1_out,
    --         reg_enable => multi_reg
    --     );

    mult_AHBL: entity work.multi4x4
        port map (
            A => A(7 downto 4),
            B => B(3 downto 0),
            result => mult_AHBL_out,
            ov => ov_vec(2)
        );
    -- reg2: entity work.reg
    --     generic map (N => 16)
    --     port map (
    --         clk => clk,
    --         reg_in => mult_AHBL_out,
    --         reg_out => reg2_out,
    --         reg_enable => multi_reg
    --     );

    mult_ALBH: entity work.multi4x4
        port map (
            A => A(3 downto 0),
            B => B(7 downto 4),
            result => mult_ALBH_out,
            ov => ov_vec(1)
        );
    -- reg3: entity work.reg
    --     generic map (N => 16)
    --     port map (
    --         clk => clk,
    --         reg_in => mult_ALBH_out,
    --         reg_out => reg3_out,
    --         reg_enable => multi_reg
    --     );

    mult_ALBL: entity work.multi4x4
        port map (
            A => A(3 downto 0),
            B => B(3 downto 0),
            result => mult_ALBL_out,
            ov => ov_vec(0)
        );
    -- reg4: entity work.reg
    --     generic map (N => 16)
    --     port map (
    --         clk => clk,
    --         reg_in => mult_ALBL_out,
    --         reg_out => reg4_out,
    --         reg_enable => multi_reg
    --      );

    S_half: entity work.sumOrDiff
    generic map(N => 8)
    port map(
        A => mult_AHBL_out, -- A => reg2_out,
        B => mult_ALBH_out, -- B => reg3_out,
        c => '0',
        result => S1_result(11 downto 4),
        ov => S1_result(12)
    );

    S_full: entity work.sumOrDiff
    generic map(N => 16)
    port map(
        A => S1_result,
        B => AHBH_ALBL,
        c => '0',
        result => S2_result,
        ov => ov_vec(4)
    );
    
    AHBH_ALBL <= mult_AHBH_out & mult_ALBL_out; --AHBH_ALBL <= reg1_out & reg4_out;

    ov <= '1' when ov_vec /= "00000" else '0';

    result <= S2_result;
end architecture RTL;