
/**
 * Defining the top module
 */
module top(input logic clk,
            rst, //reset
            select, //selector de transito de información de puerto uart activo
            dest_esp32, //bit de destello
            tx2, //puerto Uart Transmiter de la ESP32 
            tx4, //puerto Uart Transmiter del modulo de radiofrecuencia
            tx3, //puerto Uart transmiter del modulo sim7670
            input logic [4:0]ciclo_esp32, //entrada de las combinaciones enviadas por la esp32
            output logic rx2, //Puerto uart receiber de la esp32
            rx4, //Puerto Uart receiber del modulo de radiofrecuencia
            rx3, //Puerto Uart receiber del modulo sim
            output logic[11:0]semaforos); //salida a los semáforos

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
module decoder(input logic [4:0]ciclo_esp32,input logic destello, output logic [11:0]semaforos);

    always_comb begin
        case({ciclo_esp32,destello})
            5'b00000:semaforos=12'b100_100_100_001; //00000 - 0
            5'b00001:semaforos=12'b100_100_100_000; //00000 - 1

            5'b00010:semaforos=12'b100_100_100_010; //00001 - 0
            5'b00011:semaforos=12'b100_100_100_010; //00001 - 1

            5'b00100:semaforos=12'b100_100_001_100; //00010 - 0
            5'b00101:semaforos=12'b100_100_000_100; //00010 - 1

            5'b00110:semaforos=12'b100_100_010_100; //00011
            5'b00111:semaforos=12'b100_100_010_100; //00011

            5'b01000:semaforos=12'b100_001_100_100; //00100
            5'b01001:semaforos=12'b100_000_100_100; //00100

            5'b01010:semaforos=12'b100_010_100_100; //00101
            5'b01011:semaforos=12'b100_010_100_100; //00101

            5'b01100:semaforos=12'b001_100_100_100; //00110
            5'b01101:semaforos=12'b000_100_100_100; //00110

            5'b01110:semaforos=12'b100_100_100_100; //00111
            5'b01111:semaforos=12'b100_100_100_100; //00111

            5'b10000:semaforos=12'b010_010_010_010; //01000
            5'b10001:semaforos=12'b000_000_000_000; //01000

            5'b10010:semaforos=12'b010_010_010_010; //01001
            5'b10011:semaforos=12'b100_100_100_100; //01001
            
            /* Para otras posibles combianciones
            5'b10100:semaforos=12'b100_100_100_001; //01010
            5'b10101:semaforos=12'b100_100_100_001; //01010

            5'b10110:semaforos=12'b100_100_100_001; //01011
            5'b10111:semaforos=12'b100_100_100_001; //01011

            5'b11000:semaforos=12'b100_100_100_001; //01100
            5'b11001:semaforos=12'b100_100_100_001; //01100

            5'b11010:semaforos=12'b100_100_100_001; //01101
            5'b11011:semaforos=12'b100_100_100_001; //01101

            5'b11110:semaforos=12'b100_100_100_001; //01110
            5'b11111:semaforos=12'b100_100_100_001; //01110            
            */

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
    demux dmx(tx2,select,rx4,tx4);

endmodule

