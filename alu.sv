`timescale 1ps/1ps

module ALU (
    input clk,
    input [2:0] ALUcontrol,
    input [31:0] SrcA,
    input [31:0] SrcB,
    output [31:0] ALUresult,
    output zero
);

always @(negedge clk)
begin
    case (ALUcontrol)
        000 : ALUresult <= SrcA & SrcB
        001 : ALUresult <= SrcA | SrcB
        010 : ALUresult <= SrcA + SrcB
        100 : ALUresult <= SrcA & ~SrcB
        101 : ALUresult <= SrcA | ~SrcB
        110 : ALUresult <= SrcA - SrcB
        111 : ALUresult <= SrcA < SrcB
    endcase
    if (ALUresult == 0)
        zero <= 1
    else
        zero <= 0
end