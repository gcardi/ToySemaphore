`timescale 1us/10ns

module Clock( clk );
  output clk;
  reg clk;
  
  always 
    begin 
     #10;    
     clk <= 1'b0;
     #10;
     clk <= 1'b1;
    end
endmodule

module C4017( clk, out, res );
  input clk;
  input res;
  output [9:0] out;
  reg [9:0] out;
  reg [3:0] m;
  
  initial 
    begin
       m = 4'b0000;
       out = 10'b00000001;
    end
    
  always @( posedge clk or posedge res )
    begin
      m <= res ? 0 : ( m + 1 ) % 10;
      out <= 1'b1 << m;
    end
endmodule

module Fls( out );
  output out;
  reg out;
  always 
    begin 
     out <= 1'b0;
     #10;    
     out <= 1'b1;
     #10;
    end
endmodule

module Reset( out );
  output out;
  reg out;
  
  initial
    begin 
     out <= 1'b1;
     #10;    
     out <= 1'b0;
    end
endmodule

module main;
  wire clk;
  wire [9:0] out;
  wire a;
  wire fls;
  wire r;
  wire g;
  wire v;
  wire r1;
  wire g1;  
  wire v1;  
  wire notc;
  wire z;
  reg dis;
  wire res;
  wire xg;
  wire xg1;

  Reset rst( res );
  Clock c( clk );
  C4017 q( clk, out, res | dis );
  Fls f( fls );
  
  initial
    begin
      #0
      dis <= 1'b0;
      #1200;
      dis <= 1'b1;
      #1200;
      $finish;
    end
  
  initial 
    begin
      $dumpfile("my_dumpfile.vcd");
      $dumpvars(0,main);
    end

   // SR latch    
   nor n1( a, b, out[0] );
   nor n2( b, a, out[5] );
   
   //assign z = !( !dis * clk );
   //assign z = !( !dis * 1'b0 );
   nand n7( z, !dis, 1'b0 );
   
   //assign notc = !( dis * fls ); // { 1 NAND }
   nand n10( notc, dis, fls );
   
   //assign r = !( !( !dis & a ) ); //  { 2 NAND};
   nand n3( r, a, !dis );
   assign g = !( notc * !( z * out[9] ) ); //  { 2 NAND };
   //nand n5( g, notc, xg );
   
   //assign v = !( !( !dis * b ) ); // { 2 NAND };
   nand n4( v, b, !dis );
   
   assign r1 = v;
   
   assign g1 = !( notc * !( z * out[4] ) ); //  { 2 NAND };
   //nand n6( g1, notc, xg1 );

   nand n8( xg, z, out[0] );
   nand n9( xg1, z, out[5] );
   
   assign v1 = r;
endmodule

