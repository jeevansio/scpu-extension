library verilog;
use verilog.vl_types.all;
entity ctrl is
    port(
        Op              : in     vl_logic_vector(5 downto 0);
        Funct           : in     vl_logic_vector(5 downto 0);
        Zero            : in     vl_logic;
        RegWrite        : out    vl_logic;
        MemWrite        : out    vl_logic;
        EXTOp           : out    vl_logic;
        ALUOp           : out    vl_logic_vector(3 downto 0);
        NPCOp           : out    vl_logic_vector(1 downto 0);
        ALUSrc          : out    vl_logic;
        GPRSel          : out    vl_logic_vector(1 downto 0);
        WDSel           : out    vl_logic_vector(1 downto 0);
        ALUSrcA         : out    vl_logic_vector(1 downto 0);
        mwreg           : in     vl_logic;
        ewreg           : in     vl_logic;
        em2reg          : in     vl_logic;
        mm2reg          : in     vl_logic;
        mrn             : in     vl_logic_vector(4 downto 0);
        ern             : in     vl_logic_vector(4 downto 0);
        rs              : in     vl_logic_vector(4 downto 0);
        rt              : in     vl_logic_vector(4 downto 0);
        fwda            : out    vl_logic_vector(1 downto 0);
        fwdb            : out    vl_logic_vector(1 downto 0);
        nostall         : out    vl_logic
    );
end ctrl;
