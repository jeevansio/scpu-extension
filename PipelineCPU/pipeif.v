module pipeif (pcsource, pc, bpc, rpc, jpc, npc, pc4);

    input [31:0] pc, bpc, rpc, jpc;
    input [1:0]  pcsource;
    output [31:0] npc, pc4;

    mux4 next_pc (pc4, bpc, rpc, jpc, pcsource, npc);
    cla32 pc_plus4 (pc, 32'h4, 1'b0, pc4);
    //pipeimem inst_mem (pc, ins);

endmodule