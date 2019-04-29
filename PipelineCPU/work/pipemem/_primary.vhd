library verilog;
use verilog.vl_types.all;
entity pipemem is
    port(
        we              : in     vl_logic;
        addr            : in     vl_logic_vector(31 downto 0);
        datain          : in     vl_logic_vector(31 downto 0);
        clk             : in     vl_logic;
        inclk           : in     vl_logic;
        outclk          : in     vl_logic;
        dataout         : out    vl_logic_vector(31 downto 0)
    );
end pipemem;
