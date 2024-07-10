// Testbench for 1-bit full adder

module fulladder_tb();
// Declare testbench variables
//    Interface of DUT
//    Variables for verification
reg a, b, cin;
wire cout, sum;
reg clk;
integer file_rd, file_wr, cnt; // File IO
reg [2:0] buf_in;

// Instantiate and connect DUT
fulladder dut(.a(a), .b(b), .cin(cin), .cout(cout), .sum(sum));

initial begin
    // Dump waveform
    $fsdbDumpfile("top.fsdb");
    $fsdbDumpvars;

    // File I/O
    file_rd = $fopen("testcases/all/input.txt", "r");
    file_wr = $fopen("testcases/all/output.txt", "w");
    $display("Test start\n");

    // Generate test signals, exhaustive all possible inputs
    while(!$feof(file_rd)) begin
        cnt = $fscanf(file_rd,"%b",buf_in);
        {a, b, cin} = buf_in;
        #10;
    end

    // Close file IO
    $fclose(file_rd);
    $fclose(file_wr);

end

always @(a or b or cin) begin
    // Verification: print on scream
    #5;
    $fwrite(file_wr, "%b%b\n", sum, cout); // Write to output file
end


endmodule
