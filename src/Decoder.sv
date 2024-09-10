
/**
 * Defining the top module
 */
module top(input logic clk,
            rst, //reset
            select, //selector de transito de información de puerto uart activo
            dest_esp32, //bit de destello
            tx2, //puerto Uart Transmiter de la ESP32 - 18
            tx4, //puerto Uart Transmiter del modulo de radiofrecuencia
            tx3, //puerto Uart transmiter del modulo sim7670            
            input logic [3:0]ciclo_esp32, //entrada de las combinaciones enviadas por la esp32
            output logic rx2,led, //Puerto uart receiber de la esp32
            rx4, //Puerto Uart receiber del modulo de radiofrecuencia
            rx3, //Puerto Uart receiber del modulo sim            
            output logic[11:0]semaforos); //salida a los semáforos
    assign led=select;

    logic pulso;
    logic destello;
    assign destello=dest_esp32&pulso;
    gene_1hz g1(clk,rst,pulso);
    decoder d1(ciclo_esp32,destello,semaforos);    

    uart_selector _us(select, tx2, tx3, tx4, rx2, rx3, rx4);

    

endmodule


module gene_1hz(input logic clk,rst,output logic pulso);

    logic [24:0]conta;
    logic pulso;
    always_ff@(posedge clk) begin
        if(!rst) begin
            conta<=0;
        end
        else if(conta==25'd13_500_000)begin 
            conta<=0; 
            pulso<=~pulso;
        end
        else begin
            conta<=conta+1;
        end
    end;

endmodule


/**
 * Decodificador
 */
module decoder(input logic [3:0]ciclo_esp32,input logic destello, output logic [11:0]semaforos);

    always_comb begin
        case({ciclo_esp32,destello})

             //destello ambar 
            4'b00000:semaforos=12'b010_010_010_010;
            4'b00001:semaforos=12'b000_000_000_000;


            //1 verde
            4'b00010:semaforos=12'b100_100_100_001; 
            4'b00011:semaforos=12'b100_100_100_000; 
            //1 ambar
            4'b00100:semaforos=12'b100_100_100_010; 


            //2 verde
            4'b00110:semaforos=12'b100_100_001_100; 
            4'b00111:semaforos=12'b100_100_000_100; 
            //2 ambar
            4'b01000:semaforos=12'b100_100_010_100; 

            //3 verde
            4'b01010:semaforos=12'b100_001_100_100; 
            4'b01011:semaforos=12'b100_000_100_100; 

            //3 ambar
            4'b01100:semaforos=12'b100_010_100_100; 

            //4 verde
            4'b01110:semaforos=12'b001_100_100_100; 
            4'b01111:semaforos=12'b000_100_100_100; 

            //4 ambar
            4'b10000:semaforos=12'b010_100_100_100;

            //errores
            //5'b10010:semaforos=12'b010_010_010_010; //
            //5'b10011:semaforos=12'b100_100_100_100; //
            
            default:semaforos=12'b010_010_010_010;
        endcase
    end

endmodule

/**
 * Buffer o modulo de tercer estado
 */
module triState(input logic a, select, output tri y);

    assign y = select ? a : 1'bz;

endmodule

/**
 * Multiplexor de tercer estado
 */
module mux_triState(input logic tx4, tx3, select, output tri rx2);

    triState(tx4,select,rx2);
    triState(tx3,~select,rx2);

endmodule

/**
 * Demultiplexor
 */
module demux(input logic tx2, select, output logic rx4, rx3);

    assign rx4 = select ? tx2 : 1;
    assign rx3 = ~select ? tx2 : 1;

endmodule

module uart_selector(input logic select, tx2, tx3, tx4, output logic rx2, rx3, rx4);
    
    mux_triState mux(tx4,tx3,select,rx2);
    demux dmx(tx2,select,rx4,rx3);

endmodule

