class Parser

	token 'true' 'false' 'and' 'or' 'not' '==' '\=' '>=' '<=' '>' '<' ';' '=' '\' '(' ')' '->' ',' 'Numero' 'Strings' '-' '*' '/' '%' 'mod' 'div' 'program' 'read' 'write' 'writeln' 'if' 'then' 'end' 'while' 'do' 'repeat' 'times' 'func' 'begin' 'return' 'for' 'from' 'to' 'by' 'is' 'home' 'openeye' 'closeeye' 'forward' 'backward' 'rotatel' 'rotater' 'setposition' 'arc' 'boolean' 'number' UMENOS
	convert 
		'number' 'Number'
		'boolean' 'Boolean'
		'true' 'True'
		'false' 'False'
		'and' 'And'
		'or' 'Or' 
		'not' 'Not' 
		'==' 'Igual'
		'\=' 'Distinto'
		'>=' 'MayorIgual'
		'<=' 'MenorIgual'
		'>' 'Mayor'
		'<' 'Menor'
		';' 'Separador'
		'=' 'Asignacion'
		'\' 'BackSlash'
		'(' 'ParentesisA'
		')' 'ParentesisC'
		'->' 'Flecha'
		','  'Coma'
		'Numero' 'Numero'
		'Strings' 'Strings'
		'-' 'Menos'
		'*' 'Por'
		'/' 'Entre'
		'%' 'Porcentaje'
		'+' 'Mas'
		'div' 'Div'
		'mod' 'Mod'
		'program' 'Program'
		'read' 'Read'
		'write' 'Write'
		'writeln' 'Writeln'
		'if' 'If'
		'then' 'Then'
		'end' 'End'
		'while' 'While'
		'do' 'Do'
		'repeat' 'Repeat'
		'times' 'Times'
		'func' 'Func'
		'begin' 'Begin'
		'return' 'Return'
		'for' 'For'
		'from' 'From'
		'to' 'To'
		'by' 'By'
		'is' 'Is'
		'home' 'Home'
		'openeeye' 'OpenEye'
		'closeeye' 'CloseEye'
		'forward' 'Forward'
		'backward' 'Backward'
		'rotatel' 'RotateL'
		'rotater' 'RotateR'
		'setposition' 'SetPosition'
		'arc' 'Arc'



    prechigh
        Right UMINUS
        left Por Entre Porcentaje Div Mod
        left Mas Menos
	preclow
end

start retina

rule

	retina: 'program' Bloque 'end' ';'
		  | Funciones 'program' Bloque 'end' ';'
		  ;

	Funciones: 'func' 'variable' '(' ')' 'begin' Bloque 'end' ';'
			| 'func' 'variable' '(' Arg ')' 'begin' Bloque 'end' ';'
			| 'func' 'variable' '(' ')' '->' Tipo 'begin' Bloque 'return' Exp ';' 'end' ';'
			| 'func' 'variable' '(' Arg ')' '->' Tipo 'begin' Bloque 'return' Exp 'end' ';'
			| Funciones Funciones
			;

	FReservadas : 'home'
				| 'openeye'
				| 'closeeye'
				| 'forward'
				| 'backward'
				| 'rotatel'
				| 'rotater'
				| 'setposition'
				| 'arc'
				;

	Bloque  : 'if' Exp 'then' Bloque 'end' ';'
			| 'if' Exp 'then' Bloque 'else' Bloque 'end' ';'
			| 'while' Exp 'do' Bloque 'end' ';'
			| 'for' 'variable' 'from' 'numero' 'to' 'numero' 'do' Bloque 'end' ';'
			| 'tipo' 'variable' ';'
			| 'tipo' 'variable' '=' Exp ';'
			| 'repeat' 'numero' 'times' Bloque 'end' ';'
			| 'repeat' 'variable' 'times' Bloque 'end' ';'
			| FReservada '(' Arg ')';
			| FReservada '(' ')';
			| 'variable' '(' Arg ')';
			| 'variable' '(' ')';
			| Exp;
			| 'with' Declaracion 'do' Bloque 'end' ';'
			;

	Declaracion : Tipo 'variable';
				| Tipo 'variable'; Declaracion
				;

	Tipo: 'number'
		| 'boolean'
		;

	Arg: Tipo 'variable'
	   | Tipo 'variable' ',' Arg
	   ;

	Exp : '(' Exp ')'
		| 'Numero'
		| 'true'
		| 'false'
		| 'variable'
		| '-' Exp = UMENOS 		{ result = UnaryMenos.new(val[1])}
		| Exp '+' Exp 			{ result = OpSuma.new(val[0],val[2])}
		| Exp '-' Exp 			{ result = OpResto.new(val[0],val[2])}
		| Exp '/' Exp 			{ result = OpDivision.new(val[0],val[2])}
		| Exp '*' Exp 			{ result = OpMultiplicacion.new(val[0],val[2])}
		| Exp 'mod' Exp 		{ result = OpMod.new(val[0],val[2])}
		| Exp 'div' Exp 		{ result = OpDiv.new(val[0],val[2])}
		| Exp '>' Exp 			{ result = OpMayor.new(val[0],val[2])}
		| Exp '<' Exp		    { result = OpMenor.new(val[0],val[2])}
		| Exp '>=' Exp 			{ result = OpMayorIgual.new(val[0],val[2])}
		| Exp '<=' Exp 			{ result = OpMenorIgual.new(val[0],val[2])}
		| Exp 'and' Exp 		{ result = OpAnd.new(val[0],val[2])}
		| Exp 'or' Exp			{ result = OpOr.new(val[0],val[2])}
		| Exp '==' Exp 			{ result = OpIgual.new(val[0],val[2])}
		| Exp '\=' Exp 			{ result = OpDistinto.new(val[0],val[2])}
		| 'not' Exp 			{ result = UnaryNot.new(val[1])}
		|  Exp '=' Exp;					{ result = OpAsignacion.new(val[0],val[2])}
		;

