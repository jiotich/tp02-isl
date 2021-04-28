//TODO: adequar o segundo always para que o primeiro faça 

module maosma(clk, in, out);

	integer given;

	input clk;
	input [1:0] in;
	output [1:0] out;

	reg [1:0] out;
	reg [2:0] state;

	parameter zero=0, um=1, dois=2, tres=3, quatro=4;
	/*
	zero = aguardando total ser 30 (ou seja, estado de recepção de valores)
	um = verifica se total >= 30
	dois = dá troco em caso de cancelamento
	tres = dá o doce quando não é necessário troco
	quatro = dá o doce e o troco
	*/

	initial begin
		given = 0;
		state = zero;
	end

	always @(state) 
		 begin
			//$display("\nSTATE: %d, current_in: %b, acc = %d", state, in, given,);
			  case (state)
					zero:
						begin
							//$display("Total: %d",given);
						end
					um:
						begin
							if (in == 2'b01)
								begin
									$display("+5");
									given+=5;
								end
							else if (in == 2'b10)
								begin
									$display("+10");
									given+=10;
								end
							else if (in == 2'b11)
								begin
									$display("+25");
									given+=25;
								end

						end
					dois:
						begin
							$display("***Cancelado***");
							out = 2'b10;
							given = 0;
						end
					tres:
						begin
							$display("***TOMA BALA***");
							out = 2'b11;
							given = 0;
						end
					quatro:
						begin
							$display("***TOMA BALA E TROCO***");
							out = 2'b10;
							given = 0;
						end
					default:
						$display("deu merda.");
			  endcase
		 end

	always @(posedge clk)
		begin
			case (state)
				zero:
					begin
						state = um;
					end
				um:
					begin
						if (in == 2'b00)
							begin
								state = dois;
							end
						else if (given == 30)
							begin
								state = tres;
							end
						else if (given > 30)
							begin
								state = quatro;
							end
						else if (given < 30)
							state = zero;
						
					end

				dois:
					begin
						state = zero;
					end
				tres:
					begin
						state = zero;
					end
				quatro:
					begin
						state = zero;
					end
				endcase
		end

endmodule

module testbench();

    reg clk;
    reg [1:0] in;
	wire [1:0] out;

    maosma display(.in(in), .clk(clk), .out(out));

    initial begin

        

        clk = 1'b1;
		in = 2'b01;
		//$monitor("IN = %b, clk = %b", in, clk);
		
		#4;
		in = 2'b11;
		
		#4;
		in = 2'b11;
		#4;
		in = 2'b11;
		
		#4;
		in = 2'b10;
		
		#4;
		in = 2'b10;
		
		#4;
		in = 2'b10;
		
		#4;
		in = 2'b10;
		
		#4;
		in = 2'b00;
		#16;
		$finish;
    
    end

    always #1 clk = ~clk;

endmodule
