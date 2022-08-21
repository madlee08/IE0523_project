`include "functions.v"
`include "macros_TX.v"

module TRANSMIT_CG (
    input mr_main_reset,
    input GTX_CLK,
    input [6:0] tx_o_set,
    input [7:0] TXD,
    output reg tx_even,
    output reg TX_OSET_indicate,
    output reg [9:0] tx_code_group
);

// función ENCODE(X)
ENCODE data (
    .valid_cg_8b(TXD),
    .valid_cg_10b(TXD_encoded)
);

// variables internas de TX code group
wire [9:0] TXD_encoded;
reg [`numero_estados_cg-1:0] estado_actual;
reg [`numero_estados_cg-1:0] estado_siguiente;


always @(posedge GTX_CLK) begin
    if (!mr_main_reset) begin
        estado_actual <= `GENERATE_CODE_GROUPS;
        TX_OSET_indicate <= `FALSE;
    end else
        estado_actual <= estado_siguiente;
end

always @(*) begin
    // para garantizar el comportamiento del DFF
    estado_siguiente = estado_actual;

    TX_OSET_indicate = `FALSE;
    // implementación de la máquina de estados 
    // de acuerdo al diagrama ASM
    case(estado_actual)
        // GENERATE_CODE_GROUPS
        `GENERATE_CODE_GROUPS: begin
            if (tx_o_set == `tx_os_I) begin
                tx_even = `TRUE;
                tx_code_group = `K28_5_10b; // /K28.5/
                estado_siguiente = `IDLE_I2B;
            end

            else begin
                TX_OSET_indicate = `TRUE;
                tx_even = !tx_even;
                
                if (tx_o_set == `tx_os_R)
                    tx_code_group = `K23_7_10b; // /R/

                if (tx_o_set == `tx_os_S)
                    tx_code_group = `K27_7_10b; // /S/

                if (tx_o_set == `tx_os_T)
                    tx_code_group = `K29_7_10b; // /T/

                if (tx_o_set == `tx_os_V)
                    tx_code_group = `K30_7_10b; // /V/

                if (tx_o_set == `tx_os_D)
                    tx_code_group = TXD_encoded; // ENCODE(TXD)
            end
        end

        // IDLE_I2B
        `IDLE_I2B: begin
            tx_even = `FALSE;
            TX_OSET_indicate = `TRUE;
            tx_code_group = `D16_2_10b; // /D16.2/
            estado_siguiente = `GENERATE_CODE_GROUPS;
        end

        default : estado_siguiente = `GENERATE_CODE_GROUPS;
    endcase

end
endmodule