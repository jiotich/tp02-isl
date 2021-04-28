module maosma(clk, in, out);

	integer given;

	input clk;
	input [1:0] in;
	output [1:0] out;

	reg [1:0] out;
	reg [1:0] state;

	parameter zero=0, um=1, dois=2, tres=3;
	/*
	zero = aguardando total ser 30 (ou seja, estado de recepção de valores)
	um = processa o troco (caso seja cancelado sem terminar compra)
	dois = dá o doce quando não é necessário troco
	tres = dá o doce e o troco
	*/

	initial begin
		given = 0;
		state = zero;
	end

	always @(state) 
		 begin
			  case (state)
					zero:
						out = 2'b00;
					um:
						begin
							out = 2'b01;
						end
					dois:
						out = 2'b10;
					tres:
						out = 2'b11;
					default:
						out = 2'b00;
			  endcase
		 end

	always @(posedge clk)
		begin
			if (given >= 30)
				begin
					if (given == 30)
						begin
							state = dois;
							$display("TOMA DOCE");
						end
					else
						$display(">TOMA DOCE e TROCO: %d", given-30);
					given = 0;
				end

			else if (in == 2'b00)
				given = 0;
			else if (in == 2'b01)
				given+=5;
			else if (in == 2'b10)
				given+=10;
			else if (in == 2'b11)
				given+=25;
			$display("\n>Total Dado: ", given);
			case (state)
				zero:
					if (in)
					state = um;
				um:
					if (in)
						 state = zero;
					else
						state = dois;
				dois:
					state = zero;
				tres:
					state = zero;
				endcase
		 end

endmodule

module testbench();

    reg clk;
    reg [1:0] in;
	wire [1:0] out;

    maosma display(.in(in), .clk(clk), .out(out));

    initial begin

        $monitor("IN = %b, clk = %b", in, clk);

        clk = 1'b1;
		in = 2'b10;
		#2;
		in = 2'b10;
		#2;
		in = 2'b11;
		#2;
        $finish;
    
    end

    always #1 clk = ~clk;

endmodule
