-- a 16 bit barrel shifter that can perform
-- Shift right logical
-- Shift left logical

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY BARREL_SHIFTER_16 IS
    PORT (
        A    : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
        B    : IN  STD_LOGIC_VECTOR (3  DOWNTO 0);
        LEFT : IN  STD_LOGIC; -- 1 is reversal
        Y    : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END BARREL_SHIFTER_16;

ARCHITECTURE behavioural OF BARREL_SHIFTER_16 IS

    TYPE INPUTS IS ARRAY (INTEGER RANGE 0 TO 3) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL array_in : INPUTS;
    TYPE OUTPUTS IS ARRAY (INTEGER RANGE 0 TO 3) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL array_out : OUTPUTS;

    SIGNAL data_reversal_1_in  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL data_reversal_1_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL data_reversal_2_in  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL data_reversal_2_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    
BEGIN
    -- CREATE THE HARDWARE
    --FIRST AND LAST MUX ARRAYS ARE FOR REVERSAL
    BARREL_SHIFTER_16 : for i in 5 downto 0 generate
        TOP_REVERSAL : if i = 5 generate
            TRV : entity work.MUX_ARRAY GENERIC MAP (num => 16) PORT MAP
            ( 
                data_in => data_reversal_1_in, S => LEFT, data_out => data_reversal_1_out
            );
        end generate TOP_REVERSAL;
        BOTTOM_REVERSAL : if i = 0 generate
            BRV : entity work.MUX_ARRAY GENERIC MAP (num => 16) PORT MAP
            ( 
                data_in => data_reversal_2_in, S => LEFT, data_out => data_reversal_2_out
            );
        end generate BOTTOM_REVERSAL;
        MIDDLE : if i = 1 or i = 2 or i = 3 or i = 4 generate
            BS : entity work.MUX_ARRAY GENERIC MAP (num => 16) PORT MAP
            ( 
                data_in => array_in(i-1), S => B(i-1), data_out => array_out(i-1)
            );
        end generate MIDDLE;
    end generate BARREL_SHIFTER_16;

    -- WIRE THE SIGNALS
    data_reversal_1_in(0) <= A(15);
    data_reversal_1_in(1) <= A(0);
    data_reversal_1_in(2) <= A(14);
    data_reversal_1_in(3) <= A(1);
    data_reversal_1_in(4) <= A(13);
    data_reversal_1_in(5) <= A(2);
    data_reversal_1_in(6) <= A(12);
    data_reversal_1_in(7) <= A(3);
    data_reversal_1_in(8) <= A(11);
    data_reversal_1_in(9) <= A(4);
    data_reversal_1_in(10) <= A(10);
    data_reversal_1_in(11) <= A(5);
    data_reversal_1_in(12) <= A(9);
    data_reversal_1_in(13) <= A(6);
    data_reversal_1_in(14) <= A(8);
    data_reversal_1_in(15) <= A(7);
    data_reversal_1_in(16) <= A(7);
    data_reversal_1_in(17) <= A(8);
    data_reversal_1_in(18) <= A(6);
    data_reversal_1_in(19) <= A(9);
    data_reversal_1_in(20) <= A(5);
    data_reversal_1_in(21) <= A(10);
    data_reversal_1_in(22) <= A(4);
    data_reversal_1_in(23) <= A(11);
    data_reversal_1_in(24) <= A(3);
    data_reversal_1_in(25) <= A(12);
    data_reversal_1_in(26) <= A(2);
    data_reversal_1_in(27) <= A(13);
    data_reversal_1_in(28) <= A(1);
    data_reversal_1_in(29) <= A(14);
    data_reversal_1_in(30) <= A(0);
    data_reversal_1_in(31) <= A(15);  
    
    array_in(3)(0) <= data_reversal_1_out(8);
    array_in(3)(1) <= data_reversal_1_out(0);
    array_in(3)(2) <= data_reversal_1_out(9);
    array_in(3)(3) <= data_reversal_1_out(1);
    array_in(3)(4) <= data_reversal_1_out(10);
    array_in(3)(5) <= data_reversal_1_out(2);
    array_in(3)(6) <= data_reversal_1_out(11);
    array_in(3)(7) <= data_reversal_1_out(3);
    array_in(3)(8) <= data_reversal_1_out(12);
    array_in(3)(9) <= data_reversal_1_out(4);
    array_in(3)(10) <= data_reversal_1_out(13);
    array_in(3)(11) <= data_reversal_1_out(5);
    array_in(3)(12) <= data_reversal_1_out(14);
    array_in(3)(13) <= data_reversal_1_out(6);
    array_in(3)(14) <= data_reversal_1_out(15);
    array_in(3)(15) <= data_reversal_1_out(7);
    array_in(3)(16) <= '0';
    array_in(3)(17) <= data_reversal_1_out(8);
    array_in(3)(18) <= '0';
    array_in(3)(19) <= data_reversal_1_out(9);
    array_in(3)(20) <= '0';
    array_in(3)(21) <= data_reversal_1_out(10);
    array_in(3)(22) <= '0';
    array_in(3)(23) <= data_reversal_1_out(11);
    array_in(3)(24) <= '0';
    array_in(3)(25) <= data_reversal_1_out(12);
    array_in(3)(26) <= '0';
    array_in(3)(27) <= data_reversal_1_out(13);
    array_in(3)(28) <= '0';
    array_in(3)(29) <= data_reversal_1_out(14);
    array_in(3)(30) <= '0';
    array_in(3)(31) <= data_reversal_1_out(15) ;

    array_in(2)(0) <= array_out(3)(4);
    array_in(2)(1) <= array_out(3)(0);
    array_in(2)(2) <= array_out(3)(5);
    array_in(2)(3) <= array_out(3)(1);
    array_in(2)(4) <= array_out(3)(6);
    array_in(2)(5) <= array_out(3)(2);
    array_in(2)(6) <= array_out(3)(7);
    array_in(2)(7) <= array_out(3)(3);
    array_in(2)(8) <= array_out(3)(8);
    array_in(2)(9) <= array_out(3)(4);
    array_in(2)(10) <= array_out(3)(9);
    array_in(2)(11) <= array_out(3)(5);
    array_in(2)(12) <= array_out(3)(10);
    array_in(2)(13) <= array_out(3)(6);
    array_in(2)(14) <= array_out(3)(11);
    array_in(2)(15) <= array_out(3)(7);
    array_in(2)(16) <= array_out(3)(12);
    array_in(2)(17) <= array_out(3)(8);
    array_in(2)(18) <= array_out(3)(13);
    array_in(2)(19) <= array_out(3)(9);
    array_in(2)(20) <= array_out(3)(14);
    array_in(2)(21) <= array_out(3)(10);
    array_in(2)(22) <= array_out(3)(15);
    array_in(2)(23) <= array_out(3)(11);
    array_in(2)(24) <= '0';
    array_in(2)(25) <= array_out(3)(12);
    array_in(2)(26) <= '0';
    array_in(2)(27) <= array_out(3)(13);
    array_in(2)(28) <= '0';
    array_in(2)(29) <= array_out(3)(14);
    array_in(2)(30) <= '0';
    array_in(2)(31) <= array_out(3)(15);

    array_in(1)(0) <= array_out(2)(2);
    array_in(1)(1) <= array_out(2)(0);
    array_in(1)(2) <= array_out(2)(3);
    array_in(1)(3) <= array_out(2)(1);
    array_in(1)(4) <= array_out(2)(4);
    array_in(1)(5) <= array_out(2)(2);
    array_in(1)(6) <= array_out(2)(5);
    array_in(1)(7) <= array_out(2)(3);
    array_in(1)(8) <= array_out(2)(6);
    array_in(1)(9) <= array_out(2)(4);
    array_in(1)(10) <= array_out(2)(7);
    array_in(1)(11) <= array_out(2)(5);
    array_in(1)(12) <= array_out(2)(8);
    array_in(1)(13) <= array_out(2)(6);
    array_in(1)(14) <= array_out(2)(9);
    array_in(1)(15) <= array_out(2)(7);
    array_in(1)(16) <= array_out(2)(10);
    array_in(1)(17) <= array_out(2)(8);
    array_in(1)(18) <= array_out(2)(11);
    array_in(1)(19) <= array_out(2)(9);
    array_in(1)(20) <= array_out(2)(12);
    array_in(1)(21) <= array_out(2)(10);
    array_in(1)(22) <= array_out(2)(13);
    array_in(1)(23) <= array_out(2)(11);
    array_in(1)(24) <= array_out(2)(14);
    array_in(1)(25) <= array_out(2)(12);
    array_in(1)(26) <= array_out(2)(15);
    array_in(1)(27) <= array_out(2)(13);
    array_in(1)(28) <= '0';
    array_in(1)(29) <=  array_out(2)(14);
    array_in(1)(30) <= '0';
    array_in(1)(31) <= array_out(2)(15);

    array_in(0)(0) <= array_out(1)(1);
    array_in(0)(1) <= array_out(1)(0);
    array_in(0)(2) <= array_out(1)(2);
    array_in(0)(3) <= array_out(1)(1);
    array_in(0)(4) <= array_out(1)(3);
    array_in(0)(5) <= array_out(1)(2);
    array_in(0)(6) <= array_out(1)(4);
    array_in(0)(7) <= array_out(1)(3);
    array_in(0)(8) <= array_out(1)(5);
    array_in(0)(9) <= array_out(1)(4);
    array_in(0)(10) <= array_out(1)(6);
    array_in(0)(11) <= array_out(1)(5);
    array_in(0)(12) <= array_out(1)(7);
    array_in(0)(13) <= array_out(1)(6);
    array_in(0)(14) <= array_out(1)(8);
    array_in(0)(15) <= array_out(1)(7);
    array_in(0)(16) <= array_out(1)(9);
    array_in(0)(17) <= array_out(1)(8);
    array_in(0)(18) <= array_out(1)(10);
    array_in(0)(19) <= array_out(1)(9);
    array_in(0)(20) <= array_out(1)(11);
    array_in(0)(21) <= array_out(1)(10);
    array_in(0)(22) <= array_out(1)(12);
    array_in(0)(23) <= array_out(1)(11);
    array_in(0)(24) <= array_out(1)(13);
    array_in(0)(25) <= array_out(1)(12);
    array_in(0)(26) <= array_out(1)(14);
    array_in(0)(27) <= array_out(1)(13);
    array_in(0)(28) <= array_out(1)(15); 
    array_in(0)(29) <= array_out(1)(14);
    array_in(0)(30) <= '0';
    array_in(0)(31) <= array_out(1)(15);

    data_reversal_2_in(0) <= array_out(0)(15);
    data_reversal_2_in(1) <= array_out(0)(0);
    data_reversal_2_in(2) <= array_out(0)(14);
    data_reversal_2_in(3) <= array_out(0)(1);
    data_reversal_2_in(4) <= array_out(0)(13);
    data_reversal_2_in(5) <= array_out(0)(2);
    data_reversal_2_in(6) <= array_out(0)(12);
    data_reversal_2_in(7) <= array_out(0)(3);
    data_reversal_2_in(8) <= array_out(0)(11);
    data_reversal_2_in(9) <= array_out(0)(4);
    data_reversal_2_in(10) <= array_out(0)(10);
    data_reversal_2_in(11) <= array_out(0)(5);
    data_reversal_2_in(12) <= array_out(0)(9);
    data_reversal_2_in(13) <= array_out(0)(6);
    data_reversal_2_in(14) <= array_out(0)(8);
    data_reversal_2_in(15) <= array_out(0)(7);
    data_reversal_2_in(16) <= array_out(0)(7);
    data_reversal_2_in(17) <= array_out(0)(8);
    data_reversal_2_in(18) <= array_out(0)(6);
    data_reversal_2_in(19) <= array_out(0)(9);
    data_reversal_2_in(20) <= array_out(0)(5);
    data_reversal_2_in(21) <= array_out(0)(10);
    data_reversal_2_in(22) <= array_out(0)(4);
    data_reversal_2_in(23) <= array_out(0)(11);
    data_reversal_2_in(24) <= array_out(0)(3);
    data_reversal_2_in(25) <= array_out(0)(12);
    data_reversal_2_in(26) <= array_out(0)(2);
    data_reversal_2_in(27) <= array_out(0)(13);
    data_reversal_2_in(28) <= array_out(0)(1);
    data_reversal_2_in(29) <= array_out(0)(14);
    data_reversal_2_in(30) <= array_out(0)(0);
    data_reversal_2_in(31) <= array_out(0)(15); 
    
    Y <= data_reversal_2_out;

END behavioural;