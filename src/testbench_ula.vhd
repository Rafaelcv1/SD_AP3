library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop; -- Import the stop procedure

entity testbench_ula is
    generic (
        N : positive := 32
    );
end testbench_ula;

architecture Behavioral of testbench_ula is

    signal a, b : std_logic_vector(N - 1 downto 0);
    signal operation : std_logic_vector(2 downto 0);
    signal clk, start, reset : std_logic := '0';

    signal result : std_logic_vector(N - 1 downto 0);
    signal zero, overflow, done : std_logic;
begin
    -- Instancia da ULA
    ULA_inst : entity work.ULA
        generic map (N => N)
        port map (
        A => a,
        B => b,
        operation => operation,
        clk => clk,
        start => start,
        reset => reset,
        zero => zero,
        overflow => overflow,
        done => done,
        result => result
        );

    -- Processo de teste
    clock_process: process
        constant clock_period : time := 10 fs;
    begin
        -- Gerar clock
        while true loop
            clk <= '1';
            wait for clock_period / 2;
            clk <= '0';
            wait for clock_period / 2;
        end loop;
    end process clock_process;

    test_process: process
    begin
        -- 1. Pulso de Reset Inicial para acordar a FSM

        a <= "00000000000000001010011111010110"; -- (b10 = 42966)
        b <= "00000000000000001100001100111101"; -- (b10 = 49981)
        
        reset <= '1';
        wait for 10 fs;
        reset <= '0';

        -- =======================================
        -- Teste 1: OR
        -- =======================================
        start <= '1';
        operation <= "000"; 
        
        wait until done = '1';
        start <= '0';
        wait for 10 fs;
        reset <= '1'; -- Reset para a próxima operação
        wait for 10 fs;
        reset <= '0'; -- Desativa o reset para a próxima operação

        -- =======================================
        -- Teste 2: AND
        -- =======================================
        start <= '1';
        operation <= "001"; 
        
        wait until done = '1';
        start <= '0';
        wait for 10 fs;
        reset <= '1'; -- Reset para a próxima operação
        wait for 10 fs;
        reset <= '0'; -- Desativa o reset para a próxima operação

        -- =======================================
        -- Teste 3: NOR
        -- =======================================
        start <= '1';
        operation <= "010"; 
        
        wait until done = '1';
        start <= '0';
        wait for 10 fs;        
        reset <= '1'; -- Reset para a próxima operação
        wait for 10 fs;
        reset <= '0'; -- Desativa o reset para a próxima operação

        -- =======================================
        -- Teste 4: XOR
        -- =======================================
        start <= '1';
        operation <= "011"; 
        
        wait until done = '1';
        start <= '0';
        wait for 10 fs;
        reset <= '1'; -- Reset para a próxima operação
        wait for 10 fs;
        reset <= '0'; -- Desativa o reset para a próxima operação

        -- =======================================
        -- Teste 5: Addition (Expected Result = 92947)
        -- =======================================
        start <= '1';
        operation <= "100"; 

        wait until done = '1';
        start <= '0';
        wait for 10 fs;
        reset <= '1'; -- Reset para a próxima operação
        wait for 10 fs;
        reset <= '0'; -- Desativa o reset para a próxima operação

        -- =======================================
        -- Teste 6.1: Subtraction (Expected Result = -7015)
        -- =======================================
        start <= '1';
        operation <= "101"; 
        
        wait until done = '1';
        start <= '0';
        wait for 10 fs;
        reset <= '1'; -- Reset para a próxima operação
        wait for 10 fs;
        reset <= '0'; -- Desativa o reset para a próxima operação

        -- =======================================
        -- Teste 6.2: Subtraction (Expected Result = 7015)
        -- =======================================
        A <= "00000000000000001100001100111101"; -- (old b value)
        B <= "00000000000000001010011111010110"; -- (old a value)
        start <= '1';
        operation <= "101"; 
        
        wait until done = '1';
        start <= '0';
        wait for 10 fs;
        reset <= '1'; -- Reset para a próxima operação
        wait for 10 fs;
        reset <= '0'; -- Desativa o reset para a próxima operação

        -- =======================================
        -- Teste 7.1: Multiplication (Expected Result = overflow)
        -- =======================================
        start <= '1';
        operation <= "110";
        
        wait until done = '1';
        start <= '0';
        wait for 10 fs;
        reset <= '1'; -- Reset para a próxima operação
        wait for 10 fs;
        reset <= '0'; -- Desativa o reset para a próxima operação

        -- =======================================
        -- Teste 7.2: Multiplication (Expected Result = 4294967295 (2^32-1))
        -- =======================================
        a <= "00000000000000001111111111111111"; -- (b10 = 65535)
        b <= "00000000000000010000000000000001"; -- (b10 = 65537)
        start <= '1';
        operation <= "110"; 
        
        wait until done = '1';
        start <= '0';
        wait for 10 fs;
        reset <= '1'; -- Reset para a próxima operação
        wait for 10 fs;
        reset <= '0'; -- Desativa o reset para a próxima operação

        -- =======================================
        -- Teste 7.3: Multiplication (Expected Result = 8)
        -- =======================================
        a <= "00000000000000000000000000000100"; -- (b10 = 4)
        b <= "00000000000000000000000000000010"; -- (b10 = 2)

        start <= '1';
        operation <= "110"; 
        
        wait until done = '1';
        start <= '0';
        wait for 10 fs;
        reset <= '1'; -- Reset para a próxima operação
        wait for 10 fs;
        reset <= '0'; -- Desativa o reset para a próxima operação

        -- =======================================
        -- Teste 8.1: Set Less Than (Expected Result = 0)
        -- =======================================
        start <= '1';
        operation <= "111"; 
        
        wait until done = '1';
        start <= '0';
        wait for 10 fs;
        reset <= '1'; -- Reset para a próxima operação
        wait for 10 fs;
        reset <= '0'; -- Desativa o reset para a próxima operação

        -- =======================================
        -- Teste 8.2: Set Less Than (Expected Result = 0)
        -- =======================================
        a <= "00000000000000000000000000000000";
        b <= "10000000000000000000000000000000";

        start <= '1';
        operation <= "111"; 
        
        wait until done = '1';
        start <= '0';
        wait for 10 fs;
        reset <= '1'; -- Reset para a próxima operação
        wait for 10 fs;
        reset <= '0'; -- Desativa o reset para a próxima operação

        -- =======================================
        -- Teste 8.3: Set Less Than (Expected Result = 1)
        -- =======================================
        a <= "00000000000000000000000000000000";
        b <= "01000000000000000000000000000000";

        start <= '1';
        operation <= "111"; 
        
        wait until done = '1';
        start <= '0';
        wait for 10 fs;
        reset <= '1'; -- Reset para a próxima operação
        wait for 10 fs;
        reset <= '0'; -- Desativa o reset para a próxima operação

        -- =======================================
        -- Teste 8.4: Set Less Than (Expected Result = 0)
        -- =======================================
        a <= "00000000000000000000000000001000";
        b <= "00000000000000000000000000001000";

        start <= '1';
        operation <= "111"; 
        
        wait until done = '1';
        start <= '0';
        wait for 10 fs;
        reset <= '1'; -- Reset para a próxima operação
        wait for 10 fs;
        reset <= '0'; -- Desativa o reset para a próxima operação

        -- Fim da simulação
        stop;
        wait; -- Trava o processo para não repetir em loop
    end process test_process;

end Behavioral;
