module pipelinedcpu (clock, resetn, instr, mmo, PC, mwmem,
                    malu, mb, reg_sel, reg_data);
                    // clk, rst, instr, readdata, PC, MemWrite,
                    // aluout, writedata, reg_sel, reg_data

    input clock, resetn;
    input [31:0]  instr;     // instruction
    input [31:0]  mmo;       // readdata: data from data memory
   
    output [31:0] pc;        // PC address
    output        mwmem;     // MemWrite: memory write
    output [31:0] malu;      // aluout: ALU output
    output [31:0] mb;        // writedata: data to data memory
   
    input  [4:0] reg_sel;    // register selection (for debug use)
    output [31:0] reg_data;  // selected register data (for debug use)
    
    wire [31:0] ealu, walu;
    
    wire [31:0] bpc, jpc, npc, pc4, dpc4, inst, da, db, dimm, ea, eb, eimm;
    wire [31:0] epc4, mb, mmo, wmo, wdi;
    wire [4:0]  drn, ern0, ern, mrn, wrn;
    wire [3:0]  daluc, ealuc;       // daluc = aluc;
    wire [1:0]  pcsource;
    wire        wpcir;
    wire        dwreg, dm2reg, dwmem, daluimm, dshift, djal;
    wire        ewreg, em2reg, ewmem, ealuimm, eshift, ejal;
    wire        mwreg, mm2reg, mwmem;
    wire        wwreg, wm2reg;

    pipepc prog_cnt (npc, wpcir, clock, resetn, pc);
    pipeif if_stage (pcsource, pc, bpc, da, jpc, npc, pc4);
    pipeir inst_reg (pc4, ins, wpcir, clock, resetn, dpc4, inst);
    pipeid id_stage (mwreg, mrn, ern, ewreg, em2reg, mm2reg, dpc4, inst, 
                     wrn, wdi, ealu, malu, mmo, wwreg, clock, resetn,
                     bpc, jpc, pcsource, wpcir, dwreg, dm2reg, dwmem, 
                     daluc, daluimm, da, db, dimm, drn, dshift, djal);
    pipedereg de_reg (dwreg, dm2reg, dwmem, daluc, daluimm, da, db, dimm,
                      drn, dshift, djal, dpc4, clock, resetn, 
                      ewreg, em2reg, ewmem, ealuc, ealuimm, ea, eb, eimm,
                      ern0, eshift, ejal, epc4);
    pipeexe exe_stage (ealuc, ealuimm, ea, eb, eimm, eshift, ern0, epc4, ejal, ern, ealu);
    pipeemreg em_reg  (ewreg, em2reg, ewmem, ealu, eb, ern, clock, resetn, 
                       mwreg, mm2reg, mwmem, malu, mb, mrn);
    //pipemem mem_stage (mwmem, malu, mb, clock, memclock, memclock, mmo);
    pipemwreg mw_stage(mwreg, mm2reg, mmo, malu, mrn, clock, resetn,
                       wwreg, wm2reg, wmo, walu, wrn);
    mux2 wb_stage (walu, wmo, wm2reg, wdi);

endmodule