`include "mips_codes.sv"

module control(
    input clk,
    input [5:0] instruction,
    input [5:0] funct,    
    input zero,
    output reg jal,
    output reg reg_dst,
    output reg jump,
    output reg branch,
    output reg memRead,
    output reg mem2Reg,
    output reg regWrite,
    output reg [2:0] ALUop,
    output reg memWrite,
    output reg ALUsrc,
    output reg signXtend
);

always @ (*)
begin
    casex(instruction)
        //////////////////////////
        ////// Instruções R //////
        //////////////////////////

        `R_TYPE:
            begin
                reg_dst =   1'b0;
                jump =      1'b0;
                branch =    1'b0;
                memRead =   1'b0;
                mem2Reg =   1'b0;
                memWrite =  1'b0;
                ALUsrc =    1'b0;
                regWrite =  1'b0;
                jal = 1'b0;
                signXtend = (funct[0]) ? 1'b0 : 1'b1;
                ALUop =     3'b111;
                
                casex(funct)       
                    `JUMP:
                        jump =  1'b1;
                endcase
            end

        //////////////////////////
        ////// Instruções I //////
        //////////////////////////

        `ADDI:
            begin
                reg_dst =   1'b0;
                jump =      1'b0;
                branch =    1'b0;
                memRead =   1'b0;
                mem2Reg =   1'b0;
                memWrite =  1'b0;
                ALUsrc =    1'b1;
                regWrite =  1'b1;
                ALUop =     3'b010;  
                signXtend = 1'b1;
                jal =       1'b0;
                
            end

            `BNE:
            begin
                reg_dst =   1'b0;
                branch =    1'b1;
                memRead =   1'b0;
                mem2Reg =   1'b0;
                memWrite =  1'b0;
                ALUsrc =    1'b0;
                regWrite =  1'b0;
                ALUop =   3'b110;
                jal =       1'b0;
            end
        
            `LW:
            begin
                reg_dst =   1'b0;
                branch =    1'b0;
                jump =      1'b0;
                memRead =   1'b1;
                mem2Reg =   1'b1;
                memWrite =  1'b0;
                ALUsrc =    1'b1;
                regWrite =  1'b1;
                ALUop =     3'b010;
                signXtend = 1'b1;
                jal =       1'b0;
            end
            
            `SW:
            begin
                reg_dst =   1'b0;
                branch =    1'b0;
                jump =      1'b0;
                memRead =   1'b0;
                mem2Reg =   1'b0;
                memWrite =  1'b1;
                ALUsrc =    1'b1;
                regWrite =  1'b0;
                ALUop =     3'b010;
                signXtend = 1'b1;
                jal =       1'b0;
            end

        //////////////////////////   
        ////// Instruções J //////
        //////////////////////////
    
            `JAL:
            begin
                reg_dst =   1'b0;
                jump =      1'b1;
                branch =    1'b0;
                memRead =   1'b0;
                mem2Reg =   1'b0;
                memWrite =  1'b0;
                ALUsrc =    1'b0;
                regWrite =  1'b1;
                ALUop =     3'b010;  
                signXtend = 1'b0;
                jal =       1'b1;
            end
    endcase
end

endmodule