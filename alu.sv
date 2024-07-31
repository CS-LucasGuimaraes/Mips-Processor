
module ALU (
    input [2:0] ALUcontrol,
    input [31:0] SrcA,
    input [31:0] SrcB,
    output reg [31:0] ALUresult,
    output reg zero
);

always @ (ALUcontrol or SrcA or SrcB)
begin
    case (ALUcontrol)
        3'b000 : ALUresult <= SrcA & SrcB;
        3'b001 : ALUresult <= SrcA | SrcB;
        3'b010 : ALUresult <= SrcA + SrcB;
        3'b100 : ALUresult <= SrcA & ~SrcB;
        3'b101 : ALUresult <= SrcA | ~SrcB;
        3'b110 : ALUresult <= SrcA - SrcB;
        3'b111 : ALUresult <= SrcA < SrcB;
    endcase
end

always @ (ALUresult)
begin
  if (ALUresult == 0)
    zero = 1;
  else
    zero = 0;
end

endmodule

module data_memory (
    input clk,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] read_data,
    input write_enable
);

reg [7:0] memory [1023:0];

assign read_data = {memory[address], memory[address+1], memory[address+2], memory[address+3]};

always @ (negedge clk)
begin
    if (write_enable) 
    begin
        memory[address  ] <= write_data[31:24];
        memory[address+1] <= write_data[23:16];
        memory[address+2] <= write_data[15: 8];
        memory[address+3] <= write_data[ 7: 0];

        $display("Valor %d carregado na posição %d", write_data, address);
    end
end

endmodule

module instruction_memory (
    input [31:0] address,
    output [31:0] instruction
);

reg [7:0] memory[1023:0];

assign instruction = {memory[address], memory[address + 1], memory[address + 2], memory[address + 3]};

endmodule

