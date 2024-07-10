

module fulladder (input a, input b, input cin, output cout, output sum);

    assign cout = (a & b) | (a & cin) | (b & cin);
    assign sum = a ^ b ^ cin;

endmodule
