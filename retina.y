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

	retina: 'program' codigo 'end' ';'
		  | Funciones 'program' codigo 'end' ';'
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
			| Exp '=' Exp;
			| 'tipo' 'variable' ';'
			| 'tipo' 'variable' '=' Exp ';'
			| 'repeat' 'numero' 'times' Bloque 'end' ';'
			| 'repeat' 'variable' 'times' Bloque 'end' ';'
			| func
			| llamadas a funciones con y sin atributos
			| WITH
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
		| '-' Exp = UMENOS
		| Exp '+' Exp
		| Exp '-' Exp
		| Exp '/' Exp
		| Exp '*' Exp
		| Exp 'mod' Exp
		| Exp 'div' Exp
		| Exp '>' Exp
		| Exp '<' Exp
		| Exp '>=' Exp
		| Exp '<=' Exp
		| Exp 'and' Exp
		| Exp 'or' Exp
		| Exp '==' Exp
		| Exp '\=' Exp
		| 'not' Exp
		| Exp '+' Exp
		;

