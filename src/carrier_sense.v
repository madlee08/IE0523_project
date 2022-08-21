`include "functions.v"

module CARRIER_SENSE(
	input CLOCK, 
	input mr_main_reset,
	input receiving,
	input repeater_mode,
	input transmitting,
	output reg  CRS
);

always @(posedge CLOCK) begin
	if(!mr_main_reset || (!receiving && (repeater_mode || !transmitting)))
		CRS=`FALSE; // carrier sense OFF
	
	else if (receiving || (!repeater_mode && transmitting))
		CRS=`TRUE; // CARRIER SENSE ON
end
endmodule
