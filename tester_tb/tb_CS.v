`include "carrier_sense.v"
`include "tester_CS.v"
module testbench_CS;   
	wire CLOCK, mr_main_mr_main_reset,receiving,repeater_mode,transmitting;
	wire CRS;

CARRIER_SENSE CS (
    .CLOCK          (CLOCK),
    .mr_main_reset  (mr_main_reset),
    .receiving      (receiving),
    .repeater_mode  (repeater_mode),
    .transmitting   (transmitting),
    .CRS            (CRS)
);

tester_CS probador (
    .CLOCK         (CLOCK),
    .mr_main_reset (mr_main_reset),
    .receiving     (receiving),
    .repeater_mode (repeater_mode),
    .transmitting  (transmitting),
    .CRS           (CRS)
);

initial
begin
 	$dumpfile("./out/tb_CS.vcd");
	$dumpvars;
	$display ("\t\t\tCLOCK|\trst|\tr_m|\trec|\ttra|\tCRS");
	$display ("\t\t\t----------------------------------",);
	$monitor ($time,"|\t%b|\t%b|\t%b|\t%b|\t%b|\t%b|", CLOCK,mr_main_reset,repeater_mode,receiving,transmitting,CRS);
end
endmodule 
