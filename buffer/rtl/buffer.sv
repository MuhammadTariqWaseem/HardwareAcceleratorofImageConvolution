module buffer #(
	parameter WIDTH        = 32,
	parameter HEIGHT       = 32,
	parameter K_WIDTH      = 3 ,
	parameter K_HEIGHT     = 3 ,
	parameter ADDR_W       = 5 ,
	parameter ADDR_H       = 5 ,
	parameter COLOUR_DEPTH = 8 ,
  parameter MEMORY_ADDR  = 11
) (
	input  logic                    clk                            ,
	input  logic                    busy                           ,
	input  logic                    reset                          ,
	input  logic                    buffermode                     ,
	input  logic                    wren_b                         ,
	input  logic                    hold_mode                      ,
	input  logic [COLOUR_DEPTH-1:0] w_data                         ,
	input  logic [ MEMORY_ADDR-1:0] addr_image                     ,
	input  logic [ MEMORY_ADDR-1:0] addr_kernal                    ,
	input  logic [ MEMORY_ADDR-1:0] addr_conv                      ,
	input  logic [      ADDR_H-1:0] mat_row                        ,
	input  logic [      ADDR_W-1:0] mat_col                        ,
	output logic [COLOUR_DEPTH-1:0] data_mat [K_WIDTH*K_HEIGHT-1:0],
	output logic [COLOUR_DEPTH-1:0] kernal   [K_WIDTH*K_HEIGHT-1:0]
);

logic                    buffermode_d  ;
logic                    buffermode_2d ;
logic [COLOUR_DEPTH-1:0] data_port_a   ;
logic [COLOUR_DEPTH-1:0] data_port_b   ;
logic [ MEMORY_ADDR-1:0] address_port_a;
logic [ MEMORY_ADDR-1:0] address_port_b;

//********************************************************************
//************** BUFFER INITIALIZATION *******************************
//********************************************************************

logic [COLOUR_DEPTH-1:0] buffer [K_HEIGHT:0][WIDTH-1:0];

logic [   ADDR_H+ADDR_W  :0] offset_image ;
logic [K_HEIGHT*K_WIDTH-1:0] offset_kernal;
logic [   ADDR_H+ADDR_W-1:0] offset_conv  ;

logic [  ADDR_W:0] real_image_col;
logic [ADDR_H-1:0] conv_image_row;
logic [ADDR_W-1:0] conv_image_col;
logic [ K_WIDTH:0] buffer_col    ;

logic [ADDR_H-1:0]f_row;
logic [ADDR_H-1:0]l_row;
logic [ADDR_H-1:0]e_row;
logic [ADDR_W-1:0]f_col;
logic [ADDR_W-1:0]l_col;
logic [ADDR_W-1:0]e_col;
logic [ADDR_H-1:0]uk_row;
logic [ADDR_W-1:0]uk_col;

assign f_row  = 0;
assign f_col  = 0;
assign l_row  = (1 << (ADDR_H)) -1;
assign l_col  = (1 << (ADDR_W)) -1;
assign e_row  = (1 << (ADDR_H)) -2;
assign e_col  = (1 << (ADDR_W)) -2;
assign uk_col = 'b?;
assign uk_row = 'b?;

//********************************************************************
//****************** DATA FETChING FROM MEMORY ***********************
//********************************************************************

always_ff @(posedge clk or posedge reset) begin
	if(reset) offset_image <= 0;
	else begin
		if(busy) begin
			if (offset_image == (1 << (ADDR_W+ADDR_H))) 
				offset_image <= offset_image    ; 
			else                         
				offset_image <= offset_image + 1;
		end
		else offset_image <= 0;
	end
end

always_ff @(posedge clk or posedge reset) begin
	if(reset) 
		address_port_a <= addr_image;
	else if(busy) 
	  address_port_a <= addr_image + offset_image;
end

//********************************************************************
//****************** DATA STORING IN BUFFER **************************
//********************************************************************

