module Full_Adder(a, subOut, cin, cout, s);

	input a, subOut, cin;
	output cout, s;
	
	wire andOut1, andOut2, andOut3, andOut4, andOut5, andOut6, andOut7;

	and
		and1(andOut1, cin, a),
		and2(andOut2, cin, subOut),
		and3(andOut3, a, subOut);

	or
		or1(cout, andOut1, andOut2, andOut3);

	and
		and4(andOut4, ~a, subOut, ~cin),
		and5(andOut5, a, ~subOut, ~cin),
		and6(andOut6, ~a, ~subOut, cin),
		and7(andOut7, cin, subOut, a);

	or
		or2(s, andOut4, andOut5, andOut6, andOut7);
/*
	initial
		begin
			$monitor($time,,,,, "a=%b subOut=%b cin=%b cout=%b s=%b", a, subOut, cin, cout, s);
			$display($time,,,,, "a=%b subOut=%b cin=%b cout=%b s=%b", a, subOut, cin, cout, s);
			#10	a=0; subOut=0; cin=0;
			#10	a=0; subOut=0; cin=1;
			#10	a=0; subOut=1; cin=0;
			#10	a=0; subOut=1; cin=1;
			#10	a=1; subOut=0; cin=0;
			#10	a=1; subOut=0; cin=1;
			#10	a=1; subOut=1; cin=0;
			#10	a=1; subOut=1; cin=1;
			#10
			$display($time,,,,, "a=%b subOut=%b cin=%b cout=%b s=%b", a, subOut, cin, cout, s);	
		end
*/

endmodule

module Arithmetic_Logic_Unit(a, b, op, cin, less, sub, cout, set, out);

	input a, b, cin, less, sub;
	input[1:0] op;
	output cout, andOut1, orOut1, subOut, set, s, out;
	reg out, set, subOut;

	and	and1(andOut1, a, b);
	or	or1(orOut1, a, b);
	//Any time b or sub changes we set the value of subOut to either b or !b depending on the value of sub.
	always @(b or sub)
		case(sub)
			0 : subOut = b;
			1 : subOut = ~b;
		endcase
	//Full-adder within ALU.
	Full_Adder f0 (a, subOut, cin, cout, s);

	//Set is always equal to the s output of the full-adder.
	always @(s)
		set = s;
	//The 4-to-1 mux implemented with cases for each combination of bits for the op code.
	always @(op or andOut1 or orOut1 or s or less)
		case(op[1])

			0:
			case(op[0])
				0 : out = andOut1;	
				1 : out = orOut1;
			endcase

			1:
			case(op[0])
				0 : out = s;
				1 : out = less;
			endcase

		endcase
/*
	initial
		begin
			$monitor($time,,,,, "a=%b b=%b cin=%b op=%b less=%b sub=%b cout=%b s=%b set=%b out=%b",
			a, subOut, cin, op, less, sub, cout, s, set, out);
			$display($time,,,,, "a=%b b=%b cin=%b op=%b less=%b sub=%b cout=%b s=%b set=%b out=%b",
			a, subOut, cin, op, less, sub, cout, s, set, out);
			#10	a=0; subOut=0; cin=0; less=0; sub=0; op=01; b=0;
			#10	a=0; subOut=0; cin=1; less=1; sub=0; op=01; b=0;
			#10	a=0; subOut=1; cin=0; less=0; sub=0; op=01; b=1;
			#10	a=0; subOut=1; cin=1; less=1; sub=0; op=01; b=1;
			#10	a=1; subOut=0; cin=0; less=0; sub=0; op=01; b=0;
			#10	a=1; subOut=0; cin=1; less=1; sub=0; op=01; b=0;
			#10	a=1; subOut=1; cin=0; less=0; sub=0; op=01; b=1;
			#10	a=1; subOut=1; cin=1; less=1; sub=0; op=01; b=1;
			#10
			$display($time,,,,, "a=%b b=%b cin=%b op=%b less=%b sub=%b cout=%b s=%b set=%b out=%b",
			a, subOut, cin, op, less, sub, cout, s, set, out);
		end
*/
endmodule

