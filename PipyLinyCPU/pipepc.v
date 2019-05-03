module pipepc(npc, wpc, clk, clrn, pc);

    input clk, wpc, clrn;
    input [31:0] npc;
    output [31:0] pc;
    dffe32 program_counter(npc, clk, clrn, wpc, pc);
  
endmodule