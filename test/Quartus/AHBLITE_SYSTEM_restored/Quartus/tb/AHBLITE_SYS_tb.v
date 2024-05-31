`timescale 1 ps/ 1 ps
module AHBLITE_SYS_tb();

reg CLK;
reg RESET;
wire[7:0] LED;



AHBLITE_SYS dut(.CLK(CLK), .RESET(RESET), .LED(LED), .TCK_SWCLK(), .TDI_NC(), .TMS_SWDIO(), .TDO_SWO());

always begin
#10 CLK=~CLK;
end



initial begin


RESET=0; CLK=0;

#100 RESET=1;

//#100 RESET = 1;

#3000000

#200 $finish;


end

endmodule
