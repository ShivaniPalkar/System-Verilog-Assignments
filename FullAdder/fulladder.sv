module fulladder(sum, cout, x, y, cin);
  input logic x, y, cin;
  output logic cout, sum;

  wire w0, w1, w2;

  xor
  xor1(w0,x,y),
  xor2(sum,w0,cin);

  and
  and1(w1,w0,cin),
  and2(w2,x,y);

  or
  or1(cout,w1,w2);
  
endmodule: fulladder