module Overall_ALU(a, b, sub, op, zero, out, overflow, cout);

	input [1:0] op;
	input sub;
	input [31:0] a, b;

	output [31:0] out;
	//Wires that connect all cout outputs to the cin input of the next circuit.
	wire c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17, c18, c19, c20, c21, c22, c23,
	c24, c25, c26, c27, c28, c29, c30;
	output set, cout, overflow, zero, beq;
	reg beq, overflow;
	wire setOut;

	//All 32 individual ALU's are being connected with unique cases for the first and last ALU's.
	Arithmetic_Logic_Unit alu0(a[0], b[0], op, sub, setOut, sub, c0, set, out[0]);
	Arithmetic_Logic_Unit alu1(a[1], b[1], op, c0, 0, sub, c1, set, out[1]);
	Arithmetic_Logic_Unit alu2(a[2], b[2], op, c1, 0, sub, c2, set, out[2]);
	Arithmetic_Logic_Unit alu3(a[3], b[3], op, c2, 0, sub, c3, set, out[3]);
	Arithmetic_Logic_Unit alu4(a[4], b[4], op, c3, 0, sub, c4, set, out[4]);
	Arithmetic_Logic_Unit alu5(a[5], b[5], op, c4, 0, sub, c5, set, out[5]);
	Arithmetic_Logic_Unit alu6(a[6], b[6], op, c5, 0, sub, c6, set, out[6]);
	Arithmetic_Logic_Unit alu7(a[7], b[7], op, c6, 0, sub, c7, set, out[7]);
	Arithmetic_Logic_Unit alu8(a[8], b[8], op, c7, 0, sub, c8, set, out[8]);
	Arithmetic_Logic_Unit alu9(a[9], b[9], op, c8, 0, sub, c9, set, out[9]);
	Arithmetic_Logic_Unit alu10(a[10], b[10], op, c9, 0, sub, c10, set, out[10]);
	Arithmetic_Logic_Unit alu11(a[11], b[11], op, c10, 0, sub, c11, set, out[11]);
	Arithmetic_Logic_Unit alu12(a[12], b[12], op, c11, 0, sub, c12, set, out[12]);
	Arithmetic_Logic_Unit alu13(a[13], b[13], op, c12, 0, sub, c13, set, out[13]);
	Arithmetic_Logic_Unit alu14(a[14], b[14], op, c13, 0, sub, c14, set, out[14]);
	Arithmetic_Logic_Unit alu15(a[15], b[15], op, c14, 0, sub, c15, set, out[15]);
	Arithmetic_Logic_Unit alu16(a[16], b[16], op, c15, 0, sub, c16, set, out[16]);
	Arithmetic_Logic_Unit alu17(a[17], b[17], op, c16, 0, sub, c17, set, out[17]);
	Arithmetic_Logic_Unit alu18(a[18], b[18], op, c17, 0, sub, c18, set, out[18]);
	Arithmetic_Logic_Unit alu19(a[19], b[19], op, c18, 0, sub, c19, set, out[19]);
	Arithmetic_Logic_Unit alu20(a[20], b[20], op, c19, 0, sub, c20, set, out[20]);
	Arithmetic_Logic_Unit alu21(a[21], b[21], op, c20, 0, sub, c21, set, out[21]);
	Arithmetic_Logic_Unit alu22(a[22], b[22], op, c21, 0, sub, c22, set, out[22]);
	Arithmetic_Logic_Unit alu23(a[23], b[23], op, c22, 0, sub, c23, set, out[23]);
	Arithmetic_Logic_Unit alu24(a[24], b[24], op, c23, 0, sub, c24, set, out[24]);
	Arithmetic_Logic_Unit alu25(a[25], b[25], op, c24, 0, sub, c25, set, out[25]);
	Arithmetic_Logic_Unit alu26(a[26], b[26], op, c25, 0, sub, c26, set, out[26]);
	Arithmetic_Logic_Unit alu27(a[27], b[27], op, c26, 0, sub, c27, set, out[27]);
	Arithmetic_Logic_Unit alu28(a[28], b[28], op, c27, 0, sub, c28, set, out[28]);
	Arithmetic_Logic_Unit alu29(a[29], b[29], op, c28, 0, sub, c29, set, out[29]);
	Arithmetic_Logic_Unit alu30(a[30], b[30], op, c29, 0, sub, c30, set, out[30]);
	Arithmetic_Logic_Unit alu31(a[31], b[31], op, c30, 0, sub, cout, setOut, out[31]);

	//All outputs of each individual ALU are put into a nor gate in order to form the zero output.
	nor
		nor1(zero, out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7], out[8], out[9],
		out[10], out[11], out[12], out[13], out[14], out[15], out[16], out[17], out[18], out[19],
		out[20], out[21], out[22], out[23], out[24], out[25], out[26], out[27], out[28], out[29], 
		out[30], out[31]);
	//Overflow is always the same value as cout, which is the cout output of the last ALU.
	always @(cout)
		overflow = cout;
	//beq always has the same value as zero.
	always @(zero)
		beq = zero;
