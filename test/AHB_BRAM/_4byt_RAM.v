module _4byt_RAM#(parameter AW = 12, parameter filename = "code.hex")(
input clk,  
input [3:0] we, 
input cs,
input [AW-1:0] addr,
input [31:0] din,
output [31:0] dout
);
  
localparam AWT = ((1<<(AW-0))-1);

//four 8 bytes memories with size 2**12 
reg [7:0] _0_mem [0:2**(AW)-1]/* synthesis ramstyle = "M9K" */;
reg [7:0] _1_mem [0:2**(AW)-1]/* synthesis ramstyle = "M9K" */;
reg [7:0] _2_mem [0:2**(AW)-1]/* synthesis ramstyle = "M9K" */;
reg [7:0] _3_mem [0:2**(AW)-1]/* synthesis ramstyle = "M9K" */;
reg [31:0] _32_line_mem [0:2**(AW)-1];
reg _r_cs;
reg [AW-1:0] _r_addr;
wire [31:0] dout_init;
integer i;  


initial begin
    
    for (i=0; i<=AWT; i=i+1) begin
   		 _32_line_mem[i] = 32'h0000;
	end 
	
	$readmemh(filename, _32_line_mem);
   
	for (i=0; i<=AWT; i=i+1) begin
		 _0_mem[i] = 8'h00;
		 _1_mem[i] = 8'h00;
		 _2_mem[i] = 8'h00;
		 _3_mem[i] = 8'h00; 
	end 
	
	for (i=0; i<=AWT; i=i+1) begin
		 _0_mem[i] = _32_line_mem[i][7:0];
		 _1_mem[i] = _32_line_mem[i][15:8];
		 _2_mem[i] = _32_line_mem[i][23:16];
		 _3_mem[i] = _32_line_mem[i][31:24]; 
	end 
	

end 

//this type reads the new data after write not the old one   

always @(posedge clk)
begin
  
  if (we[0]) _0_mem[addr] <= din[7:0];
  if (we[1]) _1_mem[addr] <= din[15:8]; 
  if (we[2]) _2_mem[addr] <= din[23:16];
  if (we[3]) _3_mem[addr] <= din[31:24];
  
  _r_addr = addr; 
  
end  

always @(posedge clk) begin
   
  _r_cs = cs;

end
  

assign dout_init = {_3_mem[_r_addr], _2_mem[_r_addr], _1_mem[_r_addr], _0_mem[_r_addr]};

assign dout = (_r_cs)? dout_init:32'h0000;

endmodule