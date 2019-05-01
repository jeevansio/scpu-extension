module add (a, b, c, g, p, s);
    input a, b, c;
    output g, p, s;
    assign s = a ^ b ^ c;
    assign g = a & b;
    assign p = a | b;
endmodule

module g_p (g, p, c_in, g_out, p_out, c_out);
    input [1:0] g, p;
    input c_in;
    output g_out, p_out, c_out;
    assign g_out = g[1] | p[1] & g[0];
    assign p_out = p[1] & p[0];
    assign c_out = g[0] | p[0] & c_in;
endmodule

module cla_2 (a, b, c_in, g_out, p_out, s);
    input [1:0] a, b;
    input c_in;
    output g_out, p_out;
    output [1:0] s;
    wire [1:0] g, p;
    wire c_out;
    add add0 (.a(a[0]), .b(b[0]), .c(c_in), .g(g[0]), .p(p[0]), .s(s[0]));
    add add1 (.a(a[1]), .b(b[1]), .c(c_out), .g(g[1]), .p(p[1]), .s(s[1]));
    g_p g_p0 (.g(g), .p(p), .c_in(c_in), .g_out(g_out), .p_out(p_out), .c_out(c_out));
endmodule

module cla_4 (a, b, c_in, g_out, p_out, s);
    input [3:0] a, b;
    input c_in;
    output g_out, p_out;
    output [3:0] s;
    wire [1:0] g, p;
    wire c_out;
    cla_2 cla0 (.a(a[1:0]), .b(b[1:0]), .c_in(c_in), .g_out(g[0]), .p_out(p[0]), .s(s[1:0]));
    cla_2 cla1 (.a(a[3:2]), .b(b[3:2]), .c_in(c_out), .g_out(g[1]), .p_out(p[1]), .s(s[3:2]));
    g_p g_p0 (.g(g), .p(p), .c_in(c_in), .g_out(g_out), .p_out(p_out), .c_out(c_out));
endmodule

module cla_8 (a, b, c_in, g_out, p_out, s);
    input [7:0] a, b;
    input c_in;
    output g_out, p_out;
    output [7:0] s;
    wire [1:0] g, p;
    wire c_out;
    cla_4 cla0 (.a(a[3:0]), .b(b[3:0]), .c_in(c_in), .g_out(g[0]), .p_out(p[0]), .s(s[3:0]));
    cla_4 cla1 (.a(a[7:4]), .b(b[7:4]), .c_in(c_out), .g_out(g[1]), .p_out(p[1]), .s(s[7:4]));
    g_p g_p0 (.g(g), .p(p), .c_in(c_in), .g_out(g_out), .p_out(p_out), .c_out(c_out));
endmodule

module cla_16 (a, b, c_in, g_out, p_out, s);
    input [15:0] a, b;
    input c_in;
    output g_out, p_out;
    output [15:0] s;
    wire [1:0] g, p;
    wire c_out;
    cla_8 cla0 (.a(a[7:0]), .b(b[7:0]), .c_in(c_in), .g_out(g[0]), .p_out(p[0]), .s(s[7:0]));
    cla_8 cla1 (.a(a[15:8]), .b(b[15:8]), .c_in(c_out), .g_out(g[1]), .p_out(p[1]), .s(s[15:8]));
    g_p g_p0 (.g(g), .p(p), .c_in(c_in), .g_out(g_out), .p_out(p_out), .c_out(c_out));
endmodule

module cla_32 (a, b, c_in, g_out, p_out, s);
    input [31:0] a, b;
    input c_in;
    output g_out, p_out;
    output [31:0] s;
    wire [1:0] g, p;
    wire c_out;
    cla_16 cla0 (.a(a[15:0]), .b(b[15:0]), .c_in(c_in), .g_out(g[0]), .p_out(p[0]), .s(s[15:0]));
    cla_16 cla1 (.a(a[31:16]), .b(b[31:16]), .c_in(c_out), .g_out(g[1]), .p_out(p[1]), .s(s[31:16]));
    g_p g_p0 (.g(g), .p(p), .c_in(c_in), .g_out(g_out), .p_out(p_out), .c_out(c_out));
endmodule

module cla32 (a, b, ci, s);
    input [31:0] a, b;
    input ci;
    output [31:0] s;
    wire co;
    wire g_out, p_out;
    cla_32 cla (.a(a), .b(b), .c_in(ci), .g_out(g_out), .p_out(p_out), .s(s));
    assign co = g_out | p_out & ci;
endmodule