module maosma(clk, in, out);

integer given;

input clk;
input [1:0] in;
output [1:0] out;

reg [1:0] out;
reg [1:0] state;

parameter zero=0, um=1, dois=2, tres=3;
/*
zero = insuficiente
um = processa o troco (caso seja cancelado sem terminar compra)
dois = 
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
                    out = 2'b01;
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
	$display("Dado: ", given);
		if (given >= 30)
			$display("Troco: %b", given-30);
		else if (in == 2'b00)
			given = 0;
		else if (in == 2'b01)
			given+=5;
		else if (in == 2'b10)
			given+=10;
		else if (in == 2'b11)
			given+=25;
	
	    case (state)
            zero:
                state = um;
            um:
				if (in)
                     state = zero;
                else
                    state = dois;
            dois:
                state = tres;
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

        $monitor("IN = %b", out);

        clk = 1'b0;
		in = 2'b00;
		#2;
		in = 2'b10;
		#2;
		in = 2'b11;
		
        $finish;
    
    end

    always #1 clk = ~clk;

endmodule