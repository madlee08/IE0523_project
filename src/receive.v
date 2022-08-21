`include "functions.v"
`include "macros_RX.v"
`include "macros_AN.v"

module RECEIVE (
    input mr_main_reset,
	input clk,
    input [9:0] SUDI,
	input EVEN,
    input [2:0] xmit,
    output reg [7:0] RXD,
    output reg RX_DV,
    output reg RX_ER,
    output reg RX_CLK,
    output reg receiving
);
	// función DECODE(X)
	DECODE decoding (
		.valid_cg_10b(SUDI), 
		.valid_cg_8b(RXD_aux)
	); 


    //definiendo variables internas
    reg [`numero_estados_rx:0] state;
    reg [`numero_estados_rx:0] nxt_state;
    reg [2:0] preamble_octet;
	reg [19:0] check_end;
	reg [2:0] preamble_octet_new;
	reg [9:0] SUDI_XOR_COMMA;
	wire [7:0] RXD_aux;


    always @(posedge clk) begin
        if (!mr_main_reset) begin
            state = `WAIT_FOR_K;
            RX_CLK = 0;
            RX_DV = `FALSE;
            RX_ER = `FALSE;
			RXD = 8'h00;
			preamble_octet = 3'h0;
			check_end = 20'h0;
        end
        else begin
            state <= nxt_state;
            RX_CLK <= !RX_CLK;
			check_end <= {check_end[9:0], SUDI};
			preamble_octet_new <= preamble_octet + 3'h1;
        end
    end

    always @(*) begin
        //Valores por defecto
        nxt_state = state;

	//máquina de estado
	case(state)
		// WAIT_FOR_K
		`WAIT_FOR_K: begin
			receiving = `FALSE;
			RX_DV = `FALSE;
			RX_ER = `FALSE;
			if  (SUDI == `K28_5_10b && EVEN) nxt_state = `RX_K; //[/K28.5]*EVEN
		end
		

		// RX_K
		//para mantener la consistencia con transmit.v; xmit = 001 = IDLE; xmit = 010 = DATA;  xmit = 100 = CONFIG
		`RX_K: begin
			receiving = `FALSE;
			RX_DV = `FALSE;
			RX_ER = `FALSE;
			RXD = 0;
			if ((xmit != `xmit_DATA && `IS_DATA(SUDI) && `idle_d(SUDI)) ||
				(xmit == `xmit_DATA && `idle_d(SUDI)))
					nxt_state = `IDLE_D;
		end


		// IDLE_D
		`IDLE_D: begin
			SUDI_XOR_COMMA = SUDI ^ `K28_5_10b;

			if ((xmit == `xmit_DATA && !`carrier_detect(SUDI_XOR_COMMA)) || SUDI == `K28_5_10b)
				nxt_state = `RX_K; //Salto a RX_K

			// CARRIER_DETECT
			else if (xmit == `xmit_DATA && `carrier_detect(SUDI_XOR_COMMA)) begin
				receiving = `TRUE;

				if (SUDI == `K27_7_10b)
					nxt_state = `START_OF_PACKET;
				end

				// FALSE_CARRIER
				else begin
					RX_ER = `TRUE;
					RXD = 8'h0E;
					
					if (SUDI == `K28_5_10b && EVEN)
						nxt_state = `RX_K;
				end
			end
				


		// // CARRIER_DETECT
		// `CARRIER_DETECT: begin
		// 	receiving = `TRUE;

		// 	if (SUDI == `K27_7_10b)
		// 		nxt_state = `START_OF_PACKET; //Salto a START_OF_PACKET
			
		// 	else 
		// 		nxt_state = `FALSE_CARRIER; //Salto a FALSE_CARRIER
		// end



		// // FALSE_CARRIER
		// `FALSE_CARRIER: begin
		// 	RX_ER = `TRUE;
		// 	RXD <= 8'b00001110;
		// 	if (SUDI == `K28_5_10b && EVEN) nxt_state = `RX_K; //Salto a RX_K
		// end


		// START_OF_PACKET
		`START_OF_PACKET: begin
			preamble_octet = preamble_octet_new;
			RX_DV = `TRUE;
			RXD =  7'h55;

			if (preamble_octet == 3'h7) begin 
				nxt_state = `RECEIVE;
				preamble_octet = 3'h0;
			end
		end

		// RECEIVE
		`RECEIVE: begin
				// RX_DATA
				if (`IS_DATA(SUDI))
					RXD = RXD_aux;

				// RX_DATA_ERROR
				if (!`IS_VALID(SUDI))
					RX_ER = `TRUE;

				// TRI + RRI
				if (check_end == {`K29_7_10b, `K23_7_10b} && SUDI == `K28_5_10b && EVEN)
					nxt_state = `RX_K;

				// TRR + EXTEND
				else if (check_end == {`K29_7_10b, `K23_7_10b} && SUDI == `K23_7_10b) begin
					RX_ER = `TRUE;
					RXD = 8'b00001111;
					nxt_state = `EPD2_CHECK_END;
				end

				// // EARLY_END_EXT
				else if (check_end == {`K23_7_10b, `K23_7_10b} && SUDI == `K23_7_10b) begin
					RX_ER = `TRUE;
					nxt_state = `EPD2_CHECK_END;
				end
		end


		// // EARLY_END
		// `EPD2_CHECK_END: begin
		// 	if (count2 < 3) begin
		// 		check_end2 = {check_end2[19:0], SUDI[9:0]};
		// 		nxt_count2 = count2 + 1;
		// 	end
		// 	if (count2 >= 3) begin
		// 		if (check_end2 == {`K23_7_10b, `K23_7_10b, `K23_7_10b})begin
		// 			RX_DV = 0;
		// 			RX_ER = 1;
		// 			RXD = 8'b00001111;
		// 			nxt_state = `EPD2_CHECK_END;
		// 			nxt_count2 = 0;
		// 		end
		// 		else if( check_end2 == {`K23_7_10b, `K23_7_10b, `K28_5_10b} && EVEN) begin
		// 			receiving = 0;
		// 			RX_DV = 0;
		// 			RX_ER = 0;
		// 			if (SUDI == `K28_5_10b) begin
		// 				nxt_state = `RX_K;
		// 				nxt_count2 = 0;
		// 			end
		// 		end
		// 		else if (check_end2 == {`K23_7_10b, `K23_7_10b, `K27_7_10b}) begin
		// 			RX_DV = 0;
		// 			RXD = 8'b00001111;
		// 			if (SUDI == `K27_7_10b) begin
		// 				nxt_state = `START_OF_PACKET;
		// 				nxt_count2 = 0;
		// 			end
		// 		end
		// 		else begin
		// 			RX_DV = 0;
		// 			RXD = 8'b00011111;
		// 			if (SUDI == `K27_7_10b) begin
		// 				nxt_state = `START_OF_PACKET;
		// 				nxt_count2 = 0;
		// 			end
		// 			else if (SUDI == `K28_5_10b && EVEN) begin
		// 				nxt_state = `RX_K;
		// 				nxt_count2 = 0;
		// 			end
		// 			else if (SUDI != `K27_7_10b && (SUDI != `K28_5_10b && EVEN)) begin
		// 				nxt_state = `EPD2_CHECK_END;
		// 				nxt_count2 = 0;
		// 			end

		// 		end


		// 	end
			
		// end

		default: nxt_state = `WAIT_FOR_K;
	endcase


	end // end de always @(*)
   

    
endmodule
