module maosma(clk, in, out, confirm);

	input clk, confirm;
	input [1:0] in;
	output [1:0] out;

	reg [1:0] out;
	reg [3:0] state;

	parameter est_0 = 0, est_5 = 1, est_10 = 2, est_15 = 3, est_20 = 4, est_25 = 5, est_30 = 6, est_30plus = 7, est_cancel = 8;

	initial begin
		state = est_0;
	end

	always @(state) 
		begin
			//$display("\nSTATE: %d, current_in: %b, acc = %d", state, in, given,);
			case (state)
				est_0:
					begin
						$display("\nAguardando nova insercao...\n");
						out = 2'b00;
					end
				est_5:
					begin
						out = 2'b00;
					end
				est_10:
					begin
						out = 2'b00;
					end
				est_15:
					begin
						out = 2'b00;
					end
				est_20:
					begin
						out = 2'b00;
					end
				est_25:
					begin
						out = 2'b00;
					end
				est_30:
					begin
						out = 2'b10;
						$display("\n***TOMA BALA***\n");
						
					end
				est_30plus:
					begin
						out = 2'b11;
						$display("\n***TOMA BALA e TROCO***\n");
					end
				est_cancel:
					begin
						out = 2'b01;
						$display("Cancelado.");
					end
				default:
					$display("caso default, algum erro");
			endcase
		end

	always @(posedge clk)
		begin
			if (confirm)
				begin
					case (state)
						est_0:
							begin
								if (in == 2'b00)
									begin
										state = est_cancel;
									end
								else if (in == 2'b01)
									begin
										state = est_5;
									end
								else if (in == 2'b10)
									begin
										state = est_10;
									end
								else if (in == 2'b11)
									begin
										state = est_25;
									end
							end
							
						est_5:
							begin
								if (in == 2'b00)
									begin
										state = est_cancel;
									end
								else if (in == 2'b01)
									begin
										state = est_10;
									end
								else if (in == 2'b10)
									begin
										state = est_15;
									end
								else if (in == 2'b11)
									begin
										state = est_30;
									end
							end
						
						est_10:
							begin
								if (in == 2'b00)
									begin
										state = est_cancel;
									end
								else if (in == 2'b01)
									begin
										state = est_15;
									end
								else if (in == 2'b10)
									begin
										state = est_20;
									end
								else if (in == 2'b11)
									begin
										state = est_30plus;
									end
							end
						
						est_15:
							begin
								if (in == 2'b00)
									begin
										state = est_cancel;
									end
								else if (in == 2'b01)
									begin
										state = est_20;
									end
								else if (in == 2'b10)
									begin
										state = est_25;
									end
								else if (in == 2'b11)
									begin
										state = est_30plus;
									end
							end
						
						est_20:
							begin
								if (in == 2'b00)
									begin
										state = est_cancel;
									end
								else if (in == 2'b01)
									begin
										state = est_25;
									end
								else if (in == 2'b10)
									begin
										state = est_30;
									end
								else if (in == 2'b11)
									begin
										state = est_30plus;
									end
							end
						
						est_25:
							begin
								if (in == 2'b00)
									begin
										state = est_cancel;
									end
								else if (in == 2'b01)
									begin
										state = est_30;
									end
								else if (in == 2'b10)
									begin
										state = est_30plus;
									end
								else if (in == 2'b11)
									begin
										state = est_30plus;
									end
							end
						
						est_30:
							begin
								state = est_0;
							end
						
						est_30plus:
							begin
								state = est_0;
							end
						endcase
				end
		end

endmodule

module testbench();

    reg clk, confirm;
    reg [1:0] in;
	wire [1:0] out;

    maosma display(.in(in), .clk(clk), .out(out), .confirm(confirm));

    initial begin
		confirm = 1'b1;
		//$monitor("in = %b, out = %b", in, out);
		in = 2'b11;
		#2;
		in = 2'b10;
		
		#3;
		$finish;
    
    end
	initial
		clk = 0;
    always #1 clk = ~clk;
	//always #1 confirm = ~confirm;

endmodule
