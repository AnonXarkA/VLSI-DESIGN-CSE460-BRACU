module lab( A,B,opCode,clk,C,Carry,Sign,Zero);
    input clk;
    input [3:0] A,B;
   input [2:0] opCode;
   reg [1:0] tmp,tmp2,tmp3,tmp4;
    reg [1:0] temp,temp2,temp3,temp4;
   output reg [3:0] C;
   output reg Carry,Sign,Zero;

    parameter do_reset = 3'b000, do_x_or = 3'b001, do_sub=3'b100, do_and=3'b011, do_add=3'b010;

    reg[2:0] current_state,sub_state,sub_next_state,sub_current_state;

    parameter sub2_S0 = 3'b000, sub2_S1 = 3'b001, sub2_S2=3'b010, sub2_S3=3'b011, sub2_S4=3'b100;

    reg[2:0] and_next_state,and_current_state;
	parameter and2__S0 = 3'b000, and2__S1 = 3'b001, and2__S2=3'b010, and2__S3=3'b011, and2__S4=3'b100;

	reg[2:0] add_next_state,add_current_state;
	parameter add2_S0 = 3'b000, add2_S1 = 3'b001, add2_S2=3'b010, add2_S3=3'b011, add2_S4=3'b100;

	reg[2:0] x_or_next_state,x_or_current_state;
	parameter x_or2_S0 = 3'b000, x_or2_S1 = 3'b001, x_or2_S2=3'b010, x_or2_S3=3'b011, x_or2_S4=3'b100;

always @(posedge clk)
	begin
	//Sub_Start
		if (opCode == do_sub)
		begin
			current_state = do_sub;
			sub_current_state = sub_next_state;
			case(sub_current_state)
				sub2_S0: sub_next_state = sub2_S1;
				sub2_S1: sub_next_state = sub2_S2;
				sub2_S2: sub_next_state = sub2_S3;
				sub2_S3: sub_next_state = sub2_S4;
				sub2_S4: sub_next_state = sub2_S0;
			endcase
		end

		if (opCode == do_and)
				begin
					current_state = do_and;
					and_current_state = and_next_state;
					case(and_current_state)
						and2__S0: and_next_state = and2__S1;
						and2__S1: and_next_state = and2__S2;
						and2__S2: and_next_state = and2__S3;
						and2__S3: and_next_state = and2__S4;
						and2__S4: and_next_state = and2__S0;
					endcase
				end
			if (opCode == do_add)
				begin
					current_state = do_add;
					add_current_state = add_next_state;
					case(add_current_state)
						add2_S0: add_next_state = add2_S1;
						add2_S1: add_next_state = add2_S2;
						add2_S2: add_next_state = add2_S3;
						add2_S3: add_next_state = add2_S4;
						add2_S4: add_next_state = add2_S0;
					endcase
				end
			if (opCode == do_x_or)
				begin
					current_state = do_x_or;
					x_or_current_state = x_or_next_state;
					case(x_or_current_state)
						x_or2_S0: x_or_next_state = x_or2_S1;
						x_or2_S1: x_or_next_state = x_or2_S2;
						x_or2_S2: x_or_next_state = x_or2_S3;
						x_or2_S3: x_or_next_state = x_or2_S4;
						x_or2_S4: x_or_next_state = x_or2_S0;
					endcase
				end



	end


//Output logic based on states (Bitwise AND operartion)
always @(current_state)
    begin
		if(current_state == do_sub)
			case(sub_current_state)
				//and2_S0: C = 0;
				sub2_S1:
				begin
					temp = A[0] - B[0];
					C[0]=temp[0];
					Carry = temp[1];
				end
				sub2_S2:
				begin
					temp2=A[1] - B[1] - temp[1];
					C[1]=temp2[0];
					Carry = temp2[1];
				end
				sub2_S3:
				begin
					temp3=A[2] - B[2] - temp2[1];
					C[2]=temp3[0];
					Carry = temp3[1];
				end
				sub2_S4:
				begin
					temp4=A[3] - B[3] - temp3[1];
					C[3]=temp4[0];
					Carry = temp4[1];
					Zero = C == 0?1:0;
					Sign = C[3] == 0?0:1;
				end
			endcase
		if(current_state == do_and)
			case(and_current_state)
				//and2_S0: C = 0;
				and2__S1:
				begin
					C[0]=(A[0] & B[0]);
					Carry = 0;
				end
                and2__S2:
				begin
					C[1]=(A[1] & B[1]);
					Carry = 0;
				end
                and2__S3:
				begin
					C[2]=(A[2] & B[2]);
					Carry = 0;
				end
                and2__S4:
                begin
					C[3]=(A[3] & B[3]);
					Carry = 0;
					Zero = C == 0?1:0;
					Sign = C[3] == 0?0:1;
				end
			endcase

		if(current_state == do_add)
			case(add_current_state)
				//and2_S0: C = 0;
				add2_S1:
				begin
					tmp = (A[0] + B[0]);
					C[0]=tmp[0];
					Carry = tmp[1];
				end
			    add2_S2:
			    begin
					tmp2 = (A[1] + B[1] + tmp[1]);
					C[1]=tmp2[0];
					Carry = tmp2[1];
				end
			    add2_S3:
			    begin
					tmp3 = (A[2] + B[2] + tmp2[1]);
					C[2]=tmp3[0];
					Carry = tmp3[1];
					end
			    add2_S4:
				begin
					tmp4 = (A[3] + B[3] + tmp3[1]);
					C[3]=tmp4[0];
					Carry = tmp4[1];
					Zero = C == 0?1:0;
					Sign = C[3] == 0?0:1;
				end
			endcase

		if(current_state == do_x_or)
			case(x_or_current_state)
				//and2_S0: C = 0;
				x_or2_S1:
				begin
					C[0]=(A[0] ^ B[0]);
					Carry = 0;
				end
                x_or2_S2:
                begin
					C[1]=(A[1] ^ B[1]);
					Carry = 0;
				end
                x_or2_S3:
                begin
					C[2]=(A[2] ^ B[2]);
					Carry = 0;
				end
                x_or2_S4:
				begin
					C[3]=(A[3] ^ B[3]);
					Carry = 0;
					Zero = C == 0?1:0;
					Sign = C[3] == 0?0:1;
				end
			endcase
	end



endmodule