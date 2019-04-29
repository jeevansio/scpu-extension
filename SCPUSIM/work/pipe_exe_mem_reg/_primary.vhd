library verilog;
use verilog.vl_types.all;
entity pipe_exe_mem_reg is
    port(
        ewreg           : in     vl_logic;
        em2reg          : in     vl_logic;
        ewmem           : in     vl_logic;
        ealu            : in     vl_logic_vector(31 downto 0);
        eb              : in     vl_logic_vector(31 downto 0);
        ern             : in     vl_logic_vector(4 downto 0);
        clk             : in     vl_logic;
        clrn            : in     vl_logic;
        mwreg           : out    vl_logic;
        mm2reg          : out    vl_logic;
        mwmem           : out    vl_logic;
        malu            : out    vl_logic_vector(31 downto 0);
        mb              : out    vl_logic_vector(31 downto 0);
        mrn             : out    vl_logic_vector(4 downto 0)
    );
end pipe_exe_mem_reg;
