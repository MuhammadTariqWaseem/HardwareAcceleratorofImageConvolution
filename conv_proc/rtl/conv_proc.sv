module conv_proc #(
	parameter KERNAL_WIDTH  = 3,
	parameter KERNAL_HEIGHT = 3,
	parameter COLOUR_DEPTH  = 8
) (
	input                           clk                                      ,
	input                           reset                                    ,
	input  logic [COLOUR_DEPTH-1:0] data_mat [KERNAL_WIDTH*KERNAL_HEIGHT-1:0],
	input  logic [COLOUR_DEPTH-1:0] kernal   [KERNAL_WIDTH*KERNAL_HEIGHT-1:0],
	output logic [COLOUR_DEPTH-1:0] w_data
);

	logic   [2*COLOUR_DEPTH-1:0] partial_product[KERNAL_HEIGHT*KERNAL_WIDTH-1:0];
	logic   [2*COLOUR_DEPTH-1:0] partial_add                                    ;
	integer                      i                                              ;
	integer                      j                                              ;
	logic   [7:0] answer_product;

//------------------------------------------------------------
//------ PRODUCT OF THE DATA MATRIX WITH KERNAL --------------
//------------------------------------------------------------

always_comb begin
	for (i = 0; i < (KERNAL_WIDTH*KERNAL_HEIGHT) ; i++) begin
		partial_product[i] = data_mat[i] * kernal[i];
	end	
end

//------------------------------------------------------------
//---------- ADDING THE PARTIAL PRODUCT ----------------------
//------------------------------------------------------------

always_comb begin 
	partial_add = 0;
	for (j = 0; j < (KERNAL_WIDTH*KERNAL_HEIGHT) ; j++) begin
		partial_add = partial_add + partial_product[j];
	end	
end

//------------------------------------------------------------
//------ TRUNCATING THE 16 BIT OUTPUT TO 8 BIT _--------------
//------------------------------------------------------------

assign answer_product = data_mat[4];
assign w_data = {answer_product[7],partial_add[11:5]};

endmodule