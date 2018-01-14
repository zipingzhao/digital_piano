`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:58:20 06/26/2013 
// Design Name: 
// Module Name:    song 
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
module song(clk_5MHz, key, select, beep);

input clk_5MHz;
input [3:0] key;
input select;				       
output beep;					   //�����


reg  [25:0] cnt1, cnt2, cnt3;
reg  clk_4Hz, clk_3Hz,  clk_5Hz;
reg  [1:0] flag;
wire  beep_r;
wire out1, out2, out3;
wire clk;

assign beep = beep_r;
//��Ŀ1����ֻ�ϻ���
song1 m1(.clk_5MHz(clk_5MHz),.clk_4Hz(clk),.beep(out1));
//��Ŀ2��������衷
song2 m2(.clk_5MHz(clk_5MHz),.clk_4Hz(clk),.beep(out2));
//��Ŀ3�����֮�ǡ�
song3 m3(.clk_5MHz(clk_5MHz),.clk_4Hz(clk),.beep(out3));

assign beep_r = (key == 4'b0001)?out1:
					 (key==4'b0010)?out2:
					 (key==4'b0100)?out3:0;

initial flag = 2'b0; 
always@(negedge select)
begin
	flag <= flag + 2'b1;
end

assign clk = (flag == 2'd0)?clk_4Hz:
				 (flag == 2'd1)?clk_5Hz:
				 (flag == 2'd2)?clk_3Hz:
				 (flag == 2'd3)?0:clk_4Hz;

/**********************************************************************/

always@(posedge clk_5MHz)				//4hz��Ƶ
begin    
	if(cnt1<25'd625000)
		cnt1 <= cnt1+25'b1;
   else
		begin
		cnt1<=25'b0;
		clk_4Hz <= ~clk_4Hz;
		end
end

always@(posedge clk_5MHz)				//5hz��Ƶ
begin    
	if(cnt2<25'd400000)
		cnt2 <= cnt2+25'b1;
   else
		begin
		cnt2<=25'b0;
		clk_5Hz <= ~clk_5Hz;
		end
end

always@(posedge clk_5MHz)				//3hz��Ƶ
begin    
	if(cnt3<325'd800000)
		cnt3 <= cnt3+25'b1;
   else
		begin
		cnt3<=25'b0;
		clk_3Hz <= ~clk_3Hz;
		end
end
/************************************************************************/

endmodule
