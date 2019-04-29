library verilog;
use verilog.vl_types.all;
entity pipeimem is
    port(
        a               : in     vl_logic_vector(31 downto 0);
        inst            : out    vl_logic_vector(31 downto 0)
    );
end pipeimem;
