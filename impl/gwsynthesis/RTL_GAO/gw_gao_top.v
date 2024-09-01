module gw_gao(
    \ciclo_esp32[4] ,
    \ciclo_esp32[3] ,
    \ciclo_esp32[2] ,
    \ciclo_esp32[1] ,
    \ciclo_esp32[0] ,
    \semaforos[11] ,
    \semaforos[10] ,
    \semaforos[9] ,
    \semaforos[8] ,
    \semaforos[7] ,
    \semaforos[6] ,
    \semaforos[5] ,
    \semaforos[4] ,
    \semaforos[3] ,
    \semaforos[2] ,
    \semaforos[1] ,
    \semaforos[0] ,
    rst,
    dest_esp32,
    clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \ciclo_esp32[4] ;
input \ciclo_esp32[3] ;
input \ciclo_esp32[2] ;
input \ciclo_esp32[1] ;
input \ciclo_esp32[0] ;
input \semaforos[11] ;
input \semaforos[10] ;
input \semaforos[9] ;
input \semaforos[8] ;
input \semaforos[7] ;
input \semaforos[6] ;
input \semaforos[5] ;
input \semaforos[4] ;
input \semaforos[3] ;
input \semaforos[2] ;
input \semaforos[1] ;
input \semaforos[0] ;
input rst;
input dest_esp32;
input clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \ciclo_esp32[4] ;
wire \ciclo_esp32[3] ;
wire \ciclo_esp32[2] ;
wire \ciclo_esp32[1] ;
wire \ciclo_esp32[0] ;
wire \semaforos[11] ;
wire \semaforos[10] ;
wire \semaforos[9] ;
wire \semaforos[8] ;
wire \semaforos[7] ;
wire \semaforos[6] ;
wire \semaforos[5] ;
wire \semaforos[4] ;
wire \semaforos[3] ;
wire \semaforos[2] ;
wire \semaforos[1] ;
wire \semaforos[0] ;
wire rst;
wire dest_esp32;
wire clk;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top u_ao_top(
    .control(control0[9:0]),
    .data_i({\ciclo_esp32[4] ,\ciclo_esp32[3] ,\ciclo_esp32[2] ,\ciclo_esp32[1] ,\ciclo_esp32[0] ,\semaforos[11] ,\semaforos[10] ,\semaforos[9] ,\semaforos[8] ,\semaforos[7] ,\semaforos[6] ,\semaforos[5] ,\semaforos[4] ,\semaforos[3] ,\semaforos[2] ,\semaforos[1] ,\semaforos[0] ,rst,dest_esp32}),
    .clk_i(clk)
);

endmodule
