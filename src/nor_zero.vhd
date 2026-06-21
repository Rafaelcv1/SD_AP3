library ieee;
use ieee.std_logic_1164.all;

entity nor_zero is
    generic (
        N : positive := 32
    );
    port (
        A : in std_logic_vector(N-1 downto 0);
        zero : out std_logic
    );
end entity nor_zero;

architecture rtl of nor_zero is
begin
    zero <= '1' when A = (A'length => '0') else '0';
end architecture rtl;
