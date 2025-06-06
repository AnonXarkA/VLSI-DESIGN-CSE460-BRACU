module lab3(z,w,clk,Resetn);
input clk, Resetn, w;
output reg z;
reg [3:1]y, Y;
parameter A=3'b000, B=3'b001, C=3'b010, D=3'b011, E=3'b100;
always @(w,y)
begin
case(y)
A: if (w)
begin
z=0;
Y=B;
end
else
begin
z=0;
Y=A;
end
B: if (w)
begin
z=0;
Y=C;
end
else
begin
z=0;
Y=A;
end
C: if (w)
begin
z=0;
Y=D;
end
else
begin
z=0;
Y=E;
end
D: if (w)
begin
z=1;
Y=D;
end
else
begin
z=0;
Y=E;
end
E: if (w)
begin
z=1;
Y=B;
end
else
begin
z=0;
Y=A;
end
endcase
end
always@(posedge clk, negedge Resetn)
if (Resetn == 0) y<=A;
else
y<=Y;
endmodule