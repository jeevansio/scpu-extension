module regfile (rna, rnb, d, wn, we, clk, clrn, qa, qb);
    input [4:0] rna, rnb, wn;
    input [31:0] d;
    input we, clk, clrn;
    output [31:0] qa, qb;
    reg [31:0] register [1:31];
    integer i;
    assign qa = (rna == 0) ? 0 : register [rna];
    assign qb = (rnb == 0) ? 0 : register [rnb];

    always @(posedge clk or posedge clrn)
        if (clrn == 1) begin
            for (i = 1; i < 32; i = i+1)
                register[i] <= 0;
        end else if ((wn != 0) && we) begin
                register[wn] <= d;
                $display("r[%2d] = 0x%8X,", wn, d);
        end

endmodule