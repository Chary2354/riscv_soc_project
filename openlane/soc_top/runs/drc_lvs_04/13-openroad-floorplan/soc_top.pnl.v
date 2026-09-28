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

 wire VPWR;
 wire VGND;

 sky130_fd_sc_hd__conb_1 _00_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[0]));
 sky130_fd_sc_hd__conb_1 _01_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[1]));
 sky130_fd_sc_hd__conb_1 _02_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[2]));
 sky130_fd_sc_hd__conb_1 _03_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[3]));
 sky130_fd_sc_hd__conb_1 _04_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[4]));
 sky130_fd_sc_hd__conb_1 _05_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[5]));
 sky130_fd_sc_hd__conb_1 _06_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[6]));
 sky130_fd_sc_hd__conb_1 _07_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[7]));
 sky130_fd_sc_hd__conb_1 _08_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[8]));
 sky130_fd_sc_hd__conb_1 _09_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[9]));
 sky130_fd_sc_hd__conb_1 _10_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[10]));
 sky130_fd_sc_hd__conb_1 _11_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[11]));
 sky130_fd_sc_hd__conb_1 _12_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[12]));
 sky130_fd_sc_hd__conb_1 _13_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[13]));
 sky130_fd_sc_hd__conb_1 _14_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[14]));
 sky130_fd_sc_hd__conb_1 _15_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[15]));
 sky130_fd_sc_hd__conb_1 _16_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[16]));
 sky130_fd_sc_hd__conb_1 _17_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[17]));
 sky130_fd_sc_hd__conb_1 _18_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[18]));
 sky130_fd_sc_hd__conb_1 _19_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[19]));
 sky130_fd_sc_hd__conb_1 _20_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[20]));
 sky130_fd_sc_hd__conb_1 _21_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[21]));
 sky130_fd_sc_hd__conb_1 _22_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[22]));
 sky130_fd_sc_hd__conb_1 _23_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[23]));
 sky130_fd_sc_hd__conb_1 _24_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[24]));
 sky130_fd_sc_hd__conb_1 _25_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[25]));
 sky130_fd_sc_hd__conb_1 _26_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[26]));
 sky130_fd_sc_hd__conb_1 _27_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[27]));
 sky130_fd_sc_hd__conb_1 _28_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[28]));
 sky130_fd_sc_hd__conb_1 _29_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[29]));
 sky130_fd_sc_hd__conb_1 _30_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[30]));
 sky130_fd_sc_hd__conb_1 _31_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[31]));
 sky130_fd_sc_hd__conb_1 _32_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[32]));
 sky130_fd_sc_hd__conb_1 _33_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[33]));
 sky130_fd_sc_hd__conb_1 _34_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[34]));
 sky130_fd_sc_hd__conb_1 _35_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[35]));
 sky130_fd_sc_hd__conb_1 _36_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[36]));
 sky130_fd_sc_hd__conb_1 _37_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[37]));
 sky130_fd_sc_hd__conb_1 _38_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[38]));
 sky130_fd_sc_hd__conb_1 _39_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[39]));
 sky130_fd_sc_hd__conb_1 _40_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[40]));
 sky130_fd_sc_hd__conb_1 _41_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[41]));
 sky130_fd_sc_hd__conb_1 _42_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[42]));
 sky130_fd_sc_hd__conb_1 _43_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[43]));
 sky130_fd_sc_hd__conb_1 _44_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[44]));
 sky130_fd_sc_hd__conb_1 _45_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[45]));
 sky130_fd_sc_hd__conb_1 _46_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[46]));
 sky130_fd_sc_hd__conb_1 _47_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[47]));
 sky130_fd_sc_hd__conb_1 _48_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[48]));
 sky130_fd_sc_hd__conb_1 _49_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[49]));
 sky130_fd_sc_hd__conb_1 _50_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[50]));
 sky130_fd_sc_hd__conb_1 _51_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[51]));
 sky130_fd_sc_hd__conb_1 _52_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[52]));
 sky130_fd_sc_hd__conb_1 _53_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[53]));
 sky130_fd_sc_hd__conb_1 _54_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[54]));
 sky130_fd_sc_hd__conb_1 _55_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[55]));
 sky130_fd_sc_hd__conb_1 _56_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[56]));
 sky130_fd_sc_hd__conb_1 _57_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[57]));
 sky130_fd_sc_hd__conb_1 _58_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[58]));
 sky130_fd_sc_hd__conb_1 _59_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[59]));
 sky130_fd_sc_hd__conb_1 _60_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[60]));
 sky130_fd_sc_hd__conb_1 _61_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[61]));
 sky130_fd_sc_hd__conb_1 _62_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[62]));
 sky130_fd_sc_hd__conb_1 _63_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_result[63]));
 sky130_fd_sc_hd__conb_1 _64_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(spi_cs));
 sky130_fd_sc_hd__conb_1 _65_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(spi_mosi));
 sky130_fd_sc_hd__conb_1 _66_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(i2c_sda_out));
 sky130_fd_sc_hd__conb_1 _67_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(gpio_out[0]));
 sky130_fd_sc_hd__conb_1 _68_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(gpio_out[1]));
 sky130_fd_sc_hd__conb_1 _69_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(gpio_out[2]));
 sky130_fd_sc_hd__conb_1 _70_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(gpio_out[3]));
 sky130_fd_sc_hd__conb_1 _71_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(gpio_out[4]));
 sky130_fd_sc_hd__conb_1 _72_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(gpio_out[5]));
 sky130_fd_sc_hd__conb_1 _73_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(gpio_out[6]));
 sky130_fd_sc_hd__conb_1 _74_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(gpio_out[7]));
 sky130_fd_sc_hd__conb_1 _75_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(timer_irq));
 sky130_fd_sc_hd__conb_1 _76_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(mac_done));
 sky130_fd_sc_hd__conb_1 _77_ (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .LO(uart_tx));
 sky130_fd_sc_hd__buf_2 _78_ (.A(clk),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(i2c_scl));
 sky130_fd_sc_hd__buf_2 _79_ (.A(clk),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(spi_sclk));
endmodule
