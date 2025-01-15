module topmodule #(
	parameter IMAGE_WIDTH   = 128,
	parameter IMAGE_HEIGHT  = 128,
	parameter KERNAL_WIDTH  = 3  ,
	parameter KERNAL_HEIGHT = 3  ,
	parameter COLOUR_DEPTH  = 8
) (
	input  logic        clk        ,
	input  logic        reset      ,
	input  logic        start      ,
	input  logic [14:0] addr_image ,
	input  logic [14:0] addr_kernal,
	input  logic [14:0] addr_conv  ,
	output logic [15:0] offset     ,
	output logic        busy       ,
	output logic        done       
);


localparam ADDR_W = $clog2(IMAGE_HEIGHT),
           ADDR_H = $clog2(IMAGE_WIDTH );

localparam Idle     = 3'd0,
	         BuffRead = 3'd1,
	         Hold     = 4'd2,
	         Process  = 3'd3,
	         End      = 3'd4;

logic [             2:0] D                                         ;
logic [             2:0] Q                                         ;
logic [            10:0] counter                                   ;
logic                    buffermode                                ;
logic                    hold_mode                                 ;
logic                    wren_b                                    ;
logic [COLOUR_DEPTH-1:0] w_data                                    ;
logic [      ADDR_H-1:0] mat_row                                   ;
logic [      ADDR_W-1:0] mat_col                                   ;
logic [COLOUR_DEPTH-1:0] data_mat  [KERNAL_WIDTH*KERNAL_HEIGHT-1:0];
logic [COLOUR_DEPTH-1:0] kernal    [KERNAL_WIDTH*KERNAL_HEIGHT-1:0];

//****************************************************************************
//*********** COUNTER FOR THE CLOCK COUNT FOR FSM ****************************
//****************************************************************************

always_ff @(posedge clk or posedge reset) begin 
  if(reset)      counter <= 0          ;
  else if (busy) counter <= counter + 1;
end

always_ff @(posedge clk) begin
	if(wren_b) begin
		offset <= offset + 1;
		if (mat_col == ((1 << ADDR_W)-1)) begin
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
		offset  <= 0;
	end
end

//****************************************************************************
//************FSM to control the whole Process********************************
//****************************************************************************

//***********Combinational logic for next states******************************
//****************************************************************************

always_comb begin 
	case(Q)
		Idle     : if(start)                                      D = BuffRead;
		           else                                           D = Idle    ;
		BuffRead : if(counter == (KERNAL_WIDTH*KERNAL_HEIGHT-1))  D = Hold    ; 
		           else                                           D = BuffRead;
		Hold     : if(counter == IMAGE_WIDTH + 4)                 D = Process ;
		           else                                           D = Hold    ;
		Process  : if(offset == (1 << (ADDR_W+ADDR_H)) + 1)       D = End     ; 
		           else                                           D = Process ;
		End      :                                                D = Idle    ;
	endcase
end

//*********************FF of State Diagram************************************
//****************************************************************************

always@(posedge clk or posedge reset) begin 
	if(reset) Q <= 3'd0;
	else      Q <= D   ;
end

//**************ombinational logic for output*********************************
//****************************************************************************

always_comb begin
	case(Q)
		Idle     : {done,wren_b,hold_mode,buffermode,busy} <= 6'b00000;
		BuffRead : {done,wren_b,hold_mode,buffermode,busy} <= 6'b00011;
		Hold     : {done,wren_b,hold_mode,buffermode,busy} <= 6'b00101;
		Process  : {done,wren_b,hold_mode,buffermode,busy} <= 6'b01001;
		End      : {done,wren_b,hold_mode,buffermode,busy} <= 6'b10001;
	endcase
end

//****************************************************************************
//********************** INSTANTIATION OF BUFFER *****************************
//****************************************************************************

buffer #(
	.WIDTH       (IMAGE_WIDTH  ),
	.HEIGHT      (IMAGE_HEIGHT ),
	.K_WIDTH     (KERNAL_WIDTH ),
	.K_HEIGHT    (KERNAL_HEIGHT),
	.ADDR_W      (ADDR_W       ),
	.ADDR_H      (ADDR_H       ),
	.COLOUR_DEPTH(COLOUR_DEPTH ),
	.MEMORY_ADDR (15           )
) buffer (
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

//****************************************************************************
//********************** INSTANTIATION OF PROCESS ****************************
//****************************************************************************

conv_proc #(
	.KERNAL_WIDTH (KERNAL_WIDTH ),
	.KERNAL_HEIGHT(KERNAL_HEIGHT),
	.COLOUR_DEPTH (COLOUR_DEPTH )
) conv_proc (
	.clk     (clk     ),
	.reset   (reset   ),
	.data_mat(data_mat),
	.kernal  (kernal  ), 
	.w_data  (w_data  )
);

endmodule