LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
ENTITY project_io IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC := '0';
        enable : IN STD_LOGIC :='1';
        done : OUT STD_LOGIC;
        in_read_enable : OUT STD_LOGIC := '0';
        in_index : OUT INTEGER;
        in_data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        out_write_enable : OUT STD_LOGIC := '0';
        out_index : OUT INTEGER;
        out_data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        in_buff_size : OUT INTEGER := 1;
        out_buff_size : OUT INTEGER := 1
    );
END ENTITY project_io;

ARCHITECTURE behavioural OF project_io IS
    SIGNAL temp_data : STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '1');
    SIGNAL done_s : STD_LOGIC := '0';
    SIGNAL state_s : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL data_signal : std_logic_vector(11999 downto 0) := (others => '0');
    SIGNAL result_signal : std_logic;
    signal i : integer:= 0;
    signal bol : integer :=0;
BEGIN

	uut : entity work.PortComp
	port map(
		clk => clk,
		data   => data_signal,
                result => result_signal,
		done   => done_s
	);

    PROCESS (clk, rst)
    BEGIN
        
        IF state_s /= "111" and rising_edge(clk) THEN
            IF  state_s = "000" THEN
                in_read_enable <= '1';
                out_write_enable <= '0';
                state_s <= "001";
            ELSIF state_s = "001" THEN
            	
            	if i<1500 then
            		
            	    if bol mod 2 = 1 then
            	        data_signal(i*8+7 downto i*8) <= in_data;
            		i<=i+1;
            		bol<=bol+1;
            	    else
            		bol<= bol+1;
            		in_index<=i;
            	    end if;
            	else
		        in_read_enable <= '0';
		        out_index <= 0;
		        i<=0;
		        bol<=0;
		        state_s <= "010";
		end if;
            ELSIF state_s = "010" THEN
                if done_s ='1' then
                     state_s <= "011";
                     out_write_enable <= '1';
                end if;
		
            ELSIF state_s = "011" THEN
            	if bol mod 2 =0 then
            		bol<=bol+1;
            		out_data <= (7 downto 1 => '0') & result_signal;
            		
            	else
                	out_index<=0;
                	state_s<="111";
		end if;
            
            ELSE
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE behavioural;
