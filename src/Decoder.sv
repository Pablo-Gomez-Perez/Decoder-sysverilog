
/**
 * Defining the top module
 */
module top(input logic clk, rst, dest_esp32,input logic [4:0]ciclo_esp32,output logic[11:0]semaforos);

    logic pulso;
    logic destello;
    assign destello=dest_esp32&pulso;
    gene_1hz g1(clk,rst,pulso);
    decoder d1(ciclo_esp32,destello,semaforos);

endmodule

module UartGateSelect(input logic Tx2, Tx3, Tx4, output tri);

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