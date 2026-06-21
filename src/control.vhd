library ieee;
use ieee.std_logic_1164.all;

entity control is
    port (
        operation: in std_logic_vector(2 downto 0);
        clk, start, reset : in std_logic;
        done, overflow : out std_logic;

        ov : in std_logic;
        multi_reg, reg_result: out std_logic;
        c: out std_logic_vector(2 downto 0)
    );
end entity control;

architecture RTL of control is
    type State_Type is (S0, S_OR, S_AND, S_NOR, S_XOR, S_ADD, S_SUB, S_SLT, S_MULT1, S_MULT2, S_Reg_mult, S_DONE, S_ERROR);
    signal state, next_state: State_Type;

begin
    CLK_PROC: process(clk, reset)
    begin
        if reset = '1' then
            state <= S0;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process CLK_PROC;

    NEXT_STATE_PROC: process(state, operation, start, ov, reset)
    begin
        case state is
            when S0 =>
                if reset = '1' then
                    next_state <= S0;
                elsif start = '1' then
                    case operation is
                        when "000" => next_state <= S_OR;
                        when "001" => next_state <= S_AND;
                        when "010" => next_state <= S_NOR;
                        when "011" => next_state <= S_XOR;
                        when "100" => next_state <= S_ADD;
                        when "101" => next_state <= S_SUB;
                        when "110" => next_state <= S_MULT1;
                        when "111" => next_state <= S_SLT;
                        when others => next_state <= S_ERROR;
                    end case;
                else
                    next_state <= S0;
                end if;
            when S_OR | S_AND | S_NOR | S_XOR | S_SLT =>
                next_state <= S_DONE;
            when S_ADD =>
                if ov = '1' then
                    next_state <= S_ERROR;
                else
                    next_state <= S_DONE;
                end if;
            when S_SUB =>
                if ov = '1' then
                    next_state <= S_ERROR;
                else
                    next_state <= S_DONE;
                end if;
            when S_MULT1 =>
                next_state <= S_MULT2;
            when S_MULT2 =>
                if ov = '1' then
                    next_state <= S_ERROR;
                else
                    next_state <= S_Reg_mult;
                end if;
            when S_Reg_mult =>
                next_state <= S_DONE;
            when S_DONE =>
                if reset = '1' then
                    next_state <= S0;
                else
                    next_state <= S_DONE;
                end if;
            when S_ERROR =>
                if reset = '1' then
                    next_state <= S0;
                else
                    next_state <= S_ERROR;
                end if;
        end case;
    end process NEXT_STATE_PROC;

    OUTPUT_PROC: process(state)
    begin
        done <= '0';
        overflow <= '0';
        reg_result <= '0';
        multi_reg <= '0';
        case state is
            when S0 =>
                done <= '0';
                overflow <= '0';
            when S_OR | S_AND | S_NOR | S_XOR | S_SLT | S_ADD | S_SUB | S_MULT2 =>
                done <= '0';
                reg_result <= '1';
                overflow <= '0';
            when S_MULT1 =>
                done <= '0';
                multi_reg <= '1';
                overflow <= '0';
            when S_Reg_mult =>
                done <= '0';
                reg_result <= '1';
                overflow <= '0';
            when S_DONE =>
                done <= '1';
                overflow <= '0';
            when S_ERROR =>
                done <= '1';
                overflow <= '1';
        end case;
    end process OUTPUT_PROC;
    c <= operation;
end architecture RTL;
