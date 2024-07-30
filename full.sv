//////////////////////////
///// Instruções R /////
`define R_TYPE  6'b000000

`define JR      6'b001000

//////////////////////////
///// Instruções I /////
//////////////////////////
// Add
`define ADDI    6'b001000

// Branch Instructions
`define BNE     6'b000101

// Load
`define LW      6'b100011

// Store
`define SW      6'b101011

//////////////////////////   
///// Instruções J /////
//////////////////////////
`define JAL     6'b000011


module ALU (
    input [2:0] ALUcontrol,
    input [31:0] SrcA,
    input [31:0] SrcB,
    output reg [31:0] ALUresult,
    output reg zero
);

  always @(ALUcontrol or SrcA or SrcB)
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

  always @(ALUresult) begin
    if(ALUresult == 0)
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

always @(negedge clk)
begin
    if (write_enable) begin
        memory[address  ] <= write_data[31:24];
        memory[address+1] <= write_data[23:16];
        memory[address+2] <= write_data[15: 8];
        memory[address+3] <= write_data[ 7: 0];

        $display("Valor %b carregado na posição %b", write_data, address);
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

module register_file(
    input clk,
    input [4:0] reg_address1,
    input [4:0] reg_address2,
    input [4:0] reg_write_address, 
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2,
    output reg [31:0] registers[31:0],
    input write
);

integer i;
initial begin 
    for (i = 0; i < 32; i = i + 1) begin
       registers[i] = 32'b0;
    end
end


assign read_data1 = registers[reg_address1]; 
assign read_data2 = registers[reg_address2]; 

always @ (negedge clk)
begin
    if(write)
    begin
        registers[reg_write_address] <= write_data;
    end
end	

endmodule

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
                    ALUop =     3'b111; // NOP
                    
                    casex(funct)       
                        6'b00100X:  // Jump (JR)
                            jump =      1'b1;
                    endcase
                end


             `BNE:  // Branch Instructions
                begin
                    reg_dst =   1'b0;
                    branch =    1'b1;
                    memRead =   1'b0;
                    mem2Reg =   1'b0;
                    memWrite =  1'b0;
                    ALUsrc =    1'b1;
                    regWrite =  1'b0;
                    ALUop = 3'b110;
                    jal = 1'b0;
                end
            
             `LW:  // Load Instructions
                begin
                    reg_dst =   1'b0;
                    branch =    1'b0;
                    jump =      1'b0;
                    memRead =   1'b1;
                    mem2Reg =   1'b1;
                    memWrite =  1'b0;
                    ALUsrc =    1'b1;
                    regWrite =  1'b1;
                    ALUop =     3'b000;
                    signXtend = 1'b1;
                    jal = 1'b0;
                    $display("LW!!!!");
                end
                
             `SW:  // Store Instructions
                begin
                   reg_dst =    1'b0;
                    branch =    1'b0;
                    jump =      1'b0;
                    memRead =   1'b0;
                    mem2Reg =   1'b0;
                    memWrite =  1'b1;
                    ALUsrc =    1'b1;
                    regWrite =  1'b0;
                    ALUop =     3'b000;
                    signXtend = 1'b1;
                    jal = 1'b0;
                end

      
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
                    ALUop =     3'b111;  
                    signXtend = 1'b0;
                    jal = 1'b1;
                end

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
                    jal = 1'b0;
                    $display("ADDI!!!!");
                    
                end

        endcase
    end
endmodule

module processor(
    input clk,
    input reset
);

// Control Wires
wire reg_dst;
wire jal;
wire jump;
wire branch;
wire memRead;
wire mem2Reg;
wire signXtend;
wire memWrite;
wire regWrite;
wire [2:0] ALUop;
wire zero;
wire [31:0] ALUresult;
wire ALUsrc;


// PC + Instruction Memory Wires
reg  [31:0]     pc;
wire [31:0]     pcplus4 = pc + 4;
wire [31:0]     instruction;
wire [5:0]      opCode = instruction[31:26];
reg  [31:0]     jump_address;
wire [4:0]      src_addr = instruction[25:21];
wire [4:0]      trgt_addr = instruction[20:16];
wire [4:0]      dest_addr = instruction[15:11];
wire [5:0]      funct = instruction[5:0];
wire [15:0]     immediate = instruction[15:0];

// REGISTER WIRES
reg  [31:0] registers[31:0];
wire [31:0] read_data;
reg  [4:0] reg_file_write_address;
wire [31:0] reg_file_write_data = (mem2Reg) ? read_data : ALUresult;
reg [31:0] reg_file_out1;
reg [31:0] reg_file_out2;
wire [31:0] alu_input_2 = (ALUsrc) ? {16'b0, immediate} : reg_file_out2;

always @ (*) begin
    if (reg_dst)
        assign reg_file_write_address = instruction[15:11];
    else begin
        if (jal) assign reg_file_write_address = 5'b11111;
        else assign reg_file_write_address = instruction[20:16];
    end
end


always@(posedge clk)
begin
    if (reset) pc <= 32'd0;
    else begin

        if (jal | branch) jump_address = {16'd0, instruction[15:0]} << 2;
        else if (jump) jump_address = registers[31];
        else assign jump_address = pcplus4;

        pc <= jump_address;
        $display("PC = JA");
    end
end


// Instantiation


ALU my_alu(.ALUcontrol(ALUop),
                     .SrcA(reg_file_out1),
                     .SrcB(alu_input_2),
                     .ALUresult(ALUresult),
                     .zero(zero)
);

control my_control(.clk(clk),
                     .instruction(opCode),
                     .memWrite(memWrite),
                     .funct(funct),
                     .zero(zero),
                     .jal(jal),
                     .reg_dst(reg_dst),
                     .jump(jump),
                     .branch(branch),
                     .memRead(memRead),
                     .mem2Reg(mem2Reg),
                     .regWrite(regWrite),
                     .ALUop(ALUop),
                     .ALUsrc(ALUsrc),
                     .signXtend(signXtend)
);

register_file my_reg_file(.clk(clk), 
                     .reg_address1(instruction[25:21]), 
                     .reg_address2(instruction[20:16]), 
                     .reg_write_address(reg_file_write_address), 
                     .write_data(reg_file_write_data), 
                     .read_data1(reg_file_out1), 
                     .read_data2(reg_file_out2), 
                     .write(regWrite),
                     .registers(registers));

instruction_memory my_ins_mem(.address(pc), .instruction(instruction));

data_memory data_mem(.clk(clk), .address(ALUresult), .write_data(reg_file_out2), .read_data(read_data), .write_enable(memWrite));

endmodule