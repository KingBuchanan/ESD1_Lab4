-- Written by Gregg Guarino, Ph.D.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity peripheral_on_external_bus is
  port (
    clk           : in  std_logic;
    reset_n       : in  std_logic;
    i_address     : in  std_logic_vector (10 downto 0);
    i_addressWave : in  std_logic_vector (7 downto 0);
    i_bus_enable  : in  std_logic;
    i_byte_enable : in  std_logic_vector (3 downto 0);
    i_rw_n        : in  std_logic;
    i_write_data  : in  std_logic_vector (31 downto 0);
    o_acknowledge : out std_logic;
    o_read_data   : out std_logic_vector (31 downto 0);
    o_wave_data   : out std_logic_vector (31 downto 0)
  );
end entity peripheral_on_external_bus;

architecture peripheral_on_external_bus_arch of peripheral_on_external_bus is
signal  wren_it :STD_LOGIC;
component  Dual_Port_Ram is  
port (
		address_a		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		address_b		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock		    : IN STD_LOGIC  := '1';
		data_a		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren_a		: IN STD_LOGIC  := '0';
		wren_b		: IN STD_LOGIC  := '0';
		q_a		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		q_b		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);

end component;

begin
process(i_bus_enable) 
begin
if rising_edge(clk) then 
  if (i_bus_enable='1') then
	o_acknowledge<='1';
	elsif (i_bus_enable='0') then 
	o_acknowledge<='0';
	end if;
	end if;
	
end process; 


 wren_it<= (not i_rw_n) and i_bus_enable; 
 Dual_Port_Ram_inst : Dual_Port_Ram PORT MAP (
		address_a	 => '0'&i_address(10 downto 2),
		address_b	 => "00"&i_addressWave ,
		clock	 => clk,
		data_a	 => i_write_data ,                          --write data 
		data_b	 => i_write_data, 									--write data 
		wren_a	 => wren_it,
		q_a	 => o_read_data,											--output what's being read
		q_b	 => o_wave_data 												-- output what's being read
	);


end peripheral_on_external_bus_arch;