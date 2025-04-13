library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_PortComp is
end tb_PortComp;

architecture Behavioral of tb_PortComp is

    -- Signali за повезивање са UUT (Unit Under Test)
    signal clk    : std_logic := '0';
    signal data   : std_logic_vector(11999 downto 0) := (others => '0');
    signal result : std_logic;

    constant clk_period : time := 10 ns;

begin

    -- Инстанцирање јединице коју тестирамо
    uut: entity work.PortComp
        port map (
            clk    => clk,
            data   => data,
            result => result
        );

    -- Генератор сата
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Стимулациони процес
   
stim_proc: process 
    variable temp_data   : std_logic_vector(11999 downto 0);
    variable porti_val   : std_logic_vector(15 downto 0);
    variable eth_val     : std_logic_vector(15 downto 0);
    variable mac_val     : std_logic_vector(47 downto 0);
    variable ip_val      : std_logic_vector(31 downto 0);
    variable proto_val   : std_logic_vector(7 downto 0);
begin


    ----------------------------------------------------------------------
    -- Тест 1: Све валидно -> result = '1'
    ----------------------------------------------------------------------
    temp_data := (others => '0');
    porti_val := std_logic_vector(to_unsigned(1025, 16));
    eth_val   := x"0800";
    mac_val   := (others => '0');
    ip_val    := "00000000111111110000000011110000";
    proto_val := "00000110";

    temp_data(287 downto 280) := porti_val(7 downto 0);
    temp_data(279 downto 272) := porti_val(15 downto 8);
    temp_data(111 downto 104) := eth_val(7 downto 0);
    temp_data(103 downto 96)  := eth_val(15 downto 8);
    temp_data(87 downto 40)   := mac_val;
    temp_data(239 downto 208) := ip_val;
    temp_data(191 downto 184) := proto_val;

    data <= temp_data;
    wait for clk_period;

    ----------------------------------------------------------------------
    -- Тест 2: Порт < 1024 -> result = '0'
    ----------------------------------------------------------------------
    temp_data := data;
    porti_val := std_logic_vector(to_unsigned(80, 16));
    temp_data(287 downto 280) := porti_val(7 downto 0);
    temp_data(279 downto 272) := porti_val(15 downto 8);
    data <= temp_data;
    wait for clk_period;

    ----------------------------------------------------------------------
    -- Тест 3: Погрешан EtherType -> result = '0'
    ----------------------------------------------------------------------
    temp_data := data;
    porti_val := std_logic_vector(to_unsigned(1025, 16));
    eth_val := x"1234";
    temp_data(287 downto 280) := porti_val(7 downto 0);
    temp_data(279 downto 272) := porti_val(15 downto 8);
    temp_data(111 downto 104) := eth_val(7 downto 0);
    temp_data(103 downto 96)  := eth_val(15 downto 8);
    data <= temp_data;
    wait for clk_period;

    ----------------------------------------------------------------------
    -- Тест 4: Broadcast MAC -> result = '0'
    ----------------------------------------------------------------------
    temp_data := data;
    mac_val := (others => '1');
    temp_data(87 downto 40) := mac_val;
    data <= temp_data;
    wait for clk_period;

    ----------------------------------------------------------------------
    -- Тест 5: Блокирајућа IP -> result = '0'
    ----------------------------------------------------------------------
    temp_data := data;
    mac_val := (others => '0');
    ip_val := "11000000101010000000001111111111";
    temp_data(87 downto 40) := mac_val;
    temp_data(239 downto 208) := ip_val;
    data <= temp_data;
    wait for clk_period;

    ----------------------------------------------------------------------
    -- Тест 6: Лош протокол -> result = '0'
    ----------------------------------------------------------------------
    temp_data := data;
    proto_val := "11110000";
    temp_data(191 downto 184) := proto_val;
    data <= temp_data;
    wait for clk_period;

    wait;
end process;
end Behavioral;
