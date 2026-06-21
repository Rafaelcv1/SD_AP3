library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sumOrDiff is
    generic (
        N : positive := 32
    );
    port (
        A      : in  std_logic_vector(N-1 downto 0);
        B      : in  std_logic_vector(N-1 downto 0);
        c     : in  std_logic;
        result  : out std_logic_vector(N-1 downto 0);
        ov  : out std_logic
    );
end entity sumOrDiff;

architecture rtl of sumOrDiff is
    signal b_xor : std_logic_vector(N-1 downto 0);
    signal carry : std_logic_vector(N downto 0);
begin
    carry(0) <= c;
    b_xor <= B xor (B'range => c);

    gen_fa : for i in 0 to N-1 generate
        fa_inst : entity work.full_adder
            port map (
                a    => A(i),
                b    => b_xor(i),
                cin  => carry(i),
                sum  => result(i),
                cout => carry(i+1)
            );
    end generate gen_fa;

    ov <= carry(N) xor carry(N-1);
end architecture rtl;
