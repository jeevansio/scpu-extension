library verilog;
use verilog.vl_types.all;
entity pipelinedcpu is
    port(
        clock           : in     vl_logic;
        memclock        : in     vl_logic;
        resetn          : in     vl_logic;
        pc              : out    vl_logic_vector(31 downto 0);
        inst            : out    vl_logic_vector(31 downto 0);
        ealu            : out    vl_logic_vector(31 downto 0);
        malu            : out    vl_logic_vector(31 downto 0);
        walu            : out    vl_logic_vector(31 downto 0)
    );
end pipelinedcpu;
