library ieee;
use ieee.std_logic_1164.all;

entity mux8to1 is
    generic (
        N : positive := 32
    );
    port (
        in0, in1, in2, in3, in4, in5, in6, in7: in std_logic_vector(N-1 downto 0);

        output: out std_logic_vector(N-1 downto 0);

        sel: in std_logic_vector(2 downto 0)
    );
end entity mux8to1;

architecture RTL of mux8to1 is    
begin
    output <= in0 when sel = "000" else
                in1 when sel = "001" else
                in2 when sel = "010" else
                in3 when sel = "011" else
                in4 when sel = "100" else
                in5 when sel = "101" else
                in6 when sel = "110" else
                in7 when sel = "111" else
                (others => '0');
end architecture RTL;
