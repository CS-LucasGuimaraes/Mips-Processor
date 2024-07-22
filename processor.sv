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
wire ALUsrc;
wire regWrite;
wire [2:0] ALUop;

// PC + Instruction Memory Wires
reg [31:0]      pc;
wire [31:0]     instruction;
wire [5:0]      opCode = instruction[31:26];
wire [31:0]     jump_address = {pc[31:28], instruction[25:0], 2'b0};
wire [4:0]      src_addr = instruction[25:21];
wire [4:0]      trgt_addr = instruction[20:16];
wire [4:0]      dest_addr = instruction[15:11];
wire [31:0]     const = (signXtend) ? {{16{instruction[15]}}, instruction[15:0]} : instruction[15:0];
wire [5:0]      funct = instruction[5:0];

// REGISTER WIRES
wire [4:0] reg_file_write_address = (reg_dst) ? dest_addr : trgt_addr;
wire [31:0] reg_file_write_data = (mem2Reg) ? read_data : ALUresult;
wire [31:0] reg_file_out1;
wire [31:0] reg_file_out2;



if (jump) assign new_pc = jump_address;
else assign new_pc = pc + 4;

if (reg_dst) assign reg_file_write_address = instruction[15:11]; 
else assign reg_file_write_address = instruction[20:16];

always@(posedge clk)
begin
    if (jump) assign pc = jump_address;
    else assign pc = pc + 4;
end

// Instantiation

register_file my_reg_file(.clk(clk), 
                     .reg_address1(instruction[25:21]), 
                     .reg_address2(instruction[20:16]), 
                     .reg_write_address(reg_file_write_address), 
                     .write_data(reg_file_write_data), 
                     .read_data1(reg_file_out1), 
                     .read_data2(reg_file_out2), 
                     .write(regWrite));

instruction_memory my_ins_mem(.address(pc), .instruction(instruction));

data_memory data_mem(.clk(clk), .address(ALUresult), .write_data(reg_file_out2), .read_data(read_data), .write(memWrite));