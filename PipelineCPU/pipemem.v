module pipemem (we, addr, datain,
                clk, inclk, outclk, dataout);

    input clk, we, inclk, outclk;

    input [31:0] addr, datain;
    output[31:0] dataout;

    wire write_enable = we & ~clk;

    lpm_ram_dq ram (.data(datain), .address(addr[6:2]), .we(write_enable), .inclock(inclk), .outclock(outclk), .q(dataout));

    defparam ram.lpm_width = 32;
    defparam ram.lpm_widthad = 5;
    defparam ram.indata  = "registered";
    defparam ram.outdata = "registered";
    defparam ram.lpm_file = "pipedmem.mif";
    defparam ram.lpm_address_control = "registered";

endmodule