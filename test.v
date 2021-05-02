`include "lotsoflog.v"

module testbench();

    reg clk, confirm;
    reg [1:0] in;
	wire [1:0] out;

    maosma display(.in(in), .clk(clk), .out(out), .confirm(confirm));

    initial begin
		/*01 = 5, 10 = 10, 11 = 25*/
		confirm = 1'b1;
		$monitor("in = %b, out = %b, clk=%d", in, out, clk);//DISPLAY DO CLOCK
		
		in = 2'b01;
		#2;
		in = 2'b01;
		#2;
		in = 2'b01;
		#2;
		$finish;
    end
	initial
		clk = 0;
    always #1 clk = ~clk;
	//always #1 confirm = ~confirm;

endmodule

/*
{DEIXA O DISPLAY DE ESTADO LIGADO}
Nas especificações foi exigido que houvesse uma variável de confirmação de entrada da moeda, que aqui é a 'confirm'
Por questões de praticidade, para o vídeo, a gente deixou ela como sendo sempre verdadeira.
*executa o programa*
Aqui vemos a passagem de estados, e o retorno ao estado inicial após atingidos os 30c.
1°-
		in = 2'b01;
		#2;
		in = 2'b01;
		#2;
		in = 2'b10;
		#2;
		in = 2'b10;
		#2;
		in = 2'b00;
		#2;
		$finish;

{DEIXA O DISPLAY DE ESTADO LIGADO}
Esse caso é parecido com o anterior, só que passando pelo estado de doce + troco.
2°-
		in = 2'b10;
		#2;
		in = 2'b11;
		#2;
		in = 2'b00;
		#2;
		$finish;

{MANTÉM  O DISPLAY DE ESTADO, LIGA O DISPLAY DO CLOCK}
Nesse caso é necessário que vejamos o valor de saída. Para isso, liga-se o display associado a in, out e ao clock.
*executa o programa*
Aqui, vemos que são adicionadas 3 moedas de cinco, sabendo que as adições só ocorrem em borda positiva do clock,
e que o programa então tem valor de 'out' como 00, o que equivale a 'saldo insuficiente'.
3°-
		in = 2'b01;
		#2;
		in = 2'b01;
		#2;
		in = 2'b01;
		#2;
		$finish;

{DESLIGA O DISPLAY DO CLOCK, MANTÉM O DE ESTADO}
Aqui vemos um exemplo de cancelamento e devolução. O estado 8 é equivalente ao parâmetro est_cancel.
4°-
		in = 2'b01;
		#2;
		in = 2'b10;
		#2;
		in = 2'b00;
		#2;
		$finish;

{DESLIGA O DISPLAY DE ESTADO}
Terminados os exemplos requeridos no TP, também gostariamos de mostrar o exemplo uma sequencia de compras,
que foi especificado que a máquina deveria suportar.
Aqui, primeiro adicionamos 3 moedas de 10, depois uma de 5, uma de 10 e uma de 25
5°-
in = 2'b10;
		#2;
		in = 2'b10;
		#2;
		in = 2'b10;
		#2;
		in = 2'b01;
		#2;
		in = 2'b10;
		#2;
		in = 2'b11;
		#2;
		in = 2'b01;
		#2;
		in = 2'b10;
		#2;
		in = 2'b00;
		#2;
		$finish;
*/