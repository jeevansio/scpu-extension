library verilog;
use verilog.vl_types.all;
entity pipelinedcpu is
    port(
        clock           : in     vl_logic;
        resetn          : in     vl_logic;
        instr           : in     vl_logic_vector(31 downto 0);
        mmo             : in     vl_logic_vector(31 downto 0);
        pc              : out    vl_logic_vector(31 downto 0);
        mwmem           : out    vl_logic;
        malu            : out    vl_logic_vector(31 downto 0);
        mb              : out    vl_logic_vector(31 downto 0);
        reg_sel         : in     vl_logic_vector(4 downto 0);
        reg_data        : out    vl_logic_vector(31 downto 0)
    );
end pipelinedcpu;
