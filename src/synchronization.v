`include "macros_SYNC.v"
`include "functions.v"


module SYNCHRONIZATION (
	input clock,
	input mr_main_reset,
	input mr_loopback,
	input signal_detect,
	input [9:0] rx_code_group,
	output reg [9:0] SUDI,
	output reg code_sync_status,
	output reg rx_even
);

// función signal_detectCHANGE
signal_detect_CHANGE sd_C (
    .clk(clock),
    .signal_detect(signal_detect),
    .signal_detectCHANGE(signal_detectCHANGE)
);

// variables intenas de SYNC
wire signal_detectCHANGE;
reg [`numero_estados_sync-1:0] state;
reg [`numero_estados_sync-1:0] nxt_state;
reg [1:0] good_cgs;

always @(posedge clock)
begin
	if (!mr_main_reset || (signal_detectCHANGE && !mr_loopback))
	begin
		state  = `LOSS_OF_SYNC;
		code_sync_status = `FAIL;
		good_cgs = 2'b00;
		rx_even = `FALSE;
	end
	else begin
		SUDI <= rx_code_group;
		state  = nxt_state;
		if (`COMMA_DETECT(state)) rx_even = `TRUE;
		else rx_even = !rx_even;
	end
end

always @(*) begin
  nxt_state = state;

	case(state) 
		//Lost of sync
		`LOSS_OF_SYNC: begin
			code_sync_status <= `FAIL;

			if (!`IS_COMMA(rx_code_group) || (!signal_detect && !mr_loopback))
				nxt_state = `LOSS_OF_SYNC;
			
			else if (`IS_COMMA(rx_code_group) && (signal_detect || mr_loopback))
				nxt_state = `COMMA_DETECT_1;
		end

		// COMMA_DETECT_1
		`COMMA_DETECT_1: begin
			if (`IS_DATA(rx_code_group))
				nxt_state = `ACQUIRE_SYNC_1;
			
			else
				nxt_state = `LOSS_OF_SYNC;
		end

		//ACQUIRE_SYNC_1
		`ACQUIRE_SYNC_1: begin
			if (!rx_even && `IS_COMMA(rx_code_group))
				nxt_state = `COMMA_DETECT_2;

			else if (!`IS_COMMA(rx_code_group) && `IS_VALID(rx_code_group))
				nxt_state = `ACQUIRE_SYNC_1;
			
			else if (`cgbad(rx_code_group, rx_even))
				nxt_state = `LOSS_OF_SYNC;
		end

		// COMMA_DETECT_2
		`COMMA_DETECT_2: begin
			if (`IS_DATA(rx_code_group))
				nxt_state = `ACQUIRE_SYNC_2;
			
			else
				nxt_state = `LOSS_OF_SYNC;
		end

		// ACQUIRE_SYNC_2
		`ACQUIRE_SYNC_2: begin
			if (!rx_even && `IS_COMMA(rx_code_group))
				nxt_state = `COMMA_DETECT_3;
			
			else if (!`IS_COMMA(rx_code_group) && `IS_VALID(rx_code_group))
				nxt_state = `ACQUIRE_SYNC_2;

			else if (`cgbad(rx_code_group, rx_even))
				nxt_state = `LOSS_OF_SYNC;
		end

		// COMMA_DETECT_3
		`COMMA_DETECT_3: begin
			if (`IS_DATA(rx_code_group))
				nxt_state = `SYNC_ACQUIRED_1;

			else
				nxt_state = `LOSS_OF_SYNC;
		end

		// SYNC_ACQUIRE_1
		`SYNC_ACQUIRED_1: begin
			code_sync_status = `OK;

			if (`cggood(rx_code_group, rx_even))
				nxt_state = `SYNC_ACQUIRED_1;
			
			else
				nxt_state = `SYNC_ACQUIRED_2;
		end

		// SYNC_ACQUIRE_2
		`SYNC_ACQUIRED_2: begin
			good_cgs = 0;

			if (`cggood(rx_code_group, rx_even))
				nxt_state = `SYNC_ACQUIRED_2A;

			else
				nxt_state = `SYNC_ACQUIRED_3;
		end

		// SYNC_ACQUIRE_2A
		`SYNC_ACQUIRED_2A: begin
			good_cgs = good_cgs + 1;

			if (`cggood(rx_code_group, rx_even)) begin
				if (good_cgs == 3)
					nxt_state = `SYNC_ACQUIRED_1;
				else
					nxt_state = `SYNC_ACQUIRED_2A;
			end 
			else
				nxt_state = `SYNC_ACQUIRED_3;
		end

		// SYNC_ACQUIRE_3
		`SYNC_ACQUIRED_3: begin
			good_cgs = 0;

			if (`cggood(rx_code_group, rx_even))
				nxt_state = `SYNC_ACQUIRED_3A;
			
			else
				nxt_state = `SYNC_ACQUIRED_3;
		end

		// SYNC_ACQUIRE_3A
		`SYNC_ACQUIRED_3A:  begin
			good_cgs = good_cgs + 1;

			if (`cggood(rx_code_group, rx_even)) begin
				if (good_cgs == 3)
					nxt_state = `SYNC_ACQUIRED_2;

				else
					nxt_state = `SYNC_ACQUIRED_3A;
			end
			else
				nxt_state = `SYNC_ACQUIRED_4;
		end

		// SYNC_ACQUIRE_4
		`SYNC_ACQUIRED_4:  begin 
			good_cgs = 0;

			if (`cggood(rx_code_group, rx_even))
				nxt_state = `SYNC_ACQUIRED_4A;
			
			else
				nxt_state = `LOSS_OF_SYNC;
		end

		// SYNC_ACQUIRE_4A
		`SYNC_ACQUIRED_4A:  begin
			good_cgs = good_cgs + 1;

			if (`cggood(rx_code_group, rx_even)) begin
				if (good_cgs == 3)
					nxt_state = `SYNC_ACQUIRED_3;

				else
					nxt_state = `SYNC_ACQUIRED_4A;
			end
			else
				nxt_state = `LOSS_OF_SYNC;
		end

		default: nxt_state = `LOSS_OF_SYNC; 
	endcase
end 

endmodule
