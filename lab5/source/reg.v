module register_file				//32 x WIDTH寄存器堆
#(parameter WIDTH = 32) 	//数据宽度
(
input clk,						//时钟（上升沿有效）
input [4:0] ra0,				//读端口0地址
output [WIDTH-1:0] rd0, 	//读端口0数据
input [4:0] ra1, 				//读端口1地址
output [WIDTH-1:0] rd1, 	//读端口1数据
input [4:0] wa, 				//写端口地址
input we,					//写使能，高电平有效
input [WIDTH-1:0] wd,		//写端口数据
input [4:0] dbgra,
output [WIDTH-1:0] dbgrd
);
reg [WIDTH-1:0] reg_storage [0:31];
reg [WIDTH-1:0] reg_rd0, reg_rd1, reg_dbg;
assign rd0=reg_rd0;
assign rd1=reg_rd1;
assign dbgrd=reg_dbg;

initial begin
$readmemh("register_file.vec", reg_storage);
end
always @(*) begin
    reg_rd0=reg_storage[ra0];
    reg_rd1=reg_storage[ra1];
    reg_dbg=reg_storage[dbgra];
    if(we&&wa!=5'd0) begin
        if(ra0==wa)
            reg_rd0=wd;
        if(ra1==wa)
            reg_rd1=wd;
        if(dbgra==wa)
            reg_dbg=wd;
    end
end
always @(posedge clk ) begin
    if(we) begin
        if(wa!=5'd0)
            reg_storage[wa]<=wd;
    end
end
endmodule
