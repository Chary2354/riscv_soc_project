module soc_top (clk,
    i2c_scl,
    i2c_sda_in,
    i2c_sda_out,
    mac_done,
    rst,
    spi_cs,
    spi_miso,
    spi_mosi,
    spi_sclk,
    timer_irq,
    uart_rx,
    uart_tx,
    gpio_in,
    gpio_out,
    mac_result);
 input clk;
 output i2c_scl;
 input i2c_sda_in;
 output i2c_sda_out;
 output mac_done;
 input rst;
 output spi_cs;
 input spi_miso;
 output spi_mosi;
 output spi_sclk;
 output timer_irq;
 input uart_rx;
 output uart_tx;
 input [7:0] gpio_in;
 output [7:0] gpio_out;
 output [63:0] mac_result;


 sky130_fd_sc_hd__conb_1 _00_ (.LO(mac_result[0]));
 sky130_fd_sc_hd__conb_1 _01_ (.LO(mac_result[1]));
 sky130_fd_sc_hd__conb_1 _02_ (.LO(mac_result[2]));
 sky130_fd_sc_hd__conb_1 _03_ (.LO(mac_result[3]));
 sky130_fd_sc_hd__conb_1 _04_ (.LO(mac_result[4]));
 sky130_fd_sc_hd__conb_1 _05_ (.LO(mac_result[5]));
 sky130_fd_sc_hd__conb_1 _06_ (.LO(mac_result[6]));
 sky130_fd_sc_hd__conb_1 _07_ (.LO(mac_result[7]));
 sky130_fd_sc_hd__conb_1 _08_ (.LO(mac_result[8]));
 sky130_fd_sc_hd__conb_1 _09_ (.LO(mac_result[9]));
 sky130_fd_sc_hd__conb_1 _10_ (.LO(mac_result[10]));
 sky130_fd_sc_hd__conb_1 _11_ (.LO(mac_result[11]));
 sky130_fd_sc_hd__conb_1 _12_ (.LO(mac_result[12]));
 sky130_fd_sc_hd__conb_1 _13_ (.LO(mac_result[13]));
 sky130_fd_sc_hd__conb_1 _14_ (.LO(mac_result[14]));
 sky130_fd_sc_hd__conb_1 _15_ (.LO(mac_result[15]));
 sky130_fd_sc_hd__conb_1 _16_ (.LO(mac_result[16]));
 sky130_fd_sc_hd__conb_1 _17_ (.LO(mac_result[17]));
 sky130_fd_sc_hd__conb_1 _18_ (.LO(mac_result[18]));
 sky130_fd_sc_hd__conb_1 _19_ (.LO(mac_result[19]));
 sky130_fd_sc_hd__conb_1 _20_ (.LO(mac_result[20]));
 sky130_fd_sc_hd__conb_1 _21_ (.LO(mac_result[21]));
 sky130_fd_sc_hd__conb_1 _22_ (.LO(mac_result[22]));
 sky130_fd_sc_hd__conb_1 _23_ (.LO(mac_result[23]));
 sky130_fd_sc_hd__conb_1 _24_ (.LO(mac_result[24]));
 sky130_fd_sc_hd__conb_1 _25_ (.LO(mac_result[25]));
 sky130_fd_sc_hd__conb_1 _26_ (.LO(mac_result[26]));
 sky130_fd_sc_hd__conb_1 _27_ (.LO(mac_result[27]));
 sky130_fd_sc_hd__conb_1 _28_ (.LO(mac_result[28]));
 sky130_fd_sc_hd__conb_1 _29_ (.LO(mac_result[29]));
 sky130_fd_sc_hd__conb_1 _30_ (.LO(mac_result[30]));
 sky130_fd_sc_hd__conb_1 _31_ (.LO(mac_result[31]));
 sky130_fd_sc_hd__conb_1 _32_ (.LO(mac_result[32]));
 sky130_fd_sc_hd__conb_1 _33_ (.LO(mac_result[33]));
 sky130_fd_sc_hd__conb_1 _34_ (.LO(mac_result[34]));
 sky130_fd_sc_hd__conb_1 _35_ (.LO(mac_result[35]));
 sky130_fd_sc_hd__conb_1 _36_ (.LO(mac_result[36]));
 sky130_fd_sc_hd__conb_1 _37_ (.LO(mac_result[37]));
 sky130_fd_sc_hd__conb_1 _38_ (.LO(mac_result[38]));
 sky130_fd_sc_hd__conb_1 _39_ (.LO(mac_result[39]));
 sky130_fd_sc_hd__conb_1 _40_ (.LO(mac_result[40]));
 sky130_fd_sc_hd__conb_1 _41_ (.LO(mac_result[41]));
 sky130_fd_sc_hd__conb_1 _42_ (.LO(mac_result[42]));
 sky130_fd_sc_hd__conb_1 _43_ (.LO(mac_result[43]));
 sky130_fd_sc_hd__conb_1 _44_ (.LO(mac_result[44]));
 sky130_fd_sc_hd__conb_1 _45_ (.LO(mac_result[45]));
 sky130_fd_sc_hd__conb_1 _46_ (.LO(mac_result[46]));
 sky130_fd_sc_hd__conb_1 _47_ (.LO(mac_result[47]));
 sky130_fd_sc_hd__conb_1 _48_ (.LO(mac_result[48]));
 sky130_fd_sc_hd__conb_1 _49_ (.LO(mac_result[49]));
 sky130_fd_sc_hd__conb_1 _50_ (.LO(mac_result[50]));
 sky130_fd_sc_hd__conb_1 _51_ (.LO(mac_result[51]));
 sky130_fd_sc_hd__conb_1 _52_ (.LO(mac_result[52]));
 sky130_fd_sc_hd__conb_1 _53_ (.LO(mac_result[53]));
 sky130_fd_sc_hd__conb_1 _54_ (.LO(mac_result[54]));
 sky130_fd_sc_hd__conb_1 _55_ (.LO(mac_result[55]));
 sky130_fd_sc_hd__conb_1 _56_ (.LO(mac_result[56]));
 sky130_fd_sc_hd__conb_1 _57_ (.LO(mac_result[57]));
 sky130_fd_sc_hd__conb_1 _58_ (.LO(mac_result[58]));
 sky130_fd_sc_hd__conb_1 _59_ (.LO(mac_result[59]));
 sky130_fd_sc_hd__conb_1 _60_ (.LO(mac_result[60]));
 sky130_fd_sc_hd__conb_1 _61_ (.LO(mac_result[61]));
 sky130_fd_sc_hd__conb_1 _62_ (.LO(mac_result[62]));
 sky130_fd_sc_hd__conb_1 _63_ (.LO(mac_result[63]));
 sky130_fd_sc_hd__conb_1 _64_ (.LO(spi_cs));
 sky130_fd_sc_hd__conb_1 _65_ (.LO(spi_mosi));
 sky130_fd_sc_hd__conb_1 _66_ (.LO(i2c_sda_out));
 sky130_fd_sc_hd__conb_1 _67_ (.LO(gpio_out[0]));
 sky130_fd_sc_hd__conb_1 _68_ (.LO(gpio_out[1]));
 sky130_fd_sc_hd__conb_1 _69_ (.LO(gpio_out[2]));
 sky130_fd_sc_hd__conb_1 _70_ (.LO(gpio_out[3]));
 sky130_fd_sc_hd__conb_1 _71_ (.LO(gpio_out[4]));
 sky130_fd_sc_hd__conb_1 _72_ (.LO(gpio_out[5]));
 sky130_fd_sc_hd__conb_1 _73_ (.LO(gpio_out[6]));
 sky130_fd_sc_hd__conb_1 _74_ (.LO(gpio_out[7]));
 sky130_fd_sc_hd__conb_1 _75_ (.LO(timer_irq));
 sky130_fd_sc_hd__conb_1 _76_ (.LO(mac_done));
 sky130_fd_sc_hd__conb_1 _77_ (.LO(uart_tx));
 sky130_fd_sc_hd__buf_2 _78_ (.A(clk),
    .X(i2c_scl));
 sky130_fd_sc_hd__buf_2 _79_ (.A(clk),
    .X(spi_sclk));
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_0_Right_0 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_1_Right_1 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_2_Right_2 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_3_Right_3 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_4_Right_4 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_5_Right_5 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_6_Right_6 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_7_Right_7 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_8_Right_8 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_9_Right_9 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_10_Right_10 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_11_Right_11 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_12_Right_12 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_13_Right_13 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_0_Left_14 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_1_Left_15 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_2_Left_16 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_3_Left_17 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_4_Left_18 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_5_Left_19 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_6_Left_20 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_7_Left_21 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_8_Left_22 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_9_Left_23 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_10_Left_24 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_11_Left_25 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_12_Left_26 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_13_Left_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_28 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_1_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_3_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_5_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_7_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_10_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_11_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_12_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_13_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_13_43 ();
endmodule
