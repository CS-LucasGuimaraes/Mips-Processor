`timescale 1ns / 1ps

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