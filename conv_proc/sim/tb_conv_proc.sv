module tb_conv_proc ;

// Testbench signals
logic       clk               = 0;
logic       reset             = 1;
logic [7:0] data_mat[3*3-1:0]    ;
logic [7:0] kernal  [3*3-1:0]    ;
logic [7:0] w_data               ;

// Expected output
logic [7:0] expected;

integer matched = 0;
integer mismatched = 0;
logic [15:0] wiring;

conv_proc #(
	.KERNAL_WIDTH (3),
	.KERNAL_HEIGHT(3),
	.COLOUR_DEPTH (8)
) process_1 (
	.clk     (clk     ),
	.reset   (reset   ),
	.data_mat(data_mat),
	.kernal  (kernal  ),
	.w_data  (w_data  )
);

always #5 clk <= ~clk;

always_ff @(posedge clk) begin 
	for (int i = 0; i < 9; i++) begin
		data_mat[i] <= $urandom_range(0,127);
		kernal  [i] <= $urandom_range(0,10 );
	end
end

always_comb begin : proc_
  wiring = 0;
	for (int k = 0; k < 9; k++) begin
	  wiring = wiring + data_mat[k]*kernal[k];
	end
  expected = {data_mat[4][7:6], wiring[5:0]};	
end

initial begin 
	#5 reset = 0;
  #1000;
  $display("mismatched = %d",mismatched);
  $display("matched = %d",matched);
  $stop;
end

always_ff @(negedge clk) begin 
	if(w_data == expected)
		matched <= matched + 1;
	else
		mismatched <= mismatched + 1;
end

endmodule