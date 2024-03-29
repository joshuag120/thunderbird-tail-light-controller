module wrapper(clk, dimclk, rst, left, right, brake, hazard, run, out);
  input clk, dimclk, rst, left, right, brake, hazard, run;
  output reg [5:0] out;
  wire [5:0] pattern;
  
  stang_state_controller sc(.clk(clk), .rst(rst), .left(left), .right(right), .brake(brake), .hazard(hazard), .run(run), .current_state(pattern));
  
  always @( * ) begin
    if (dimclk && run) begin
      out = 6'b111111;
    end else begin
      {out} = pattern;
    end
  end  
endmodule

module stang_state_controller(input clk, input rst, input left, input right, input brake, input hazard, input run, output reg [5:0] current_state);
  parameter state_off = 6'b000000;
  parameter state_brake = 6'b111111;
  parameter state_l1 = 6'b001000;
  parameter state_l2 = 6'b011000;
  parameter state_l3 = 6'b111000;
  parameter state_r1 = 6'b000100;
  parameter state_r2 = 6'b000110;
  parameter state_r3 = 6'b000111;
  parameter state_bl1 = 6'b001111;
  parameter state_bl2 = 6'b011111;
  parameter state_br1 = 6'b111100;
  parameter state_br2 = 6'b111110;
  
  reg [5:0] next_state;
  
  always @(posedge clk) begin
    if (rst) current_state <= state_off;
    else current_state <= next_state;
  end
  initial begin
    current_state = state_off;
    next_state = state_off;
  end
    
  always @( * ) begin
    next_state = current_state;
    case (current_state)
      state_off: begin
        if (brake && left && right) next_state = state_brake;
        else if (brake && left) next_state = state_r3;
        else if (brake && right) next_state = state_l3;
        else if (left && right) next_state = state_brake;
        else if (brake) next_state = state_brake;
        else if (hazard) next_state = state_brake;
        else if (left) next_state = state_l1;
        else if (right) next_state = state_r1;
        else begin next_state = state_off;
        end
      end
      state_l1: begin
        if (brake && left && right) next_state = state_brake;
        else if (brake && left) next_state = state_bl1;
        else if (left) next_state = state_l2;
        else if (brake) next_state = state_brake;
        else if (hazard) next_state = brake;
        else next_state = state_off;
        end
      state_l2: begin
        if (brake && left && right) next_state = state_brake;
        else if (brake && left) next_state = state_bl2;
        else if (left) next_state = state_l3;
        else if (brake) next_state = state_brake;
        else if (hazard) next_state = state_brake;
        else next_state = state_off;
        end
      state_l3: begin
        if (brake && left && right) next_state = state_brake;
        else if (brake && left) next_state = state_bl1;
        else if (brake && right) next_state = state_br1;
        else if (left) next_state = state_off;
        else if (brake) next_state = state_brake;
        else if (hazard) next_state = state_brake;
        else next_state = state_off;
        end
      state_r1: begin
        if (brake && left && right) next_state = state_brake;
        else if (brake && right) next_state = state_br1;
        else if (right) next_state = state_r2;
        else if (brake) next_state = state_brake;
        else if (hazard) next_state = state_brake;
        else next_state = state_off;
        end
      state_r2: begin
        if (brake && left && right) next_state = state_brake;
        else if (brake && right) next_state = state_br2;
        else if (right) next_state = state_r3;
        else if (brake) next_state = state_brake;
        else if (hazard) next_state = state_brake;
        else next_state = state_off;
        end
      state_r3: begin
        if (brake && left && right) next_state = state_brake;
        else if (brake && right && !left) next_state = state_br1;
        else if (brake && left && !right) next_state = state_bl1;
        else if (right && !brake && !left) next_state = state_off;
        else if (brake && !left && !right) next_state = state_brake;
        else if (hazard && !brake && !left && !right) next_state = state_brake;
        else next_state = state_off;
        end
      state_bl1: begin
        if (brake && left && right) next_state = state_brake;
        else if (brake && left) next_state = state_bl2;
        else if (left) next_state = state_l2;
        else if (brake) next_state = state_brake;
        else next_state = state_off;
        end
      state_bl2: begin
        if (brake && left && right) next_state = state_brake;
        else if (brake && left) next_state = state_brake;
        else if (left) next_state = state_l3;
        else if (brake) next_state = state_brake;
        else next_state = state_off;
        end
      state_br1: begin
        if (brake && left && right) next_state = state_brake;
        else if (brake && right) next_state = state_br2;
        else if (right) next_state = state_r1;
        else if (brake) next_state = state_brake;
        else next_state = state_off;
        end
      state_br2: begin
        if (brake && left && right) next_state = state_brake;
        else if (brake && right) next_state = state_brake;
        else if (right) next_state = state_r1;
        else if (brake) next_state = state_brake;
        else next_state = state_off;
        end
      state_brake: begin
        if (brake && left && right) next_state = state_brake;
        else if (left && right) next_state = state_off;
        else if (brake && left && !right) next_state = state_r3;
        else if (brake && right && !left) next_state = state_l3;
        else if (brake && !right && !left) next_state = state_brake;
        else if (hazard) next_state = state_off;
        else if (left && !brake) next_state = state_l1;
        else if (right && !brake) next_state = state_r1;
        else next_state = state_off;
        end
      endcase    
      end
endmodule