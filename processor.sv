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
reg [31:0] alu_input_2;

always @ (*) begin
    if (reg_dst)
        assign reg_file_write_address = instruction[15:11];
    else begin
        if (jal) assign reg_file_write_address = 5'b11111;
        else assign reg_file_write_address = instruction[20:16];
    end

    if (ALUsrc)
        assign alu_input_2 = {16'b0, immediate};
    else begin
        if (jal) assign alu_input_2 = pcplus4; 
        else assign alu_input_2 = reg_file_out2;
    end
end


always@(posedge clk)
begin
    if (reset) pc <= 32'd0;
    else begin

        if (jal | (branch & ~zero)) assign jump_address = {16'd0, instruction[15:0]} << 2;
        else if (jump) assign jump_address = registers[31];
        else assign jump_address = pcplus4;

        pc <= jump_address;
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