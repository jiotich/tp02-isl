module maosma(clk, in, out, confirm);

	input clk, confirm;
	input [1:0] in;
	output [1:0] out;

	reg [1:0] out;
	reg [3:0] state;
	reg [3:0] last_state;

	parameter est_0 = 0, est_5 = 1, est_10 = 2, est_15 = 3, est_20 = 4, est_25 = 5, est_30 = 6, est_30plus = 7, est_cancel = 8;

	initial begin
		state = est_0;
	end

	always @(state) 
		begin
			//$display("\nSTATE: %d, current_in: %b", state, in);//DISPLAY DE ESTADO
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
						$display("\n***DOCE COMPRADO***\n");
						
					end
				est_30plus:
					begin
						out = 2'b11;
						$display("\n***DOCE COMPRADO e TROCO RECUPERADO***\n");
					end
				est_cancel:
					begin
						out = 2'b01;
						$display("\n***CANCELADO e TROCO RECUPERADO***\n");
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
										state = est_0;
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

/*
{DEIXA O DISPLAY DE ESTADO LIGADO}
Nas especifica????es foi exigido que houvesse uma vari??vel de confirma????o de entrada da moeda, que aqui ?? a 'confirm'
Por quest??es de praticidade, para o v??deo, a gente deixou ela como sendo sempre verdadeira.
*executa o programa*
Aqui vemos a passagem de estados, e o retorno ao estado inicial ap??s atingidos os 30c.
1??-
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
Esse caso ?? parecido com o anterior, s?? que passando pelo estado de doce + troco.
2??-
		in = 2'b10;
		#2;
		in = 2'b11;
		#2;
		in = 2'b00;
		#2;
		$finish;

{MANT??M  O DISPLAY DE ESTADO, LIGA O DISPLAY DO CLOCK}
Nesse caso ?? necess??rio que vejamos o valor de sa??da. Para isso, liga-se o display associado a in, out e ao clock.
*executa o programa*
Aqui, vemos que s??o adicionadas 3 moedas de cinco, sabendo que as adi????es s?? ocorrem em borda positiva do clock,
e que o programa ent??o tem valor de 'out' como 00, o que equivale a 'saldo insuficiente'.
3??-
		in = 2'b01;
		#2;
		in = 2'b01;
		#2;
		in = 2'b01;
		#2;
		$finish;

{DESLIGA O DISPLAY DO CLOCK, MANT??M O DE ESTADO}
Aqui vemos um exemplo de cancelamento e devolu????o. O estado 8 ?? equivalente ao par??metro est_cancel.
4??-
		in = 2'b01;
		#2;
		in = 2'b10;
		#2;
		in = 2'b00;
		#2;
		$finish;

{DESLIGA O DISPLAY DE ESTADO}
Terminados os exemplos requeridos no TP, tamb??m gostariamos de mostrar o exemplo uma sequencia de compras,
que foi especificado que a m??quina deveria suportar.
Aqui, primeiro adicionamos 3 moedas de 10, depois uma de 5, uma de 10 e uma de 25
5??-
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