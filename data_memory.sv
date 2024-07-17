`timescale 1ps/1ps

module data_memory (
    input clk,
    input [31:0] addres,
    input [31:0] write_data,
    output [31:0] read_data,
    input write_enable
);

reg [7:0] memory [1023:0]

assign read_data = {memory[addres], memory[addres+1], memory[addres+2], memory[addres+3] };

always @(negedge clk)
begin
    if (write) begin
        memory[addres  ] <= write_data[31:24];
        memory[addres+1] <= write_data[23:16];
        memory[addres+2] <= write_data[15: 8];
        memory[addres+3] <= write_data[ 7: 0];
    end
end

endmodule
