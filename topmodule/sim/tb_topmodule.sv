`timescale 1ns/1ps
module tb_topmodule ;

	logic        clk             = 0;
	logic        reset           = 1;
	logic        start           = 0;
	logic [14:0] addr_image      = 0;
	logic [14:0] addr_kernal     = 0;
	logic [14:0] addr_conv       = 0;
	logic [15:0] offset             ;
	logic        busy               ;
	logic        done               ;

	topmodule #(
		.IMAGE_WIDTH  (128),
		.IMAGE_HEIGHT (128),
		.KERNAL_WIDTH (3  ),
		.KERNAL_HEIGHT(3  ),
		.COLOUR_DEPTH (8  )
	) i_topmodule (
		.clk            (clk            ),
		.reset          (reset          ),
		.start          (start          ),
		.addr_image     (addr_image     ),
		.addr_kernal    (addr_kernal    ),
		.addr_conv      (addr_conv      ),
		.offset         (offset         ),
		.busy           (busy           ),
		.done           (done           )
	);

always #5 clk <= ~clk;

initial begin
	#10 reset       = 0      ;
	#50 start       = 1      ;
	    addr_image  = 0      ;
	    addr_kernal = 15'h4009;
	    addr_conv   = 15'h4000;
	#20 start       = 0      ;
	#165000;
	$stop;
end

endmodule 