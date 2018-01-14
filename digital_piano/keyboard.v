`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:10:04 06/25/2013 
// Design Name: 
// Module Name:    keyboard 
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
module keyboard
	( sys_clk,
	k_data,
	k_clock,
	record,
	replay,
	out
	);
	input sys_clk;                //ϵͳͬ��ʱ��
	input k_data;                 //������������
	input k_clock;                //��������ʱ��
	input record;						//¼�����뿪��
	input replay;						//�طŲ��뿪��
	output [7:0] out;             //����ļ�ֵascii��ֵ 
	
	wire [7:0] out;
	wire [7:0] data_tongma;               //ɨ��������� ͨ��
	wire [7:0] data_duanma;              //����                 
	
	reg [7:0] ps2_asci;
	
	reg  [11:0]  tmp = 11'b000_0000_0000; //������¼һ֡�ź�
	reg  now_kbclk, pre_kbclk;   
	reg  ZHJS;                               //ɨ����ת�������źţ�
	reg  started = 0;
	reg  [3:0] counter =4'd0;               //һ����ʱ��仯�ļ�����
	wire  enable;   

	wire [7:0] record_asci;
	
	assign out = replay ? record_asci : ps2_asci;   //���ݲ��뿪��replay��״̬ѡ�����
	
	recordmode m1(sys_clk, record, replay, ps2_asci, record_asci);   //recordmodeģ��ʵ����
	
	always @(posedge sys_clk)    
		begin                              
	     pre_kbclk <= now_kbclk;         //��Ϊ�������׶���������Ӹ�ʱ���жϾͱȽ��ȶ�
	     now_kbclk <= k_clock;               //�����ط�������
	     if(pre_kbclk > now_kbclk)
			begin                               //�½��ش���			
				tmp[counter] <= k_data;  
//-----------------------------------------------------------------------			
				if(counter == 4'd10) 
					begin
			           ZHJS <= 1'b0;            //finish
					end
				else 
					begin
			           ZHJS <= 1'b1;            //not finish   
					end

				if(counter == 4'd11) 
					begin
						counter<=4'd1;
					end
				else 
					begin
						counter <= counter +4'd1;
					end
			end 
	     if(counter > 4'd1 && counter <4'd10 ) 
	        begin                                      //ת����
				started <= 1'b1;
	        end
	     else 
	        begin
				started <= 1'b0;                          //ת������
	        end
	   end 
	
	assign enable = started;                           //startedת�����
	assign data_tongma = enable ? 8'b0000_0000 : tmp[8:1];   //���enable=0��tmp[8:1]
	                                                         //����data-tongma

/****************************************************
�����ж���û��F0����ĳ���,һ����F0֤������
�ɿ�,������Ч,����keypressed-D=1(������ɿ�)         
ͨ��һ��������DD,����Pressed-Q,���Ͽ�״̬	
******************************************************/		 
reg   keypressed_D  =0;
wire  keypressed_Q;																			
	
always @(data_tongma or keypressed_Q )	//only can use electricity level tri,else ERROR
	begin
		keypressed_D <= (data_tongma == 8'hF0)? 1'b1 : 1'b0;		  
   end
	 
assign   data_duanma=(keypressed_Q==1'b0)? data_tongma :8'h00;

always @ (data_duanma)
	begin
		case (data_duanma)  
			8'h15: ps2_asci <= 8'h51;   //Q
			8'h1d: ps2_asci <= 8'h57;   //W
			8'h24: ps2_asci <= 8'h45;   //E
			8'h2d: ps2_asci <= 8'h52;   //R
			8'h2c: ps2_asci <= 8'h54;   //T
			8'h35: ps2_asci <= 8'h59;   //Y
			8'h3c: ps2_asci <= 8'h55;   //U
			8'h43: ps2_asci <= 8'h49;   //I
			8'h44: ps2_asci <= 8'h4f;   //O
			8'h4d: ps2_asci <= 8'h50;   //P               
			8'h1c: ps2_asci <= 8'h41;   //A
			8'h1b: ps2_asci <= 8'h53;   //S
			8'h23: ps2_asci <= 8'h44;   //D
			8'h2b: ps2_asci <= 8'h46;   //F
			8'h34: ps2_asci <= 8'h47;   //G
			8'h33: ps2_asci <= 8'h48;   //H
			8'h3b: ps2_asci <= 8'h4a;   //J
			8'h42: ps2_asci <= 8'h4b;   //K
			8'h4b: ps2_asci <= 8'h4c;   //L
			8'h1a: ps2_asci <= 8'h5a;   //Z
			8'h22: ps2_asci <= 8'h58;   //X
			8'h21: ps2_asci <= 8'h43;   //C
			8'h2a: ps2_asci <= 8'h56;   //V
			8'h32: ps2_asci <= 8'h42;   //B
			8'h31: ps2_asci <= 8'h4e;   //N
			8'h3a: ps2_asci <= 8'h4d;   //M
			default: ps2_asci<=8'h00;
		endcase
	end

//***����DD������
DD  DD_keypressed(
                  .DCLK(ZHJS),            //ZHJS��ΪD��������ʱ��
			         .D(keypressed_D), 
			         .Q(keypressed_Q)
		        	  );
//********************************************************
	endmodule






/*module keyboard(clk, ps2_clk, ps2_data, out);

input clk, ps2_clk, ps2_data;
output [7:0] out;

reg [7:0] ps2_asci;
reg [10:0] data2;
reg [3:0] i; 
reg [2:0] ps2_clkr;
wire [7:0] out;

always @(posedge clk) 
	ps2_clkr <= {ps2_clkr[1:0], ps2_clk};

wire ps2_clk_risingedge = (ps2_clkr[2:1]==2'b01); 
wire ps2_clk_fallingedge = (ps2_clkr[2:1]==2'b10);

assign out = ps2_asci; 

always @(posedge clk)
		begin
			if(ps2_clk_fallingedge)
			begin
				i <= i+1;
				data2[i] <= ps2_data;
				if(i>=10) 
					i<=0; 
				if(data2[9]==0)
				begin
					if(data2[8:1]==8'h1b|
						data2[8:1]==8'h2b|
						data2[8:1]==8'h33|
						data2[8:1]==8'h1d|
						data2[8:1]==8'h24|
						data2[8:1]==8'h2d|
						data2[8:1]==8'h35|
						data2[8:1]==8'h3c|
						data2[8:1]==8'h22|
						data2[8:1]==8'h21|
						data2[8:1]==8'h3a)
						begin
						 data2[8:1]<=0;
						end
					end
				if(data2[10]==0) 
				begin
					data2[8:1]<=0;
				end			    
				 
				if(data2==11'b11111100000)
				begin
					data2<=11'b0;
				end
			end
		end

always @ (data2)
	begin
		case (data2[8:1])  
			8'h15: ps2_asci <= 8'h51;   //Q
			8'h1d: ps2_asci <= 8'h57;   //W
			8'h24: ps2_asci <= 8'h45;   //E
			8'h2d: ps2_asci <= 8'h52;   //R
			8'h2c: ps2_asci <= 8'h54;   //T
			8'h35: ps2_asci <= 8'h59;   //Y
			8'h3c: ps2_asci <= 8'h55;   //U
			8'h43: ps2_asci <= 8'h49;   //I
			8'h44: ps2_asci <= 8'h4f;   //O
			8'h4d: ps2_asci <= 8'h50;   //P               
			8'h1c: ps2_asci <= 8'h41;   //A
			8'h1b: ps2_asci <= 8'h53;   //S
			8'h23: ps2_asci <= 8'h44;   //D
			8'h2b: ps2_asci <= 8'h46;   //F
			8'h34: ps2_asci <= 8'h47;   //G
			8'h33: ps2_asci <= 8'h48;   //H
			8'h3b: ps2_asci <= 8'h4a;   //J
			8'h42: ps2_asci <= 8'h4b;   //K
			8'h4b: ps2_asci <= 8'h4c;   //L
			8'h1a: ps2_asci <= 8'h5a;   //Z
			8'h22: ps2_asci <= 8'h58;   //X
			8'h21: ps2_asci <= 8'h43;   //C
			8'h2a: ps2_asci <= 8'h56;   //V
			8'h32: ps2_asci <= 8'h42;   //B
			8'h31: ps2_asci <= 8'h4e;   //N
			8'h3a: ps2_asci <= 8'h4d;   //M
			default: ps2_asci<=8'h00;
		endcase
	end

endmodule
*/
