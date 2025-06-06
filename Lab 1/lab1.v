module lab1(f,a,b);
input a,b;
output f;

nor (c,a,b);
and (d,a,b);
or (f,c,d);

endmodule
