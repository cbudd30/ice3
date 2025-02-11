--+----------------------------------------------------------------------------
--| 
--| DESCRIPTION   : This file implements the top level module for a BASYS 
--|
--|     Ripple-Carry Adder: S = A + B
--|
--|     Our **user** will input the following:
--|
--|     - $C_{in}$ on switch 0
--|     - $A$ on switches 4-1
--|     - $B$ on switches 15-12
--|
--|     Our **user** will expect the following outputs:
--|
--|     - $Sum$ on LED 3-0
--|     - $C_{out} on LED 15
--|
--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
	port(
	       A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Cin : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (3 downto 0);
           Cout : out STD_LOGIC;
	
		-- Switches
		sw		:	in  std_logic_vector(15 downto 0);
		
		-- LEDs
		led	    :	out	std_logic_vector(15 downto 0)
	);
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
	
    -- declare the component of your top-level design
    component full_adder  is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC; 
           Cin : in STD_LOGIC;
           S : out STD_LOGIC;
           Cout : out STD_LOGIC
       );
   end component full_adder;

    -- declare any signals you will need
      signal w_carry  : STD_LOGIC_VECTOR(3 downto 0);

  
begin
	-- PORT MAPS --------------------
    full_adder_0: full_adder
    port map(
    A => sw(1),
    B => sw(12),
    Cin => sw(0), 
    S => led(0), 
    Cout => w_carry(0)
    );

    full_adder_1: full_adder
    port map(
        A => sw(2),
        B => sw(13),
        Cin => w_carry(0), 
        S => led(1), 
        Cout => w_carry(1)
    );
    
   full_adder_2: full_adder
    port map(
        A    => sw(3),
        B    => sw(14),
        Cin   => w_carry(1),   -- Directly to input here
        S     => led(2),
        Cout  => w_carry(2)
    );
    
    full_adder_3: full_adder
    port map(
        A    => sw(4),
        B     => sw(15),
        Cin   => w_carry(2),   -- Directly to input here
        S     => led(3),
        Cout  => led(15)
    );
	---------------------------------
	
	-- CONCURRENT STATEMENTS --------
	led(14 downto 4) <= (others => '0'); -- Ground unused LEDs
	---------------------------------
end top_basys3_arch;
