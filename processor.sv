module processor(
    input clk
);

// Control Wires
wire reg_dst;
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

reg [31:0] registers[31:0];

// PC + Instruction Memory Wires
reg [31:0]      pc;
wire [31:0]     instruction;
wire [5:0]      opCode = instruction[31:26];
wire [31:0]     jump_address;
wire [4:0]      src_addr = instruction[25:21];
wire [4:0]      trgt_addr = instruction[20:16];
wire [4:0]      dest_addr = instruction[15:11];
wire [5:0]      funct = instruction[5:0];

// REGISTER WIRES
wire [31:0] read_data;
wire [4:0] reg_file_write_address = (reg_dst) ? dest_addr : trgt_addr;
wire [31:0] reg_file_write_data = (mem2Reg) ? read_data : ALUresult;
wire [31:0] reg_file_out1;
wire [31:0] reg_file_out2;

assign reg_file_write_address = (reg_dst) ? instruction[15:11] : instruction[20:16];

always@(posedge clk)
begin
    if (jump) assign pc = jump_address << 2;
    else if (branch) assign pc = instruction[15:0] << 2;
    else assign pc = pc + 4;
end

// Instantiation

ALU my_alu(.ALUcontrol(ALUop),
                     .SrcA(reg_file_out1),
                     .SrcB(reg_file_out2),
                     .ALUresult(ALUresult),
                     .zero(zero)
);

control my_control(.instruction(instruction),
                     .funct(funct),
                     .zero(zero),
                     .reg_dst(reg_dst),
                     .jump(jump),
                     .branch(branch),
                     .memRead(memRead),
                     .mem2Reg(mem2Reg),
                     .regWrite(regWrite),
                     .ALUop(ALUop),
                     .ALUsrc(ALUsrc),
                     .signXtend(signXtend),
                     .jump_address(jump_address)
);

register_file my_reg_file(.clk(clk), 
                     .reg_address1(instruction[25:21]), 
                     .reg_address2(instruction[20:16]), 
                     .reg_write_address(reg_file_write_address), 
                     .write_data(reg_file_write_data), 
                     .read_data1(reg_file_out1), 
                     .read_data2(reg_file_out2),
                     .registers(registers),
                     .write(regWrite));

instruction_memory my_ins_mem(.address(pc), .instruction(instruction));

data_memory data_mem(.clk(clk), .address(ALUresult), .write_data(reg_file_out2), .read_data(read_data), .write_enable(memWrite));

endmodule