module VGA_TEST(
	input clk,
	output reg king,
	/////////VGA/////////
	output[7:0] VGA_B,
	output VGA_BLANK_N,
	output VGA_CLK,
	output[7:0] VGA_G,
	output VGA_HS,
	output[7:0] VGA_R,
	output VGA_SYNC_N,
	output VGA_VS
);


//	For VGA Controller
wire	[9:0]	mRed;
wire	[9:0]	mGreen;
wire	[9:0]	mBlue;
reg	[10:0]	VGA_X;
reg	[10:0]	VGA_Y;
wire			VGA_Read;	//	VGA data request
wire			m1VGA_Read;	//	Read odd field
wire			m2VGA_Read;	//	Read even field

//	VGA Controller
reg [9:0] vga_r10;
reg [9:0] vga_g10;
reg [9:0] vga_b10;
//assign VGA_R = vga_r10[9:2];
//assign VGA_G = vga_g10[9:2];
//assign VGA_B = vga_b10[9:2];

reg clk_vga;
always@(posedge clk)
begin
	clk_vga<=~clk_vga;
end


//reg king;
wire q_sig;
reg [15:0]address_cur;
wire[15:0]address_sig;


always@(posedge clk)
begin
	if((VGA_X<225)&(VGA_Y<225))
	begin
		address_cur<=VGA_Y*225+VGA_X;
		vga_b10[7]<=q_sig;
		vga_g10[7]<=q_sig;
		vga_r10[7]<=q_sig;
		
	end
	else
	begin
		vga_b10<=0;
		vga_g10<=0;
		vga_r10<=0;
		
	end
end


VGA_Ctrl			u9	(	//	Host Side
							.iRed(vga_r10),
							.iGreen(vga_g10),
							.iBlue(vga_b10),
							.oCurrent_X(VGA_X),
							.oCurrent_Y(VGA_Y),
							.oRequest(VGA_Read),
							//.oAddress(address_sig),
							//	VGA Side
							.oVGA_R(VGA_R ),
							.oVGA_G(VGA_G ),
							.oVGA_B(VGA_B ),
							.oVGA_HS(VGA_HS),
							.oVGA_VS(VGA_VS),
							.oVGA_SYNC(VGA_SYNC_N),
							.oVGA_BLANK(VGA_BLANK_N),
							.oVGA_CLOCK(VGA_CLK),
							//	Control Signal
							.iCLK(clk_vga),
							.iRST_N(1'b1)	
							);

//assign address_sig=address_cur;
CRAZYBIRD	CRAZYBIRD_inst (
	.address ( address_cur ),
	.clock ( clk ),
	.q ( q_sig )
	);
							
							

endmodule