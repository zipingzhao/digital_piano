`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:20:15 06/25/2013 
// Design Name: 
// Module Name:    digital_piano 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module digital_piano(inclk, ps2_clk, ps2_data, start, reset, out_r, out_l, 
							key, record, replay, select, hsync, vsync, vga_r, vga_g, vga_b, anodes, cathodes);

input  start, reset;		//ϵͳ����
input  inclk; 				//ѡ��50M����
input  ps2_clk, ps2_data;//PS2����
input  [3:0] key;			//����ѡ��
input record;
input replay;
input  select;				//��������ѡ��
output out_r, out_l;		//��������������������Ŀ���ţ���������������
output [3:0] anodes;		//��ʾ����
output [6:0] cathodes;   //��ʾ����
// FPGA��VGA�ӿ��ź�
output hsync;	//��ͬ���ź�
output vsync;	//��ͬ���ź�
output[2:0] vga_r;
output[2:0] vga_g;
output[1:0] vga_b;    

reg  clk_5MHz;				//ʱ��Ƶ��5MHz
reg  [2:0] cnt;  


//�����ӵ���
//�����ٵ���
piano m1(.inclk(inclk), .clk_5MHz(clk_5MHz), .start(start), .reset(reset), .ps2_clk(ps2_clk), .ps2_data(ps2_data), .record(record), .replay(replay), 
			.hsync(hsync), .vsync(vsync), .vga_r(vga_r), .vga_g(vga_g), .vga_b(vga_b),	
			.beep(out_r), .anodes(anodes), .cathodes(cathodes)); 							
//��Ŀ���ţ�����
song m2(.clk_5MHz(clk_5MHz), .key(key), .select(select), .beep(out_l));


always@(posedge inclk)				//10��Ƶ��50MHz��5Mhz��Ƶ
begin    
	if(cnt<3'd5)
    	cnt <= cnt + 3'b1;
    else
		begin
		cnt <= 3'b0;
		clk_5MHz <= ~clk_5MHz;
		end
end

endmodule
