module tester_TX (
    input [9:0] tx_code_group,
    output reg [7:0] TXD,
    output reg TX_EN,
    output reg TX_ER,
    output reg GTX_CLK,

    input COL,
    output reg mr_main_reset,
    output reg receiving,
    output reg [2:0] xmit
);
    
/* instruccion para crear el reloj
   */
always begin
    GTX_CLK = 1'b0; #1;
    GTX_CLK = 1'b1; #1;
end

initial begin
    TXD = 8'h00;
    TX_EN = 1'b0;
    TX_ER = 1'b0;
    xmit = 3'b001;
    mr_main_reset = 1'b0; #2;

    mr_main_reset = 1'b1;

    #10;
    xmit = 3'b010;
    #10;
    TX_EN = 1'b1;
    #5;
    TXD = 8'h01;
    #2;
    TXD = 8'h02;
    #2;
    TXD = 8'h03;
    #2;
    TXD = 8'h42;
    #2;
    TXD = 8'h50;
    #2;
    TXD = 8'h9A;
    #2;
    TXD = 8'hA6;
    #2;
    TXD = 8'hB5;
    #2;
    TXD = 8'hC5;
    #2;
    TXD = 8'h03;
    #2;
    TX_EN =1'b0;
    #20;
    $finish;
end

endmodule