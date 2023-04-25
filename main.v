module D_flip_flop(D, Q, clk, reset); 
    input D, clk, reset ;
    output reg Q; 
    always @(posedge clk) 
        begin
            if (reset) 
                Q <= 0;
            else
                Q <= D; 
        end 
endmodule


module sequence_gen(O,I, clk, reset);
    input I, clk, reset;
    output O;
    wire q2, q1, q0;
    wire d2, d1, d0;
    
    assign d2 = (q1 & q0) | (q2 & ~q0);
    assign d1 = (q1 & ~q0) | (~q2 & ~q1 & q0);
    assign d0 = (~q0 & I) | (q1 & ~q0) | (q2 & ~q0);
    assign O  = q2 | (~q1 & ~q0 & I);
    D_flip_flop dff2(d2, q2, clk, reset);
    D_flip_flop dff1(d1, q1, clk, reset);
    D_flip_flop dff0(d0, q0, clk, reset);
endmodule






module main;
    reg clk, reset, I;
    wire O;
    sequence_gen dut(.O(O), .I(I), .clk(clk), .reset(reset));
  	$dumpfile("fsm.vcd");
 	$dumpvars(0,fsm);
  $monitor("clk = %b I = %b O = %b",clk,I,O);
    

    always #1 clk = ~clk;
    always @(posedge clk)
        $display("Output O: %b", O);

    initial begin
        clk = 0;
        reset = 1;
        I = 0;
        #5  reset = 0;
        #10 I = 1;
        #11 I = 0;
        #20 I = 1;
        #21 I = 0; 
    end
    

    
    initial #100 $finish;
endmodule
