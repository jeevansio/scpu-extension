module sccpu(clk, rst, instr, readdata, PC, MemWrite, aluout, writedata, reg_sel, reg_data,
             ealu, malu, walu);
         
   input      clk;          // clock
   input      rst;          // reset
   
   input [31:0]  instr;     // instruction
   input [31:0]  readdata;  // data from data memory
   
   output [31:0] PC;        // PC address
   output        MemWrite;  // memory write
   output [31:0] aluout;    // ALU output
   output [31:0] writedata; // data to data memory
   
   input  [4:0] reg_sel;    // register selection (for debug use)
   output [31:0] reg_data;  // selected register data (for debug use)
   
   wire        RegWrite;    // control signal to register write
   wire        EXTOp;       // control signal to signed extension
   wire [3:0]  ALUOp;       // ALU opertion
   wire [1:0]  NPCOp;       // next PC operation

   wire [1:0]  WDSel;       // (register) write data selection
   wire [1:0]  GPRSel;      // general purpose register selection
   
   wire        ALUSrc;      // ALU source for A actually it is B
   wire [1:0]  ALUSrcA;     // ALU source for A i mean real A
   wire        Zero;        // ALU ouput zero

   wire [31:0] NPC;         // next PC

   wire [4:0]  rs;          // rs
   wire [4:0]  rt;          // rt
   wire [4:0]  rd;          // rd
   wire [5:0]  Op;          // opcode
   wire [5:0]  Funct;       // funct
   wire [15:0] Imm16;       // 16-bit immediate
   wire [31:0] Imm32;       // 32-bit immediate
   wire [25:0] IMM;         // 26-bit immediate (address)
   wire [4:0]  A3;          // register address for write
   wire [31:0] WD;          // register write data
   wire [31:0] RD1;         // register data specified by rs
   wire [31:0] B;           // operator for ALU B
   wire [31:0] A;           // operator for ALU A
   wire [5:0]  sa;          // shamt
   wire [31:0] sa32;        // 32bit shamt
   wire [31:0] sa_from_rs;  // 32bit shamt from low 5 bits of rs
   
   assign Op = instr[31:26];  // instruction
   assign Funct = instr[5:0]; // funct
   assign rs = instr[25:21];  // rs
   assign rt = instr[20:16];  // rt
   assign rd = instr[15:11];  // rd
   assign Imm16 = instr[15:0];// 16-bit immediate
   assign IMM = instr[25:0];  // 26-bit immediate
   
   assign sa = instr[10:6];   // 5-bit shamt
   assign sa_from_rs = {27'b0, RD1[4:0]};
                              //32bit shamt from low 5 bits of rs

   assign sa32 = {27'b0, instr[10:6]};
                              //32 bit shamt

   
   output [31:0] ealu, malu, walu;

   wire [31:0] da, db, dimm, ea, eb, eimm;
   wire [31:0] nb, mmo, wmo;
   wire [4:0]  drn, ern0, ern, mrn, wrn;
   wire [3:0]  daluc, ealuc;
   wire [1:0]  fwda, fwdb;

   wire dwreg, dm2reg, dwmem, daluimm, dshift, djal;
   wire ewreg, em2reg, ewmem, ealuimm, eshift, ejal;
   wire mwreg, mm2reg, mwmem;
   wire wwreg, wm2reg;
   wire nostall;

   // instantiation of control unit
   ctrl U_CTRL ( 
      .Op(Op), .Funct(Funct), .Zero(Zero),
      .RegWrite(RegWrite), .MemWrite(MemWrite),
      .EXTOp(EXTOp), .ALUOp(ALUOp), .NPCOp(NPCOp), 
      .ALUSrc(ALUSrc), .GPRSel(GPRSel), .WDSel(WDSel),
      .ALUSrcA(ALUSrcA),
      .mwreg(mwreg), .ewreg(ewreg), .em2reg(em2reg), .mm2reg(mm2reg), 
      .mrn(mrn), .ern(ern), .rs(rs), .rt(rt),
      .fwda(fwda), .fwdb(fwdb), .nostall(nostall)
   );
   
   // instantiation of PC
   PC U_PC (
      .clk(clk), .rst(rst), .NPC(NPC), .PC(PC)
   ); 
   
   // instantiation of NPC
   NPC U_NPC ( 
      .PC(PC), .NPCOp(NPCOp), .IMM(IMM), .NPC(NPC), .RegSrc(RD1)
   );
   
   // instantiation of register file
   RF U_RF (
      .clk(clk), .rst(rst), .RFWr(RegWrite), 
      .A1(rs), .A2(rt), .A3(A3), 
      .WD(WD), 
      .RD1(RD1), .RD2(writedata),
      .reg_sel(reg_sel),
      .reg_data(reg_data) 
   );
   
   // mux for register data to write
   mux4 #(5) U_MUX4_GPR_A3 (
      .d0(rd), .d1(rt), .d2(5'b11111), .d3(5'b0), .s(GPRSel), .y(A3)
   );
   
   // mux for register address to write
   mux4 #(32) U_MUX4_GPR_WD (
      .d0(aluout), .d1(readdata), .d2(PC + 4), .d3(32'b0), .s(WDSel), .y(WD)
   );

   // mux for signed extension or zero extension
   EXT U_EXT ( 
      .Imm16(Imm16), .EXTOp(EXTOp), .Imm32(Imm32) 
   );
   
   // mux for ALU B
   mux2 #(32) U_MUX_ALU_B (
      .d0(writedata), .d1(Imm32), .s(ALUSrc), .y(B)
   );   
   
   // mux for alu a
   mux4 #(32) u_mux_alu_a (
      .d0(RD1), .d1(sa32), .d2(sa_from_rs), .d3(32'b0), .s(ALUSrcA), .y(A)
   );


   // instantiation of alu
   alu U_ALU ( 
      .A(A), .B(B), .ALUOp(ALUOp), .C(aluout), .Zero(Zero)
   );

   // pipeline register
   pipe_id_exe_reg pipedereg (
      .dwreg(dwreg), .dm2reg(dm2reg), .dwmem(dwmem), .daluc(daluc), .daluimm(daluimm), .da(da), .db(db),
      .dimm(dimm), .drn(drn), .dshift(dshift), .djal(djal), .dpc4(dpc4), .clk(clk), .clrn(rst), 
      .ewreg(ewreg), .em2reg(em2reg), .ewmem(ewmem), .ealuc(ealuc), .ealuimm(ealuimm), .ea(ea), .eb(eb),
      .eimm(eimm), .ern(ern), .eshift(eshift), .ejal(ejal), .epc4(epc4)
   );

   pipe_exe_mem_reg pipemreg (
      .ewreg(ewreg), .em2reg(em2reg), .ewmem(ewmem), .ealu(ealu), .eb(eb), .ern(ern), .clk(clk), .clrn(rst),
      .mwreg(mwreg), .mm2reg(mm2reg), .mwmem(mwmem), .malu(malu), .mb(mb), .mrn(mrn)
   );

   pipe_mem_wb_reg pipemwreg (
      .mwreg(mwreg), .mm2reg(mm2reg), .mmo(mmo), .malu(malu), .mrn(mrn), .clk(clk), .clrn(rst),
      .wwreg(wwreg), .wm2reg(wm2reg), .wmo(wmo), .walu(walu), .wrn(wrn)
   );
   

endmodule