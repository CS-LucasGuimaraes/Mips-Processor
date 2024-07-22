`timescale 1ps/1ps

module tb_ALU();

    // Signals
    reg [2:0] ALUcontrol;
    reg [31:0] SrcA;
    reg [31:0] SrcB;
    reg [31:0] expected_result;
    reg expected_zero;
    reg clk;
  	reg [31:0] ALUresult;
  	wire zero;

    // Instantiate the ALU module
    ALU dut (
        .ALUcontrol(ALUcontrol),
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUresult(ALUresult),
        .zero(zero)
    );

    // Clock generation
    always #5 clk = ~clk;  // Toggle clock every 5 time units

    // Testbench stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        ALUcontrol = 3'b000;  // Example ALU control (AND operation)
        SrcA = 32'hAAAAAAAA;  // Example operand A
        SrcB = 32'h55555555;  // Example operand B
        expected_result = SrcA & SrcB;  // Calculate expected result
        expected_zero = (expected_result == 32'h0) ? 1 : 0;  // Calculate expected zero flag

        // Test case 1: AND operation
        #10;  // Wait for a few clock cycles
        $display("ALU operation: AND");
        $display("SrcA: %h", SrcA);
        $display("SrcB: %h", SrcB);
        $display("Expected Result: %h", expected_result);
        $display("Expected Zero: %b", expected_zero);
        if (ALUresult === expected_result && zero === expected_zero)
            $display("Result matches expected.");
        else
            $display("Result does not match expected.");
        #10;  // Wait for a few clock cycles

        // Test case 2: OR operation
        ALUcontrol = 3'b001;  // Example ALU control (OR operation)
        SrcA = 32'h12345678;  // Example operand A for OR
        SrcB = 32'h9ABCDEF0;  // Example operand B for OR
        expected_result = SrcA | SrcB;  // Calculate expected result
        expected_zero = (expected_result == 32'h0) ? 1 : 0;  // Calculate expected zero flag
        #10;  // Wait for a few clock cycles
        $display("ALU operation: OR");
        $display("SrcA: %h", SrcA);
        $display("SrcB: %h", SrcB);
        $display("Expected Result: %h", expected_result);
        $display("Expected Zero: %b", expected_zero);
        if (ALUresult === expected_result && zero === expected_zero)
            $display("Result matches expected.");
        else
            $display("Result does not match expected.");
        #10;  // Wait for a few clock cycles
      
      // Test case 3: Addition operation
        ALUcontrol = 3'b010;  // Example ALU control (Addition operation)
        SrcA = 32'h12345678;  // Example operand A for addition
        SrcB = 32'h00000002;  // Example operand B for addition
        expected_result = SrcA + SrcB;  // Calculate expected result
        expected_zero = (expected_result == 32'h0) ? 1 : 0;  // Calculate expected zero flag
        #10;  // Wait for a few clock cycles
        $display("ALU operation: Addition");
        $display("SrcA: %h", SrcA);
        $display("SrcB: %h", SrcB);
        $display("Expected Result: %h", expected_result);
        $display("Expected Zero: %b", expected_zero);
        if (ALUresult === expected_result && zero === expected_zero)
            $display("Result matches expected.");
        else
            $display("Result does not match expected.");
        #10;  // Wait for a few clock cycles

        // Test case 4: Subtraction operation
        ALUcontrol = 3'b110;  // Example ALU control (Subtraction operation)
        SrcA = 32'h12345678;  // Example operand A for subtraction
        SrcB = 32'h00000002;  // Example operand B for subtraction
        expected_result = SrcA - SrcB;  // Calculate expected result
        expected_zero = (expected_result == 32'h0) ? 1 : 0;  // Calculate expected zero flag
        #10;  // Wait for a few clock cycles
        $display("ALU operation: Subtraction");
        $display("SrcA: %h", SrcA);
        $display("SrcB: %h", SrcB);
        $display("Expected Result: %h", expected_result);
        $display("Expected Zero: %b", expected_zero);
        if (ALUresult === expected_result && zero === expected_zero)
            $display("Result matches expected.");
        else
            $display("Result does not match expected.");
        #10;  // Wait for a few clock cycles
      
      // Test case 5: and not
        ALUcontrol = 3'b100;  // Example ALU control (Subtraction operation)
        SrcA = 32'h12345678;  // Example operand A for subtraction
        SrcB = 32'h00000002;  // Example operand B for subtraction
        expected_result = SrcA & ~SrcB;  // Calculate expected result
        expected_zero = (expected_result == 32'h0) ? 1 : 0;  // Calculate expected zero flag
        #10;  // Wait for a few clock cycles
      $display("ALU operation: and not");
        $display("SrcA: %h", SrcA);
        $display("SrcB: %h", SrcB);
        $display("Expected Result: %h", expected_result);
        $display("Expected Zero: %b", expected_zero);
        if (ALUresult === expected_result && zero === expected_zero)
            $display("Result matches expected.");
        else
            $display("Result does not match expected.");
        #10;  // Wait for a few clock cycles
      
      // Test case 6: or not
        ALUcontrol = 3'b101;  // Example ALU control (Subtraction operation)
        SrcA = 32'h12345678;  // Example operand A for subtraction
        SrcB = 32'h00000002;  // Example operand B for subtraction
        expected_result = SrcA | ~SrcB;  // Calculate expected result
        expected_zero = (expected_result == 32'h0) ? 1 : 0;  // Calculate expected zero flag
        #10;  // Wait for a few clock cycles
      $display("ALU operation: or not");
        $display("SrcA: %h", SrcA);
        $display("SrcB: %h", SrcB);
        $display("Expected Result: %h", expected_result);
        $display("Expected Zero: %b", expected_zero);
        if (ALUresult === expected_result && zero === expected_zero)
            $display("Result matches expected.");
        else
            $display("Result does not match expected.");
        #10;  // Wait for a few clock cycles
      
      // Test case 5: and not
        ALUcontrol = 3'b100;  // Example ALU control (Subtraction operation)
        SrcA = 32'h12345678;  // Example operand A for subtraction
        SrcB = 32'h00000002;  // Example operand B for subtraction
        expected_result = SrcA & ~SrcB;  // Calculate expected result
        expected_zero = (expected_result == 32'h0) ? 1 : 0;  // Calculate expected zero flag
        #10;  // Wait for a few clock cycles
      $display("ALU operation: and not");
        $display("SrcA: %h", SrcA);
        $display("SrcB: %h", SrcB);
        $display("Expected Result: %h", expected_result);
        $display("Expected Zero: %b", expected_zero);
        if (ALUresult === expected_result && zero === expected_zero)
            $display("Result matches expected.");
        else
            $display("Result does not match expected.");
        #10;  // Wait for a few clock cycles
      
      // Test case 6: less
        ALUcontrol = 3'b111;  // Example ALU control (Subtraction operation)
        SrcA = 32'h12345678;  // Example operand A for subtraction
        SrcB = 32'h00000002;  // Example operand B for subtraction
        expected_result = SrcA < SrcB;  // Calculate expected result
        expected_zero = (expected_result == 32'h0) ? 1 : 0;  // Calculate expected zero flag
        #10;  // Wait for a few clock cycles
      $display("ALU operation: less");
        $display("SrcA: %h", SrcA);
        $display("SrcB: %h", SrcB);
        $display("Expected Result: %h", expected_result);
        $display("Expected Zero: %b", expected_zero);
        if (ALUresult === expected_result && zero === expected_zero)
            $display("Result matches expected.");
        else
            $display("Result does not match expected.");
        #10;  // Wait for a few clock cycles

        // Add more test cases as needed for different ALU operations

        // Finish simulation
        $finish;
    end

    // Monitor ALUresult and zero for verification
    always @(posedge clk) begin
        $display("At time %t, ALUresult = %h, zero = %b", $time, ALUresult, zero);
    end
  
  initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
  #10000 $finish;
end

endmodule
