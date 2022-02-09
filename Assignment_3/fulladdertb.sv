module top();
  logic cin,x,y;
  wire cout, result;
  
  fulladder dut(.cin(cin),.x(x), .y(y), .cout(cout), .result(result));
  
  initial
    begin
      
      #10;
      x= 1'b0;
      y= 1'b0;
      cin= 1'b0;
      #10;
      $display ("x: %0b, y: %b, cin: %0b, result: %0b, cout: %0b",x, y, cin, result, cout);
      
       x= 1'b0;
      y= 1'b0;
      cin= 1'b1;
      #10;
      $display ("x: %0b, y: %b, cin: %0b, result: %0b, cout: %0b",x, y, cin, result, cout);
     
      x= 1'b0;
      y= 1'b1;
      cin= 1'b0;
      #10;
      $display ("x: %0b, y: %b, cin: %0b, result: %0b, cout: %0b",x, y, cin, result, cout);
     
      x= 1'b0;
      y= 1'b1;
      cin= 1'b1;
      #10;
      $display ("x: %0b, y: %b, cin: %0b, result: %0b, cout: %0b",x, y, cin, result, cout);
     
      x= 1'b1;
      y= 1'b0;
      cin= 1'b0;
      #10;
      $display ("x: %0b, y: %b, cin: %0b, result: %0b, cout: %0b",x, y, cin, result, cout);
     
      x= 1'b1;
      y= 1'b0;
      cin= 1'b1;
      #10;
      $display ("x: %0b, y: %b, cin: %0b, result: %0b, cout: %0b",x, y, cin, result, cout);
     
      x= 1'b1;
      y= 1'b1;
      cin= 1'b0;
      #10;
      $display ("x: %0b, y: %b, cin: %0b, result: %0b, cout: %0b",x, y, cin, result, cout);
     
      x= 1'b1;
      y= 1'b1;
      cin= 1'b1;
      #10;
      $display ("x: %0b, y: %b, cin: %0b, result: %0b, cout: %0b",x, y, cin, result, cout);
     
     
     
     
    	
    end
endmodule
      