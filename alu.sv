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