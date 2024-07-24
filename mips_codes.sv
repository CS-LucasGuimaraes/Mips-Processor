//////////////////////////
///// Instruções R /////
`define R_TYPE  6'b000000
// Jump
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