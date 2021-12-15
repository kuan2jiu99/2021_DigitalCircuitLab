module DE2_115 (
	input CLOCK_50,
	input CLOCK2_50,
	input CLOCK3_50,
	input ENETCLK_25,
	input SMA_CLKIN,
	output SMA_CLKOUT,
	output [8:0] LEDG,
	output [17:0] LEDR,
	input [3:0] KEY,
	input [17:0] SW,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	output [6:0] HEX6,
	output [6:0] HEX7,
	output LCD_BLON,
	inout [7:0] LCD_DATA,
	output LCD_EN,
	output LCD_ON,
	output LCD_RS,
	output LCD_RW,
	output UART_CTS,
	input UART_RTS,
	input UART_RXD,
	output UART_TXD,
	inout PS2_CLK,
	inout PS2_DAT,
	inout PS2_CLK2,
	inout PS2_DAT2,
	output SD_CLK,
	inout SD_CMD,
	inout [3:0] SD_DAT,
	input SD_WP_N,
	output [7:0] VGA_B,
	output VGA_BLANK_N,
	output VGA_CLK,
	output [7:0] VGA_G,
	output VGA_HS,
	output [7:0] VGA_R,
	output VGA_SYNC_N,
	output VGA_VS,
	input AUD_ADCDAT,
	inout AUD_ADCLRCK,
	inout AUD_BCLK,
	output AUD_DACDAT,
	inout AUD_DACLRCK,
	output AUD_XCK,
	output EEP_I2C_SCLK,
	inout EEP_I2C_SDAT,
	output I2C_SCLK,
	inout I2C_SDAT,
	output ENET0_GTX_CLK,
	input ENET0_INT_N,
	output ENET0_MDC,
	input ENET0_MDIO,
	output ENET0_RST_N,
	input ENET0_RX_CLK,
	input ENET0_RX_COL,
	input ENET0_RX_CRS,
	input [3:0] ENET0_RX_DATA,
	input ENET0_RX_DV,
	input ENET0_RX_ER,
	input ENET0_TX_CLK,
	output [3:0] ENET0_TX_DATA,
	output ENET0_TX_EN,
	output ENET0_TX_ER,
	input ENET0_LINK100,
	output ENET1_GTX_CLK,
	input ENET1_INT_N,
	output ENET1_MDC,
	input ENET1_MDIO,
	output ENET1_RST_N,
	input ENET1_RX_CLK,
	input ENET1_RX_COL,
	input ENET1_RX_CRS,
	input [3:0] ENET1_RX_DATA,
	input ENET1_RX_DV,
	input ENET1_RX_ER,
	input ENET1_TX_CLK,
	output [3:0] ENET1_TX_DATA,
	output ENET1_TX_EN,
	output ENET1_TX_ER,
	input ENET1_LINK100,
	input TD_CLK27,
	input [7:0] TD_DATA,
	input TD_HS,
	output TD_RESET_N,
	input TD_VS,
	inout [15:0] OTG_DATA,
	output [1:0] OTG_ADDR,
	output OTG_CS_N,
	output OTG_WR_N,
	output OTG_RD_N,
	input OTG_INT,
	output OTG_RST_N,
	input IRDA_RXD,
	output [12:0] DRAM_ADDR,
	output [1:0] DRAM_BA,
	output DRAM_CAS_N,
	output DRAM_CKE,
	output DRAM_CLK,
	output DRAM_CS_N,
	inout [31:0] DRAM_DQ,
	output [3:0] DRAM_DQM,
	output DRAM_RAS_N,
	output DRAM_WE_N,
	output [19:0] SRAM_ADDR,
	output SRAM_CE_N,
	inout [15:0] SRAM_DQ,
	output SRAM_LB_N,
	output SRAM_OE_N,
	output SRAM_UB_N,
	output SRAM_WE_N,
	output [22:0] FL_ADDR,
	output FL_CE_N,
	inout [7:0] FL_DQ,
	output FL_OE_N,
	output FL_RST_N,
	input FL_RY,
	output FL_WE_N,
	output FL_WP_N,
	inout [35:0] GPIO,
	input HSMC_CLKIN_P1,
	input HSMC_CLKIN_P2,
	input HSMC_CLKIN0,
	output HSMC_CLKOUT_P1,
	output HSMC_CLKOUT_P2,
	output HSMC_CLKOUT0,
	inout [3:0] HSMC_D,
	input [16:0] HSMC_RX_D_P,
	output [16:0] HSMC_TX_D_P,
	inout [6:0] EX_IO
);

logic CLOCK_1hz;
logic CLOCK_1hz_2;
logic [3:0] random_num;

Clock_divider freq_div1 (
    .clock_in(CLOCK_50),
    .clock_out(CLOCK_1hz),
	 .DIVISOR(28'd50000000)
);

Clock_divider freq_div2 (
    .clock_in(CLOCK_50),
    .clock_out(CLOCK_1hz_2),
	 .DIVISOR(28'd25000000)
);

Random random (
	.i_clk(CLOCK_50),
	.i_rst_n(SW[1]),
	.o_random_out(random_num)
);


logic o_button_up;
logic o_button_down;
logic o_button_left;
logic o_button_right;


logic [5:0] ghost_x;
logic [5:0] ghost_y;

GhostAlgo (
    .i_clk(CLOCK_1hz),
    .i_rst(SW[0]),
    .pac_x(pac_x),
    .pac_y(pac_y),
	 .random(random_num),
    .o_x_location(ghost_x),
    .o_y_location(ghost_y),
    .reach(LEDR[17])
);

//    0 1 2 3 4
// 0: G 0 0 0 0
// 1: 0 0 0 0 0
// 2: 0 0 0 0 0
// 3: 0 0 0 0 0
// 4: 0 0 0 0 P
logic [5:0] pac_x;
logic [5:0] pac_y;


logic [3:0] command_key;
logic key0down, key1down, key2down, key3down;

Debounce deb0(
	.i_in(KEY[0]), // Record/Pause
	.i_rst_n(SW[3]),
	.i_clk(CLK_12M),
	.o_neg(key0down) 
);

Debounce deb1(
	.i_in(KEY[1]), // Play/Pause
	.i_rst_n(SW[3]),
	.i_clk(CLK_12M),
	.o_neg(key1down) 
);

Debounce deb2(
	.i_in(KEY[2]), // Stop
	.i_rst_n(SW[3]),
	.i_clk(CLK_12M),
	.o_neg(key2down) 
);

Debounce deb3(
	.i_in(KEY[3]), // Stop
	.i_rst_n(SW[3]),
	.i_clk(CLK_12M),
	.o_neg(key3down) 
);


//assign command_key = {SW[17], SW[16], SW[15], SW[14]};

assign command_key = {key1down, key2down, key3down, key4down};

pac_man_move (
	.i_clk(CLOCK_1hz_2),
	.i_rst(SW[0]),
	.command(command_key),
	.p_x(pac_x),
	.p_y(pac_y)
);

SevenHexDecoder seven_dec0(
	.i_hex(pac_x),
	.o_seven_ten(HEX1),
	.o_seven_one(HEX0)
);

SevenHexDecoder seven_dec1(
	.i_hex(pac_y),
	.o_seven_ten(HEX3),
	.o_seven_one(HEX2)
);

SevenHexDecoder seven_dec2(
	.i_hex(ghost_x),
	.o_seven_ten(HEX5),
	.o_seven_one(HEX4)
);

SevenHexDecoder seven_dec3(
	.i_hex(ghost_y),
	.o_seven_ten(HEX7),
	.o_seven_one(HEX6)
);



endmodule