always_ff @(posedge clk or posedge reset) begin
	if (reset) begin
		for (int i = 0; i < K_HEIGHT; i++) begin
			for (int j = 0; j < WIDTH; j++) begin
				buffer[i][j] <= 0;
			end
		end
  end
	else begin
		if (real_image_col == ((1 << ADDR_W) + 1)) begin               
			for (int i = 0; i < K_HEIGHT; i++) begin
				for (int j = 0; j < WIDTH; j++) begin
				buffer[i][j] <= buffer[i+1][j];
			  end
			end
			buffer[K_HEIGHT-1][WIDTH-1] <= data_port_a;
		end
		else if(offset_image != (1 << (ADDR_W+ADDR_H)) + 1)          
			buffer[K_HEIGHT][real_image_col-2] <= data_port_a;
		else 
			buffer[K_HEIGHT][real_image_col-2] <= 0;
	end
end

always_ff @(posedge clk or posedge reset) begin 
	if (reset) real_image_col <= 0;
	else begin
		if(real_image_col == ((1 << ADDR_W) + 1))            
			real_image_col <= 2                 ;            
		else if ((busy)&(offset_image != (1 << (ADDR_W+ADDR_H)) + 1))   
	    real_image_col <= real_image_col + 1;
		else
			real_image_col <= 0                 ;
	end
end

//********************************************************************
//************ KERNAL DATA FETCHING FROM MEMORY **********************
//********************************************************************

always_ff @(posedge clk or posedge reset) begin
	if(reset) offset_kernal <= 0;
	else begin
		if(buffermode | buffermode_d) offset_kernal <= offset_kernal+1;
    else                          offset_kernal <= 0              ;
	end
end

always_ff @(posedge clk or posedge reset) begin 
	if (reset) address_port_b <= addr_kernal;
	else begin
		if (buffermode)
	    address_port_b <= addr_kernal + offset_kernal;
	  else if (hold_mode)
	  	address_port_b <= addr_conv                  ;
	  else if (wren_b)
	  	address_port_b <= addr_conv + offset_conv    ;
	  else 
	  	address_port_b <=  addr_kernal               ;
	end
end

//********************************************************************
//******** KERNAL DATA STORING IN MATRIX FORM ************************
//********************************************************************

always_ff @(posedge clk) begin
	buffermode_d <= buffermode;
	buffermode_2d <= buffermode_d;
end

always_comb begin
	if (reset) begin
		for (int k = 0; k < K_HEIGHT*K_WIDTH; k++) begin
			kernal[k] <= 0;
		end
	end 
	else if (buffermode_2d) 
		kernal[buffer_col-2] = data_port_b;
end

always_ff @(posedge clk or posedge reset) begin 
  if (reset) buffer_col <= 0;
  else begin
  	if(buffermode | buffermode_d) 
			buffer_col <= buffer_col + 1;
	  else 
	  	buffer_col <= 0;
  end
end

//********************************************************************
//******** CONVOLUTED DATA STORING IN MEMORY *************************
//********************************************************************

always_ff @(posedge clk or posedge reset) begin 
	if(reset) offset_conv <= 0;
	else begin
		if(wren_b)
		  offset_conv <= offset_conv + 1;
		else 
		  offset_conv <= 0              ;
	end
end

//********************************************************************
//************* OUTPUT LOGIC OF DATA MATRIX **************************
//********************************************************************