/*
	initial
		begin
			$monitor($time,,,,, "a=%b b=%b sub=%b op=%b set=%b out=%b overflow=%b beq=%b zero=%b",
			a, b, sub, op, set, out, overflow, beq, zero);
			$display($time,,,,, "a=%b b=%b sub=%b op=%b set=%b out=%b overflow=%b beq=%b zero=%b",
			a, b, sub, op, set, out, overflow, beq, zero);
			#10 a=0; b=0; op=10; sub=1;
			#10 a=23; b=23; op=10; sub=1;
			#10 a=5; b=7; op=10; sub=1;
			#10 a=1; b=7; op=10; sub=1;
			#10 a=110; b=17; op=10; sub=1;
			#10 a=25; b=25; op=10; sub=1;
			#10
			$display($time,,,,, "a=%b b=%b sub=%b op=%b set=%b out=%b overflow=%b beq=%b zero=%B",
			a, b, sub, op, set, out, overflow, beq, zero);
		end
*/
endmodule

module ThirtyTwoBit_Alu();

	reg [31:0] a, b;
	reg [2:0] op;
	output [31:0] out;
	output zero, overflow, cout, beq;
	
	//Entire ALU is implemented with the sub and op inputs combining to make a 3-bit op code.
	Overall_ALU oalu0(a, b, op[2], op[1:0], zero, out, overflow, cout);

	initial
		begin
			$monitor($time,,,,, "a=%b b=%b op=%b out=%b zero=%b cout=%b overflow=%b",
			a, b, op, out, zero, cout, overflow);
			$display($time,,,,, "a=%b b=%b op=%b out=%b zero=%b cout=%b overflow=%b",
			a, b, op, out, zero, cout, overflow);
			#10 a[31:0]=0; b[31:0]=0; op[2:0]=110;
			#10 a[31:0]=0; b[31:0]=1; op[2:0]=110;
			#10 a[31:0]=0; b[31:0]=2; op[2:0]=110;
			#10 a[31:0]=0; b[31:0]=3; op[2:0]=110;
			#10 a[31:0]=1; b[31:0]=0; op[2:0]=110;
			#10 a[31:0]=1; b[31:0]=1; op[2:0]=110;
			#10 a[31:0]=1; b[31:0]=2; op[2:0]=110;
			#10 a[31:0]=1; b[31:0]=3; op[2:0]=110;
			#10 a[31:0]=2; b[31:0]=0; op[2:0]=110;
			#10 a[31:0]=2; b[31:0]=1; op[2:0]=110;
			#10 a[31:0]=2; b[31:0]=2; op[2:0]=110;
			#10 a[31:0]=2; b[31:0]=3; op[2:0]=110;
			#10 a[31:0]=3; b[31:0]=0; op[2:0]=110;
			#10 a[31:0]=3; b[31:0]=1; op[2:0]=110;
			#10 a[31:0]=3; b[31:0]=2; op[2:0]=110;
			#10 a[31:0]=3; b[31:0]=3; op[2:0]=110;
			#10
			$display($time,,,,, "a=%b b=%b op=%b out=%b zero=%b cout=%b overflow=%b",
			a, b, op, out, zero, cout, overflow);
		end
endmodule
