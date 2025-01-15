`timescale 1ns/1ps
module tb_buffer ();

	logic        clk                  = 0   ;
	logic        busy                 = 0   ;
	logic        reset                = 1   ;
	logic        buffermode           = 0   ;
	logic        wren_b               = 0   ;
	logic        hold_mode            = 0   ;
	logic [ 7:0] w_data               = 0   ;
	logic [14:0] addr_image           = 0   ;
	logic [14:0] addr_kernal          = 400;
	logic [14:0] addr_conv            = 0   ;
	logic [ 4:0] mat_row              = 0   ;
	logic [ 4:0] mat_col              = 0   ;
	logic [ 7:0] data_mat   [3*3-1:0]       ;
	logic [ 7:0] kernal     [3*3-1:0]       ;

	logic [7:0] buffer_image[31:0][0:31];
	logic [7:0] data_mat_exp[ 8:0]      ;

	integer matched      = 0;
	integer miss_matched = 0;

	//---------------------------------------------------------------------------
	//-------------------- REAL IMAGE DATA --------------------------------------
	//---------------------------------------------------------------------------

  assign buffer_image[ 0] = {8'b10000111, 8'b10000110, 8'b10001001, 8'b10001001, 8'b10001001, 8'b10001010, 8'b10001010, 8'b10001001 ,
                             8'b10001010, 8'b10001001, 8'b10001001, 8'b10001011, 8'b10001001, 8'b10001011, 8'b10001011, 8'b10001010 ,
                             8'b10001011, 8'b10001010, 8'b10001011, 8'b10001100, 8'b10001100, 8'b10001100, 8'b10001100, 8'b10001011 ,
                             8'b10001010, 8'b10001011, 8'b10001011, 8'b10001011, 8'b10001010, 8'b10001010, 8'b10001001, 8'b10001000};
  assign buffer_image[ 1] = {8'b10001001, 8'b10001001, 8'b10001011, 8'b10001011, 8'b10001011, 8'b10001011, 8'b10001100, 8'b10001011 ,
                             8'b10001100, 8'b10001101, 8'b10001100, 8'b10001101, 8'b10001100, 8'b10001101, 8'b10001101, 8'b10001101 ,
                             8'b10001101, 8'b10001110, 8'b10001110, 8'b10001110, 8'b10001110, 8'b10001100, 8'b10001100, 8'b10001110 ,
                             8'b10001110, 8'b10001110, 8'b10001100, 8'b10001100, 8'b10001101, 8'b10001101, 8'b10001100, 8'b10001010};
  assign buffer_image[ 2] = {8'b10011101, 8'b10011101, 8'b10011010, 8'b10011101, 8'b10011110, 8'b10011101, 8'b10011110, 8'b10011101 ,
                             8'b10011101, 8'b10011110, 8'b10011101, 8'b10011101, 8'b10011100, 8'b10011111, 8'b10100000, 8'b10011111 ,
                             8'b10011110, 8'b10011110, 8'b10011110, 8'b10011110, 8'b10011111, 8'b10011111, 8'b10011111, 8'b10011110 ,
                             8'b10011111, 8'b10100000, 8'b10100001, 8'b10100000, 8'b10100000, 8'b10100001, 8'b10011110, 8'b10011100};
  assign buffer_image[ 3] = {8'b10100010, 8'b10011110, 8'b10011100, 8'b10100000, 8'b10100001, 8'b10100010, 8'b10100001, 8'b10100001 ,
                             8'b10100001, 8'b10100001, 8'b10100001, 8'b10100010, 8'b10100011, 8'b10100011, 8'b10100110, 8'b10100111 ,
                             8'b10100100, 8'b10100010, 8'b10100010, 8'b10100100, 8'b10100011, 8'b10100100, 8'b10100101, 8'b10100011 ,
                             8'b10100011, 8'b10100100, 8'b10100110, 8'b10100101, 8'b10100011, 8'b10100001, 8'b10100100, 8'b10100010};
  assign buffer_image[ 4] = {8'b10101001, 8'b10101000, 8'b10100111, 8'b10101000, 8'b10101001, 8'b10101001, 8'b10101000, 8'b10101000 ,
                             8'b10101010, 8'b10101010, 8'b10101001, 8'b10101001, 8'b10111111, 8'b10001110, 8'b01110110, 8'b10101110 ,
                             8'b10110010, 8'b10101100, 8'b10101100, 8'b10101100, 8'b10101101, 8'b10101101, 8'b10101101, 8'b10101100 ,
                             8'b10101010, 8'b10110010, 8'b10100010, 8'b10100010, 8'b10110000, 8'b10101110, 8'b10110001, 8'b10101011};
  assign buffer_image[ 5] = {8'b10110011, 8'b10110011, 8'b10110001, 8'b10110010, 8'b10110011, 8'b10110011, 8'b10110100, 8'b10110010 ,
                             8'b10110010, 8'b10110011, 8'b10110010, 8'b11000100, 8'b10111111, 8'b10100000, 8'b01010110, 8'b01100100 ,
                             8'b10101011, 8'b10111101, 8'b10110110, 8'b10110111, 8'b10110111, 8'b10110111, 8'b10110101, 8'b10111001 ,
                             8'b10111101, 8'b10110001, 8'b10100110, 8'b01101111, 8'b10011011, 8'b10111101, 8'b10111010, 8'b10110111};
  assign buffer_image[ 6] = {8'b11000010, 8'b11000001, 8'b11000000, 8'b11000010, 8'b11000010, 8'b11000011, 8'b11000101, 8'b11000011 ,
                             8'b11000100, 8'b11000100, 8'b11001101, 8'b10111000, 8'b10100101, 8'b10111100, 8'b01101011, 8'b01001100 ,
                             8'b01100010, 8'b10100101, 8'b11000101, 8'b11001011, 8'b11000111, 8'b11000110, 8'b11000101, 8'b10111111 ,
                             8'b10101101, 8'b10100111, 8'b10111010, 8'b01100001, 8'b01011010, 8'b10110010, 8'b11001010, 8'b11000111};
  assign buffer_image[ 7] = {8'b11010011, 8'b11010000, 8'b11010000, 8'b11010010, 8'b11010011, 8'b11010101, 8'b11010011, 8'b11010100 ,
                             8'b11010010, 8'b11010101, 8'b11000111, 8'b10100010, 8'b11000110, 8'b10011010, 8'b01011100, 8'b01010110 ,
                             8'b01001111, 8'b01010011, 8'b01110110, 8'b10110101, 8'b11010000, 8'b11010001, 8'b11010110, 8'b10011101 ,
                             8'b10101001, 8'b11001001, 8'b10011111, 8'b01101110, 8'b01001111, 8'b01011101, 8'b10110010, 8'b11000101};
  assign buffer_image[ 8] = {8'b11010110, 8'b11010100, 8'b11011100, 8'b11011010, 8'b11011100, 8'b11010110, 8'b11101000, 8'b11001100 ,
                             8'b11001011, 8'b11010000, 8'b10110011, 8'b11000001, 8'b10010100, 8'b01110110, 8'b01011111, 8'b01011011 ,
                             8'b01010100, 8'b01010100, 8'b01101001, 8'b01011111, 8'b01100011, 8'b10011000, 8'b10101001, 8'b10100000 ,
                             8'b11010111, 8'b10100010, 8'b10000011, 8'b01110000, 8'b01011101, 8'b10100010, 8'b10101001, 8'b01101010};
  assign buffer_image[ 9] = {8'b11010101, 8'b11011001, 8'b11011100, 8'b10010001, 8'b10000011, 8'b10000010, 8'b01101001, 8'b01000010 ,
                             8'b01110000, 8'b11001110, 8'b11001010, 8'b10100101, 8'b01110101, 8'b01111100, 8'b01011101, 8'b01011000 ,
                             8'b01010001, 8'b10001010, 8'b11011010, 8'b01111011, 8'b00100111, 8'b01011000, 8'b10011010, 8'b11010111 ,
                             8'b10101011, 8'b10000100, 8'b01111100, 8'b01110100, 8'b10110010, 8'b10110101, 8'b10000010, 8'b01101001};
  assign buffer_image[10] = {8'b10110101, 8'b10011101, 8'b11011010, 8'b01110111, 8'b00110111, 8'b10100111, 8'b01011110, 8'b00010111 ,
                             8'b00010100, 8'b10110111, 8'b11010000, 8'b01111110, 8'b01111101, 8'b01100011, 8'b01101000, 8'b01101111 ,
                             8'b10001010, 8'b11100000, 8'b11100010, 8'b10011110, 8'b00110100, 8'b00100011, 8'b11010011, 8'b11000000 ,
                             8'b10000001, 8'b10000110, 8'b10010001, 8'b11000110, 8'b10101001, 8'b10001100, 8'b01110100, 8'b10010010}; 
  assign buffer_image[11] = {8'b10011111, 8'b01010101, 8'b10001111, 8'b10111101, 8'b10011110, 8'b01011010, 8'b01001100, 8'b00110100 ,
                             8'b00011110, 8'b10000011, 8'b10110110, 8'b01111100, 8'b01100001, 8'b10001001, 8'b10111110, 8'b10011011 ,
                             8'b10110111, 8'b11101110, 8'b11010011, 8'b10010001, 8'b01010100, 8'b00001110, 8'b01100100, 8'b10011011 ,
                             8'b10010101, 8'b10101100, 8'b10101101, 8'b10100001, 8'b10010100, 8'b01110011, 8'b10001101, 8'b10110011};
  assign buffer_image[12] = {8'b01110111, 8'b01011001, 8'b01101001, 8'b01011111, 8'b10001110, 8'b10100100, 8'b01010100, 8'b10010100 ,
                             8'b00101101, 8'b01110010, 8'b10011101, 8'b01110111, 8'b10010011, 8'b11001001, 8'b01111010, 8'b01000000 ,
                             8'b10011001, 8'b11011111, 8'b11001001, 8'b10001111, 8'b01101011, 8'b00101011, 8'b00100101, 8'b00110001 ,
                             8'b10001001, 8'b11011111, 8'b10010011, 8'b10111001, 8'b10010100, 8'b10000001, 8'b10101100, 8'b10000010};
  assign buffer_image[13] = {8'b01101011, 8'b01011110, 8'b01101110, 8'b01010110, 8'b01010100, 8'b11000000, 8'b11001101, 8'b10001011 ,
                             8'b00011000, 8'b10000100, 8'b10000111, 8'b01111110, 8'b11100111, 8'b10011011, 8'b00111110, 8'b01111001 ,
                             8'b11101000, 8'b11011001, 8'b10111110, 8'b10110000, 8'b10000011, 8'b01110010, 8'b01110010, 8'b01110101 ,
                             8'b00101100, 8'b10001001, 8'b10111101, 8'b10100111, 8'b10100010, 8'b10111111, 8'b10011010, 8'b01011000};
  assign buffer_image[14] = {8'b01101010, 8'b01011100, 8'b01101101, 8'b01101100, 8'b10110110, 8'b11011010, 8'b10110101, 8'b01100011 ,
                             8'b00101101, 8'b01000010, 8'b01101001, 8'b10110010, 8'b11011011, 8'b01101101, 8'b01001010, 8'b10100100 ,
                             8'b11101101, 8'b11101001, 8'b11101010, 8'b11011000, 8'b10011101, 8'b01110000, 8'b01101001, 8'b10010101 ,
                             8'b01100110, 8'b00100101, 8'b10010001, 8'b10111111, 8'b10110011, 8'b10101001, 8'b10011111, 8'b01100010};
  assign buffer_image[15] = {8'b01011011, 8'b01101011, 8'b10011111, 8'b10100101, 8'b10100110, 8'b10011011, 8'b01101100, 8'b10011111 ,
                             8'b01010000, 8'b01011000, 8'b10010101, 8'b11001111, 8'b11010111, 8'b01100111, 8'b01100011, 8'b01010110 ,
                             8'b11000011, 8'b11011111, 8'b11001100, 8'b10111001, 8'b10100000, 8'b01010110, 8'b00010011, 8'b01101001 ,
                             8'b10100010, 8'b00101101, 8'b00100011, 8'b11000010, 8'b10011101, 8'b10110110, 8'b10011001, 8'b01100101};
  assign buffer_image[16] = {8'b10010000, 8'b10110100, 8'b10001110, 8'b01011111, 8'b01101001, 8'b01110000, 8'b01011000, 8'b10011000 ,
                             8'b10011100, 8'b10111010, 8'b11000001, 8'b11000100, 8'b11010100, 8'b01101010, 8'b01001100, 8'b00011011 ,
                             8'b01101001, 8'b10110101, 8'b10011101, 8'b01111010, 8'b01001101, 8'b00011011, 8'b00000101, 8'b01100100 ,
                             8'b11001100, 8'b00111010, 8'b00101110, 8'b10010010, 8'b10101010, 8'b10011100, 8'b01111111, 8'b01101101};
  assign buffer_image[17] = {8'b10110100, 8'b10101101, 8'b10000000, 8'b01100110, 8'b01101000, 8'b01101110, 8'b01100101, 8'b01000111 ,
                             8'b01101110, 8'b10100001, 8'b10011010, 8'b01100100, 8'b10111101, 8'b01011110, 8'b00110110, 8'b00010101 ,
                             8'b00011011, 8'b01101001, 8'b01101010, 8'b00110110, 8'b00001110, 8'b00000110, 8'b00000101, 8'b01010111 ,
                             8'b11011010, 8'b01001011, 8'b00101110, 8'b10001111, 8'b10110000, 8'b01110101, 8'b10000111, 8'b10101010};
  assign buffer_image[18] = {8'b10110111, 8'b10111000, 8'b01111011, 8'b01110101, 8'b01101000, 8'b01101011, 8'b01100110, 8'b10000100 ,
                             8'b10000101, 8'b01010101, 8'b01000011, 8'b01000001, 8'b01100000, 8'b10010100, 8'b01100110, 8'b00110011 ,
                             8'b00000110, 8'b00011101, 8'b00100000, 8'b00000110, 8'b00000111, 8'b01001011, 8'b00100110, 8'b00111011 ,
                             8'b11101000, 8'b01010111, 8'b00111100, 8'b10000100, 8'b10000011, 8'b10000111, 8'b10101100, 8'b10110011};
  assign buffer_image[19] = {8'b10100011, 8'b10000001, 8'b10011000, 8'b01101100, 8'b01110011, 8'b01100111, 8'b01111101, 8'b10111010 ,
                             8'b11000001, 8'b10000101, 8'b01110110, 8'b10110100, 8'b01001111, 8'b01101011, 8'b10100010, 8'b00010101 ,
                             8'b00111001, 8'b00111101, 8'b01000110, 8'b01101010, 8'b10100000, 8'b10111000, 8'b00111001, 8'b00001110 ,
                             8'b10100010, 8'b01101000, 8'b00101110, 8'b00110110, 8'b10000110, 8'b10100000, 8'b10110010, 8'b11000101};
  assign buffer_image[20] = {8'b01111000, 8'b01100101, 8'b10010000, 8'b01101111, 8'b01110000, 8'b10001011, 8'b10101100, 8'b10100101 ,
                             8'b10010011, 8'b01111001, 8'b10110101, 8'b11010101, 8'b01101101, 8'b00111001, 8'b10001111, 8'b00110111 ,
                             8'b10100011, 8'b10001111, 8'b11010101, 8'b11000100, 8'b10011001, 8'b10100101, 8'b01111110, 8'b00000110 ,
                             8'b00101001, 8'b00111100, 8'b00101110, 8'b00110100, 8'b10010111, 8'b10111110, 8'b11000010, 8'b10010110}; 
  assign buffer_image[21] = {8'b01100101, 8'b01101100, 8'b10000100, 8'b01101010, 8'b10110001, 8'b10101010, 8'b10000001, 8'b10100011 ,
                             8'b10000110, 8'b10110101, 8'b11001111, 8'b10001100, 8'b01110111, 8'b00100111, 8'b10000111, 8'b00111100 ,
                             8'b01110111, 8'b11000001, 8'b10110110, 8'b10000001, 8'b10011111, 8'b11011001, 8'b11000001, 8'b00010011 ,
                             8'b00100011, 8'b01101101, 8'b00111000, 8'b01100011, 8'b11000100, 8'b11001110, 8'b10000011, 8'b10000101};
  assign buffer_image[22] = {8'b01011111, 8'b01011110, 8'b10000111, 8'b11000111, 8'b10010111, 8'b01111000, 8'b10011011, 8'b10011110 ,
                             8'b11000000, 8'b10110100, 8'b10000010, 8'b10001000, 8'b10000101, 8'b00111111, 8'b01110010, 8'b01011000 ,
                             8'b11000001, 8'b11000010, 8'b10001110, 8'b10010010, 8'b11000100, 8'b10110011, 8'b10010101, 8'b00101010 ,
                             8'b01000100, 8'b11010100, 8'b10011011, 8'b01000100, 8'b11001010, 8'b10001100, 8'b10000101, 8'b10100001};
  assign buffer_image[23] = {8'b01101110, 8'b10001111, 8'b11001110, 8'b10101000, 8'b01110001, 8'b10011000, 8'b10111100, 8'b11001011 ,
                             8'b10100111, 8'b10000110, 8'b01101100, 8'b10001000, 8'b11000001, 8'b10000001, 8'b01110011, 8'b10000000 ,
                             8'b11000100, 8'b10100011, 8'b10000111, 8'b10111110, 8'b10111100, 8'b10001101, 8'b10010010, 8'b00110110 ,
                             8'b01001101, 8'b10110100, 8'b10101000, 8'b01010011, 8'b01101100, 8'b01101111, 8'b10100001, 8'b10111100};
  assign buffer_image[24] = {8'b11000000, 8'b11000010, 8'b10100110, 8'b10000101, 8'b10101101, 8'b11001001, 8'b10101100, 8'b01111111 ,
                             8'b10000111, 8'b01111110, 8'b10010111, 8'b10111111, 8'b10110101, 8'b01111111, 8'b01111100, 8'b01101111 ,
                             8'b10010100, 8'b10001100, 8'b10110011, 8'b11001010, 8'b10011110, 8'b10011010, 8'b10111100, 8'b01010100 ,
                             8'b00111011, 8'b10110010, 8'b11000110, 8'b01011000, 8'b01001111, 8'b10100111, 8'b11000100, 8'b10101010};
  assign buffer_image[25] = {8'b10101110, 8'b10010111, 8'b11000000, 8'b11001110, 8'b11001011, 8'b10011110, 8'b10001000, 8'b10001111 ,
                             8'b10010110, 8'b10111001, 8'b11001001, 8'b10100100, 8'b10110011, 8'b10100000, 8'b01010000, 8'b01100000 ,
                             8'b10010111, 8'b10111000, 8'b11001110, 8'b10100100, 8'b10110010, 8'b11001010, 8'b10111000, 8'b00101100 ,
                             8'b10010000, 8'b11010000, 8'b10110010, 8'b01100111, 8'b10011011, 8'b11010101, 8'b10110101, 8'b10100110};
  assign buffer_image[26] = {8'b11100000, 8'b11100100, 8'b11100110, 8'b11100010, 8'b11011110, 8'b11100001, 8'b11100111, 8'b11100011 ,
                             8'b11100101, 8'b11100111, 8'b11100000, 8'b11100010, 8'b11100101, 8'b11010000, 8'b01010100, 8'b10010001 ,
                             8'b11100011, 8'b11100101, 8'b11100000, 8'b11100011, 8'b11100110, 8'b11101000, 8'b10100010, 8'b01001001 ,
                             8'b11100011, 8'b11100011, 8'b11100111, 8'b10000000, 8'b11001100, 8'b11100011, 8'b11100000, 8'b11100010};
  assign buffer_image[27] = {8'b11010111, 8'b11010111, 8'b11011000, 8'b11011010, 8'b10110010, 8'b01110001, 8'b10111001, 8'b11011110 ,
                             8'b10101110, 8'b11000010, 8'b11011011, 8'b11011001, 8'b11011011, 8'b11010001, 8'b01011011, 8'b10001011 ,
                             8'b11011011, 8'b11011011, 8'b11011100, 8'b11011100, 8'b11011101, 8'b11100000, 8'b01010001, 8'b10101000 ,
                             8'b11100001, 8'b11011101, 8'b11011110, 8'b10010100, 8'b11010110, 8'b11011110, 8'b11011111, 8'b11100000};
  assign buffer_image[28] = {8'b10111100, 8'b10111110, 8'b10111110, 8'b10110101, 8'b10011001, 8'b10001101, 8'b10011110, 8'b11000000 ,
                             8'b10101110, 8'b10110000, 8'b11000100, 8'b11000011, 8'b11000011, 8'b10110000, 8'b01100111, 8'b01111000 ,
                             8'b11000110, 8'b11000110, 8'b11000100, 8'b11000101, 8'b11001010, 8'b01111101, 8'b01001001, 8'b11000011 ,
                             8'b10110101, 8'b10110000, 8'b10101001, 8'b01111100, 8'b10101001, 8'b10101011, 8'b10101011, 8'b10101101};
  assign buffer_image[29] = {8'b10111100, 8'b10100010, 8'b10111100, 8'b11001011, 8'b11100011, 8'b10100110, 8'b10010110, 8'b11001010 ,
                             8'b11001000, 8'b11000110, 8'b11000011, 8'b11000111, 8'b10110011, 8'b01110110, 8'b01110010, 8'b01011100 ,
                             8'b10000110, 8'b10000011, 8'b10001001, 8'b10000110, 8'b01110101, 8'b00110110, 8'b01010010, 8'b01011011 ,
                             8'b01010110, 8'b01010000, 8'b01110101, 8'b00111111, 8'b00101100, 8'b00111111, 8'b00111110, 8'b00111111};
  assign buffer_image[30] = {8'b10110011, 8'b10110110, 8'b11001100, 8'b11010000, 8'b10110101, 8'b01000110, 8'b00011000, 8'b10001011 ,
                             8'b10111001, 8'b11000000, 8'b11000010, 8'b11000100, 8'b11000000, 8'b10111110, 8'b10110011, 8'b10101010 ,
                             8'b10101100, 8'b10101101, 8'b11000001, 8'b11000111, 8'b10101110, 8'b11000111, 8'b11000010, 8'b10111101 ,
                             8'b11010001, 8'b10101100, 8'b10010000, 8'b10101111, 8'b10111011, 8'b11000110, 8'b10110111, 8'b10111011}; 
  assign buffer_image[31] = {8'b10101011, 8'b10111000, 8'b10100110, 8'b10001001, 8'b01101111, 8'b01010110, 8'b01011010, 8'b01011000 ,
                             8'b01101011, 8'b10100010, 8'b11000001, 8'b11000010, 8'b11000100, 8'b10111011, 8'b10111000, 8'b10110100 ,
                             8'b10111010, 8'b11000111, 8'b11011111, 8'b10101100, 8'b00111100, 8'b10000010, 8'b10110100, 8'b11001101 ,
                             8'b11001100, 8'b10001001, 8'b01000011, 8'b01100100, 8'b10100010, 8'b11000111, 8'b10010011, 8'b10000110};

	buffer #(
		.WIDTH       (32),
		.HEIGHT      (32),
		.K_WIDTH     (3 ),
		.K_HEIGHT    (3 ),
		.ADDR_W      (5 ),
		.ADDR_H      (5 ),
		.COLOUR_DEPTH(8 ),
		.MEMORY_ADDR (15)
	) i_buffer (
		.clk        (clk        ),
		.busy       (busy       ),
		.reset      (reset      ),
		.buffermode (buffermode ),
		.wren_b     (wren_b     ),
		.hold_mode  (hold_mode  ),
		.w_data     (w_data     ),
		.addr_image (addr_image ),
		.addr_kernal(addr_kernal),
		.addr_conv  (addr_conv  ),
		.mat_row    (mat_row    ),
		.mat_col    (mat_col    ),
		.data_mat   (data_mat   ),
		.kernal     (kernal     )
	);

always #5 clk <= ~clk;


//-------------------------------------------------------------------------------------
//------ THE COUNTER TO SELECT THE ROW AND COLUMN TO PERFORM CONVOLUTION --------------
//-------------------------------------------------------------------------------------

always_ff @(posedge clk) begin
	if(wren_b) begin
		if (mat_col == 5'b11111) begin
			mat_col <= 0;
			mat_row <= mat_row + 1;
		end
		else begin
			mat_col <= mat_col + 1;
		end
	end
	else begin
		mat_col <= 0;
		mat_row <= 0;
	end
end

//-------------------------------------------------------------------------------------
//-------------- THE EXPECTED OUTPUT GENERATION ---------------------------------------
//-------------------------------------------------------------------------------------

always_ff @(posedge clk) begin
	if(wren_b)begin
		casez ({mat_row, mat_col})
      10'b00000_00000 : {data_mat_exp[8], data_mat_exp[7], data_mat_exp[6], data_mat_exp[5], data_mat_exp[4], data_mat_exp[3], data_mat_exp[2], data_mat_exp[1], data_mat_exp[0]} 
                                     <= {buffer_image[mat_row  ][mat_col  ], buffer_image[mat_row  ][mat_col], buffer_image[mat_row  ][mat_col+1] ,
                                         buffer_image[mat_row  ][mat_col  ], buffer_image[mat_row  ][mat_col], buffer_image[mat_row  ][mat_col+1] ,
                                         buffer_image[mat_row+1][mat_col  ], buffer_image[mat_row+1][mat_col], buffer_image[mat_row+1][mat_col+1]};
     
      10'b00000_11111 : {data_mat_exp[8], data_mat_exp[7], data_mat_exp[6], data_mat_exp[5], data_mat_exp[4], data_mat_exp[3], data_mat_exp[2], data_mat_exp[1], data_mat_exp[0]} 
                                     <= {buffer_image[mat_row  ][mat_col-1], buffer_image[mat_row  ][mat_col], buffer_image[mat_row  ][mat_col  ] ,
                                         buffer_image[mat_row  ][mat_col-1], buffer_image[mat_row  ][mat_col], buffer_image[mat_row  ][mat_col  ] ,
                                         buffer_image[mat_row+1][mat_col-1], buffer_image[mat_row+1][mat_col], buffer_image[mat_row+1][mat_col  ]};
     
      10'b11111_00000: {data_mat_exp[8], data_mat_exp[7], data_mat_exp[6], data_mat_exp[5], data_mat_exp[4], data_mat_exp[3], data_mat_exp[2], data_mat_exp[1], data_mat_exp[0]} 
                                     <= {buffer_image[mat_row-1][mat_col  ], buffer_image[mat_row-1][mat_col], buffer_image[mat_row-1][mat_col+1] ,
                                         buffer_image[mat_row  ][mat_col  ], buffer_image[mat_row  ][mat_col], buffer_image[mat_row  ][mat_col+1] ,
                                         buffer_image[mat_row  ][mat_col  ], buffer_image[mat_row  ][mat_col], buffer_image[mat_row  ][mat_col+1]};
     
      10'b11111_11111 : {data_mat_exp[8], data_mat_exp[7], data_mat_exp[6], data_mat_exp[5], data_mat_exp[4], data_mat_exp[3], data_mat_exp[2], data_mat_exp[1], data_mat_exp[0]} 
                                     <= {buffer_image[mat_row-1][mat_col-1], buffer_image[mat_row-1][mat_col], buffer_image[mat_row-1][mat_col  ] ,
                                         buffer_image[mat_row  ][mat_col-1], buffer_image[mat_row  ][mat_col], buffer_image[mat_row  ][mat_col  ] ,
                                         buffer_image[mat_row  ][mat_col-1], buffer_image[mat_row  ][mat_col], buffer_image[mat_row  ][mat_col  ]};
     
      10'b00000_????? : {data_mat_exp[8], data_mat_exp[7], data_mat_exp[6], data_mat_exp[5], data_mat_exp[4], data_mat_exp[3], data_mat_exp[2], data_mat_exp[1], data_mat_exp[0]} 
                                     <= {buffer_image[mat_row  ][mat_col-1], buffer_image[mat_row  ][mat_col], buffer_image[mat_row  ][mat_col+1] ,
                                         buffer_image[mat_row  ][mat_col-1], buffer_image[mat_row  ][mat_col], buffer_image[mat_row  ][mat_col+1] ,
                                         buffer_image[mat_row+1][mat_col-1], buffer_image[mat_row+1][mat_col], buffer_image[mat_row+1][mat_col+1]};
     
      10'b11111_????? : {data_mat_exp[8], data_mat_exp[7], data_mat_exp[6], data_mat_exp[5], data_mat_exp[4], data_mat_exp[3], data_mat_exp[2], data_mat_exp[1], data_mat_exp[0]} 
                                     <= {buffer_image[mat_row-1][mat_col-1], buffer_image[mat_row-1][mat_col], buffer_image[mat_row-1][mat_col+1] ,
                                         buffer_image[mat_row  ][mat_col-1], buffer_image[mat_row  ][mat_col], buffer_image[mat_row  ][mat_col+1] ,
                                         buffer_image[mat_row  ][mat_col-1], buffer_image[mat_row  ][mat_col], buffer_image[mat_row  ][mat_col+1]};
     
      10'b?????_11111 : {data_mat_exp[8], data_mat_exp[7], data_mat_exp[6], data_mat_exp[5], data_mat_exp[4], data_mat_exp[3], data_mat_exp[2], data_mat_exp[1], data_mat_exp[0]} 
                                     <= {buffer_image[mat_row-1][mat_col-1], buffer_image[mat_row-1][mat_col], buffer_image[mat_row-1][mat_col  ] ,
                                         buffer_image[mat_row  ][mat_col-1], buffer_image[mat_row  ][mat_col], buffer_image[mat_row  ][mat_col  ] ,
                                         buffer_image[mat_row+1][mat_col-1], buffer_image[mat_row+1][mat_col], buffer_image[mat_row+1][mat_col  ]};
     
      10'b?????_00000 : {data_mat_exp[8], data_mat_exp[7], data_mat_exp[6], data_mat_exp[5], data_mat_exp[4], data_mat_exp[3], data_mat_exp[2], data_mat_exp[1], data_mat_exp[0]} 
                                     <= {buffer_image[mat_row-1][mat_col  ], buffer_image[mat_row-1][mat_col], buffer_image[mat_row-1][mat_col+1] ,
                                         buffer_image[mat_row  ][mat_col  ], buffer_image[mat_row  ][mat_col], buffer_image[mat_row  ][mat_col+1] ,
                                         buffer_image[mat_row+1][mat_col  ], buffer_image[mat_row+1][mat_col], buffer_image[mat_row+1][mat_col+1]};
     
			default         : {data_mat_exp[8], data_mat_exp[7], data_mat_exp[6], data_mat_exp[5], data_mat_exp[4], data_mat_exp[3], data_mat_exp[2], data_mat_exp[1], data_mat_exp[0]} 
			                               <= {buffer_image[mat_row-1][mat_col-1], buffer_image[mat_row-1][mat_col], buffer_image[mat_row-1][mat_col+1] ,
                                         buffer_image[mat_row  ][mat_col-1], buffer_image[mat_row  ][mat_col], buffer_image[mat_row  ][mat_col+1] ,
                                         buffer_image[mat_row+1][mat_col-1], buffer_image[mat_row+1][mat_col], buffer_image[mat_row+1][mat_col+1]};
		endcase
	end 
	else 
		{data_mat_exp[8], data_mat_exp[7], data_mat_exp[6], data_mat_exp[5], data_mat_exp[4], data_mat_exp[3], data_mat_exp[2], data_mat_exp[1], data_mat_exp[0]} <= 0;
end

//------------------------------------------------------------------------------------------------
//------ THE INPUTS GIVEN IN A PARTICULAR ORDER AS SHOULD BE SEND BY THE TOP MODULE --------------
//------------------------------------------------------------------------------------------------

initial begin
	#10  reset      = 0      ;
	     addr_image = 0      ;
	     addr_kernal= 15'h400;
	     addr_conv  = 15'h400;
	#10  busy       = 1      ;
	     buffermode = 1      ;
	#90  buffermode = 0      ;
	     hold_mode  = 1      ;
	#275 hold_mode  = 0      ;
	     wren_b     = 1      ;
	repeat (1024) @(posedge clk);
	$display("matched = %d", matched);
	$display("miss_matched = %d",miss_matched);
	$stop;
end

//-------------------------------------------------------------------------------------
//----------- COMPARING THE OUTPUT WITH THE EXPECTED OUTPUT ---------------------------
//-------------------------------------------------------------------------------------

always_ff @(negedge clk) begin
	if (wren_b) begin 
		if ({data_mat[8], data_mat[7], data_mat[6], data_mat[5], data_mat[4], data_mat[3], data_mat[2], data_mat[1], data_mat[0]} == 
			  {data_mat_exp[8], data_mat_exp[7], data_mat_exp[6], data_mat_exp[5], data_mat_exp[4], data_mat_exp[3], data_mat_exp[2], data_mat_exp[1], data_mat_exp[0]})
			matched <= matched + 1;
		else
			miss_matched <= miss_matched + 1;
  end
end

endmodule 