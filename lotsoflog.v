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