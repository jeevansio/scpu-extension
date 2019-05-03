module pipecpu (clk, rst, instr, readdata, PC, MemWrite, aluout, writedata, reg_sel, reg_data);
         
    input      	 clk;
    input      	 rst;
    input [31:0]  instr;
    input [31:0]  readdata;
    input [4:0]   reg_sel;
   
    output [31:0] PC;
    output        MemWrite;
    output [31:0] aluout;
    output [31:0] writedata;
    output [31:0] reg_data;

	
	wire [31:0] bpc, jpc, npc, pc4, dpc4, inst, da, db, dimm, ea, eb, eimm; 
    wire [31:0] epc4, wmo, wdi;
    wire [4:0]  drn, ern0, ern, mrn, wrn;
    wire [3:0]  daluc, ealuc; // daluc = aluc 
    wire [1:0]  pcsource;
    wire        wpcir; 
    wire        dwreg, dm2reg, dwmem, daluimm, dshift, djal; 
    wire        ewreg, em2reg, ewmem, ealuimm, eshift, ejal;
    wire        mwreg, mm2reg; 
    wire        wwreg, wm2reg;
	wire [31:0] walu, ealu;

    pipepc prog_cnt (npc, wpcir, clk, rst, PC); 
	
    pipeif if_stage (pcsource, PC, bpc, da, jpc, npc, pc4);
	
    pipeir inst_reg (pc4, instr, wpcir, clk, rst, dpc4, inst); 
    
    pipeid id_stage (reg_sel, reg_data, wdi, wrn, wwreg, mwreg, mrn, ern, ewreg, em2reg, mm2reg, dpc4, inst,
                    ealu, aluout, readdata, clk, rst, 
                    bpc, jpc, pcsource, wpcir, dwreg, dm2reg, dwmem, 
                    daluc, daluimm, da, db, dimm, drn, dshift, djal); 
	
    pipedereg de_reg (dwreg, dm2reg, dwmem, daluc, daluimm, da, db, dimm, 
                     drn, dshift, djal, dpc4, clk, rst, 
                     ewreg, em2reg, ewmem, ealuc, ealuimm, ea, eb, eimm, 
                     ern0, eshift, ejal, epc4); 
	
    pipeexe exe_stage (ealuc, ealuimm, ea, eb, eimm, eshift,ern0, epc4, 
                      ejal, ern, ealu); 
	
    pipeemreg em_reg (ewreg, em2reg, ewmem, ealu, eb, ern, clk, rst,
                     mwreg, mm2reg, MemWrite, aluout, writedata, mrn); 
	
    pipemwreg mw_reg (mwreg, mm2reg, readdata, aluout, mrn, clk, rst, 
                      wwreg, wm2reg, wmo, walu, wrn);
	
    mux2 #(32) wb_stage (walu, wmo, wm2reg, wdi);
	
endmodule
 
