module tester_CS(
    output reg  CLOCK, mr_main_reset,receiving,repeater_mode,transmitting,
	input CRS

);
  //Si quieren probar todos los estados del carrier sense, sacar de comentarios todo lo que esta de aqui para abajo
//initial CLOCK<=0;
//always #1 CLOCK<=~CLOCK; //switch del reloj
 //condiciones iniciales  
initial CLOCK<=0;
always #1 CLOCK<=~CLOCK;

initial begin

  //  mr_main_reset = 1'b0;
    
   // #2 mr_main_reset <= 1'b1;
  //   receiving<=1'b0;   
 //    transmitting<=1'b0;
      repeater_mode<= 1'b0; 
    
 //    #2 receiving<=1'b0;   
 //    transmitting<=1'b0;
 //    repeater_mode<= 1'b0; 
   	
  //  	#2 receiving<=1'b0;   
  //   transmitting<=1'b0;
  //   repeater_mode<= 1'b1;  
    
    
  //  	#2 receiving<=1'b0;   
 //    transmitting<=1'b1;
 //    repeater_mode<= 1'b0;   
    
  //   #2 receiving<=1'b1;   
  //   transmitting<=1'b0;
  //   repeater_mode<= 1'b0;
    
  //   #2 receiving<=1'b0;   
  //   transmitting<=1'b0;
  //   repeater_mode<= 1'b1; 
     
            #70;
      #4 $finish;
    end
endmodule
