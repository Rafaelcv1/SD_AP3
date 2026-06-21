library ieee;
use ieee.std_logic_1164.all;

entity multi2x2 is
    port (
        A, B: in std_logic_vector(1 downto 0);
        result: out std_logic_vector(3 downto 0)
    );
end entity multi2x2;

architecture RTL of multi2x2 is
begin
    result(0) <= A(0) and B(0);
    result(1) <= (A(0) and B(1)) xor (A(1) and B(0));
    result(2) <= (A(1) and B(1)) xor ((A(0) and B(1)) and (A(1) and B(0)));
    result(3) <= (A(1) and B(1)) and ((A(0) and B(1)) and (A(1) and B(0)));
end architecture RTL;