always_ff @(posedge clk or posedge reset) begin
	if (reset) begin
		for (int l = 0; l < K_HEIGHT*K_WIDTH; l++) begin
			data_mat[l] <= 0;
		end
	end
	else begin 
		/*casez ({mat_row,mat_col})
			10'b00000_00000 : begin
			                    for (int r_0_0 = 0; r_0_0 < K_HEIGHT-1; r_0_0++) begin
												  	for (int c_0_0 = 0; c_0_0 < K_WIDTH-1; c_0_0++) begin
												  		data_mat[4 - 3*r_0_0 - c_0_0] <= buffer[2 + r_0_0][c_0_0];
												  	end
												  end
												  for (int cpr_0_0 = 0; cpr_0_0 < K_WIDTH-1; cpr_0_0++) begin
												  	data_mat[7 - cpr_0_0] <= data_mat[7 - K_WIDTH - cpr_0_0];
												  end
												  for (int cpc_0_0 = 0; cpc_0_0 < K_HEIGHT; cpc_0_0++) begin
												  	data_mat[8 - 3*cpc_0_0] <= data_mat[8 - 1 - 3*cpc_0_0];
												  end
                        end
      10'b00000_11110 : begin                                                                           //same_0
													for (int r_0_e = 0; r_0_e < K_HEIGHT-1; r_0_e++) begin
												  	for (int c_0_e = -1; c_0_e < K_WIDTH-1; c_0_e++) begin
												  		data_mat[4 - 3*r_0_e - c_0_e] <= buffer[1 + r_0_e][mat_col + c_0_e];
												  	end
												  end
												  for (int cpr_0_e = -1; cpr_0_e < K_WIDTH-1; cpr_0_e++) begin
												  	data_mat[7 - cpr_0_e] <= data_mat[7 - K_WIDTH - cpr_0_e];
												  end
      	                end
      10'b00000_11111 : begin
													for (int r_0_l = 0; r_0_l < K_HEIGHT-1; r_0_l++) begin
												  	for (int c_0_l = -1; c_0_l < K_WIDTH-2; c_0_l++) begin
												  		data_mat[4 - 3*r_0_l - c_0_l] <= buffer[1 + r_0_l][mat_col + c_0_l];
												  	end
												  end
												  for (int cpr_0_l = -1; cpr_0_l < K_WIDTH-2; cpr_0_l++) begin
												  	data_mat[7 - cpr_0_l] <= buffer[1][mat_col + cpr_0_l];
												  end
												  for (int cpc_0_l = 0; cpc_0_l < K_HEIGHT; cpc_0_l++) begin
												  	data_mat[6 - 3*cpc_0_l] <= data_mat[8 - 1 - 3*cpc_0_l];
												  end
      	                end
      10'b00000_????? : begin                                                                           //same_0
      	                  for (int r_0_uk = 0; r_0_uk < K_HEIGHT-1; r_0_uk++) begin
												  	for (int c_0_uk = -1; c_0_uk < K_WIDTH-1; c_0_uk++) begin
												  		data_mat[4 - 3*r_0_uk - c_0_uk] <= buffer[2 + r_0_uk][mat_col + c_0_uk];
												  	end
												  end
												  for (int cpr_0_uk = -1; cpr_0_uk < K_WIDTH-1; cpr_0_uk++) begin
												  	data_mat[7 - cpr_0_uk] <= buffer[2][mat_col + cpr_0_uk];;
												  end
      	                end
     	10'b11111_00000 : begin
			                    for (int r_1_0 = -1; r_1_0 < K_HEIGHT-2; r_1_0++) begin
												  	for (int c_1_0 = 0; c_1_0 < K_WIDTH-1; c_1_0++) begin
												  		data_mat[4 - 3*r_1_0 - c_1_0] <= buffer[2 + r_1_0][c_1_0];
												  	end
												  end
												  for (int cpr_1_0 = -1; cpr_1_0 < K_WIDTH-1; cpr_1_0++) begin
												  	data_mat[1 - cpr_1_0] <= data_mat[7 - K_WIDTH - cpr_1_0];
												  end
												  for (int cpc_1_0 = 0; cpc_1_0 < K_HEIGHT; cpc_1_0++) begin
												  	data_mat[8 - 3*cpc_1_0] <= data_mat[8 - 1 - 3*cpc_1_0];
												  end
                        end
      10'b11111_11110 : begin                                                                           //same_1
													for (int r_l_e = -1; r_l_e < K_HEIGHT-2; r_l_e++) begin
												  	for (int c_l_e = -1; c_l_e < K_WIDTH-1; c_l_e++) begin
												  		data_mat[4 - 3*r_l_e - c_l_e] <= buffer[1 + r_l_e][mat_col + c_l_e];
												  	end
												  end
												  for (int cpr_l_e = -1; cpr_l_e < K_WIDTH-1; cpr_l_e++) begin
												  	data_mat[1 - cpr_l_e] <= data_mat[7 - K_WIDTH - cpr_l_e];
												  end
      	                end
     	10'b11111_11111 : begin
			                    for (int r_1_l = -1; r_1_l < K_HEIGHT-2; r_1_l++) begin
												  	for (int c_1_l = -1; c_1_l < K_WIDTH-2; c_1_l++) begin
												  		data_mat[4 - 3*r_1_l - c_1_l] <= buffer[2 + r_1_l][c_1_l];
												  	end
												  end
												  for (int cpr_1_l = -1; cpr_1_l < K_WIDTH-2; cpr_1_l++) begin
												  	data_mat[1 - cpr_1_l] <= data_mat[7 - K_WIDTH - cpr_1_l];
												  end
												  for (int cpc_1_l = -1; cpc_1_l < K_HEIGHT-1; cpc_1_l++) begin
												  	data_mat[3 - 3*cpc_1_l] <= data_mat[4 - 3*cpc_1_l];
												  end
                        end
      10'b11111_????? : begin                                                                           //same_1
													for (int r_l_uk = -1; r_l_uk < K_HEIGHT-2; r_l_uk++) begin
												  	for (int c_l_uk = -1; c_l_uk < K_WIDTH-1; c_l_uk++) begin
												  		data_mat[4 - 3*r_l_uk - c_l_uk] <= buffer[2 + r_l_uk][mat_col + c_l_uk];
												  	end
												  end
												  for (int cpr_l_uk = -1; cpr_l_uk < K_WIDTH-1; cpr_l_uk++) begin
												  	data_mat[1 - cpr_l_uk] <= buffer[2][mat_col + c_l_uk];
												  end
      	                end
      10'b?????_00000 : begin                                                                           
													for (int r_uk_0 = -1; r_uk_0 < K_HEIGHT-1; r_uk_0++) begin
												  	for (int c_uk_0 = 0; c_uk_0 < K_WIDTH-1; c_uk_0++) begin
												  		data_mat[4 - 3*r_uk_0 - c_uk_0] <= buffer[2 + r_uk_0][mat_col + c_uk_0];
												  	end
												  end
												  for (int cpc_uk_0 = -1; cpc_uk_0 < K_WIDTH-1; cpc_uk_0++) begin
												  	data_mat[5 - 3*cpc_uk_0] <= data_mat[7 - K_WIDTH - 3*cpc_uk_0];
												  end
      	                end
      10'b?????_11110 : for (int r_0_e = -1; r_0_e < K_HEIGHT-1; r_0_e++) begin
											  	for (int c_0_e = -1; c_0_e < K_WIDTH-1; c_0_e++) begin
											  		data_mat[4 - 3*r_0_e - c_0_e] <= buffer[1 + r_0_e][mat_col + c_0_e];
											  	end
											  end
      10'b?????_11111 : begin                                                                           
													for (int r_uk_0 = -1; r_uk_0 < K_HEIGHT-1; r_uk_0++) begin
												  	for (int c_uk_0 = -1; c_uk_0 < K_WIDTH-2; c_uk_0++) begin
												  		data_mat[4 - 3*r_uk_0 - c_uk_0] <= buffer[1 + r_uk_0][mat_col + c_uk_0];
												  	end
												  end
												  for (int cpc_uk_0 = -1; cpc_uk_0 < K_WIDTH-1; cpc_uk_0++) begin
												  	data_mat[3 - 3*cpc_uk_0] <= data_mat[7 - K_WIDTH - 3*cpc_uk_0];
												  end
      	                end    
			default         : for (int r_0_e = -1; r_0_e < K_HEIGHT-1; r_0_e++) begin
											  	for (int c_0_e = -1; c_0_e < K_WIDTH-1; c_0_e++) begin
											  		data_mat[4 - 3*r_0_e - c_0_e] <= buffer[2 + r_0_e][mat_col + c_0_e];
											  	end
											  end
		endcase */
	  casez ({mat_row,mat_col})
	  	{f_row, f_col}  : {data_mat[8], data_mat[7], data_mat[6], data_mat[5], data_mat[4],
	  	                   data_mat[3], data_mat[2], data_mat[1], data_mat[0]} <=  
	  	                              {buffer[2][mat_col  ], buffer[2][mat_col], buffer[2][mat_col+1] ,
	  																 buffer[2][mat_col  ], buffer[2][mat_col], buffer[2][mat_col+1] ,
	  																 buffer[3][mat_col  ], buffer[3][mat_col], buffer[3][mat_col+1]};
  
	    {f_row, e_col}  : {data_mat[8], data_mat[7], data_mat[6], data_mat[5], data_mat[4],
	                       data_mat[3], data_mat[2], data_mat[1], data_mat[0]} <=  
	                                  {buffer[1][mat_col-1], buffer[1][mat_col], buffer[1][mat_col+1] ,
	  																 buffer[1][mat_col-1], buffer[1][mat_col], buffer[1][mat_col+1] ,
	  																 buffer[2][mat_col-1], buffer[2][mat_col], buffer[2][mat_col+1]};
  
	  	{f_row, l_col}  : {data_mat[8], data_mat[7], data_mat[6], data_mat[5], data_mat[4],
	  	                   data_mat[3], data_mat[2], data_mat[1], data_mat[0]} <=  
	  	                              {buffer[1][mat_col-1], buffer[1][mat_col], buffer[1][mat_col  ] ,
	  																 buffer[1][mat_col-1], buffer[1][mat_col], buffer[1][mat_col  ] ,
	  																 buffer[2][mat_col-1], buffer[2][mat_col], buffer[2][mat_col  ]};
  
	  	{f_row, uk_col} : {data_mat[8], data_mat[7], data_mat[6], data_mat[5], data_mat[4],
	  	                   data_mat[3], data_mat[2], data_mat[1], data_mat[0]} <=  
	  	                              {buffer[2][mat_col-1], buffer[2][mat_col], buffer[2][mat_col+1] ,
	  																 buffer[2][mat_col-1], buffer[2][mat_col], buffer[2][mat_col+1] ,
	  																 buffer[3][mat_col-1], buffer[3][mat_col], buffer[3][mat_col+1]};
  
	  	{l_row, f_col}  : {data_mat[8], data_mat[7], data_mat[6], data_mat[5], data_mat[4],
	  	                   data_mat[3], data_mat[2], data_mat[1], data_mat[0]} <=  
	  	                              {buffer[1][mat_col  ], buffer[1][mat_col], buffer[1][mat_col+1] ,
	  																 buffer[2][mat_col  ], buffer[2][mat_col], buffer[2][mat_col+1] ,
	  																 buffer[2][mat_col  ], buffer[2][mat_col], buffer[2][mat_col+1]};
  
      {l_row, e_col}  : {data_mat[8], data_mat[7], data_mat[6], data_mat[5], data_mat[4],
                         data_mat[3], data_mat[2], data_mat[1], data_mat[0]} <=  
                                    {buffer[0][mat_col-1], buffer[0][mat_col], buffer[0][mat_col+1] ,
	  																 buffer[1][mat_col-1], buffer[1][mat_col], buffer[1][mat_col+1] ,
	  																 buffer[1][mat_col-1], buffer[1][mat_col], buffer[1][mat_col+1]};
  
	  	{l_row, l_col}  : {data_mat[8], data_mat[7], data_mat[6], data_mat[5], data_mat[4],
	  	                   data_mat[3], data_mat[2], data_mat[1], data_mat[0]} <=  
	  	                              {buffer[0][mat_col-1], buffer[0][mat_col], buffer[0][mat_col  ] ,
	  																 buffer[1][mat_col-1], buffer[1][mat_col], buffer[1][mat_col  ] ,
	  																 buffer[1][mat_col-1], buffer[1][mat_col], buffer[1][mat_col  ]};
      
      {l_row, uk_col} : {data_mat[8], data_mat[7], data_mat[6], data_mat[5], data_mat[4],
                         data_mat[3], data_mat[2], data_mat[1], data_mat[0]} <=  
                                    {buffer[1][mat_col-1], buffer[1][mat_col], buffer[1][mat_col+1] ,
	  																 buffer[2][mat_col-1], buffer[2][mat_col], buffer[2][mat_col+1] ,
	  																 buffer[2][mat_col-1], buffer[2][mat_col], buffer[2][mat_col+1]};
  
      {uk_row, f_col} : {data_mat[8], data_mat[7], data_mat[6], data_mat[5], data_mat[4],
                         data_mat[3], data_mat[2], data_mat[1], data_mat[0]} <=  
                                    {buffer[1][mat_col  ], buffer[1][mat_col], buffer[1][mat_col+1] ,
	  																 buffer[2][mat_col  ], buffer[2][mat_col], buffer[2][mat_col+1] ,
	  																 buffer[3][mat_col  ], buffer[3][mat_col], buffer[3][mat_col+1]};
  
      {uk_row, e_col} : {data_mat[8], data_mat[7], data_mat[6], data_mat[5], data_mat[4],
                         data_mat[3], data_mat[2], data_mat[1], data_mat[0]} <=  
                                    {buffer[0][mat_col-1], buffer[0][mat_col], buffer[0][mat_col+1] ,
	  																 buffer[1][mat_col-1], buffer[1][mat_col], buffer[1][mat_col+1] ,
	  																 buffer[2][mat_col-1], buffer[2][mat_col], buffer[2][mat_col+1]};
  
	  	{uk_row, l_col} : {data_mat[8], data_mat[7], data_mat[6], data_mat[5], data_mat[4],
	  	                   data_mat[3], data_mat[2], data_mat[1], data_mat[0]} <=  
	  	                              {buffer[0][mat_col-1], buffer[0][mat_col], buffer[0][mat_col  ] ,
	  																 buffer[1][mat_col-1], buffer[1][mat_col], buffer[1][mat_col  ] ,
	  																 buffer[2][mat_col-1], buffer[2][mat_col], buffer[2][mat_col  ]};
  
	  	default         : {data_mat[8], data_mat[7], data_mat[6], data_mat[5], data_mat[4],
	  	                   data_mat[3], data_mat[2], data_mat[1], data_mat[0]} <=  
	  	                              {buffer[1][mat_col-1], buffer[1][mat_col], buffer[1][mat_col+1] ,
	  																 buffer[2][mat_col-1], buffer[2][mat_col], buffer[2][mat_col+1] ,
	  																 buffer[3][mat_col-1], buffer[3][mat_col], buffer[3][mat_col+1]};
	  endcase
	end
end

//******************************************************************** 
//************** INSTANSIATION OF RAM IP *****************************
//********************************************************************

ram	ram_inst (            
		.address_a ( address_port_a ),
		.address_b ( address_port_b ),
		.clock ( clk ),
		.data_a ( 8'd0 ),
		.data_b ( w_data ),
		.wren_a ( 1'b0 ),
		.wren_b ( wren_b ),
		.q_a ( data_port_a ),
		.q_b ( data_port_b )
);

endmodule 