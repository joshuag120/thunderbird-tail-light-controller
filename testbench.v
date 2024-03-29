module testbench;
  reg clk;
  reg dimclk;
  parameter CLK = 10;
  parameter DIMCLK = 2;
  always begin
    #(CLK) clk = ~clk;
  end
  always begin
    #(DIMCLK) dimclk = ~dimclk;
  end
  reg rst;
  reg left;
  reg right;
  reg brake;
  reg hazard;
  reg run;
  wire [5:0] display;
  
  wrapper dut(.clk(clk), .dimclk(dimclk), .rst(rst), .left(left), .right(right), .brake(brake), .hazard(hazard), .run(run), .out(display));

  
  initial begin
    clk = 0; //Initialize clk and rst
    dimclk = 0;
    rst = 0;
    right = 1; //initialze with right
    left = 0;
    run = 0;
    brake = 0;
    hazard = 0;
    #(15*CLK + 3); 
    right = 0;
    left = 1; //test left = 1

    #(15*CLK + 3);
    right = 1; //test right + left

    #(8*CLK+12);
    left = 0;
    right = 0;
    brake = 1;//test brake
    #(3*CLK + 3);
    left = 1; //test BL1
    #(16*CLK + 3);
    rst = 1;
    #(5*CLK);
    rst = 0;
    left = 0;
    right = 1; // test BR
    #(16*CLK);
    right = 0;
    brake = 0;
    hazard = 1; //test hazard
    run = 1; //random start test runlight
    #(7*CLK + 3);
    right = 1; //test h + right
    #(3*CLK + 3);
    right = 0;
    left = 1; // test h + left
    #(7*CLK + 3);
    left = 0;
    brake = 1; // test brake + hazard
    #(7*CLK + 3);
    hazard = 0; // test brake + left right
    right = 1;
    left = 1;
    #(5*CLK + 3);
    rst = 1;
    #(5*CLK + 3);

    @(posedge clk);
    #(2*CLK*4);
    $stop; 
  end    
endmodule