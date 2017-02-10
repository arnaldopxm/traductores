class Parser

	token 'true' 'false' 'and' 'or' 'not' '==' '\=' '>=' '<=' '>' '<' ';' '=' '\\' '(' ')' '->' ',' 'numero' 'Strings' '-' '*' '/' '%' 'mod' 'div' 'program' 'read' 'write' 'writeln' 'if' 'then' 'end' 'while' 'do' 'repeat' 'times' 'func' 'begin' 'return' 'for' 'from' 'to' 'by' 'is' 'home' 'openeye' 'closeeye' 'forward' 'backward' 'rotatel' 'rotater' 'setposition' 'arc' 'boolean' 'number' 'variable' UMENOS

	prechigh
			right UMINUS
			left Por Entre Porcentaje Div Mod
			left Mas Menos
	preclow

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
		'\\' 'BackSlash'
		'(' 'ParentesisA'
		')' 'ParentesisC'
		'->' 'Flecha'
		','  'Coma'
		'numero' 'Numero'
		'strings' 'Strings'
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
		'variable' 'Variables'

end

start Logica

rule
/*
	Retina: 'program' codigo 'end' ';'
		  | Funciones 'program' codigo 'end' ';'
		  ;

	Funciones: 'func' 'variable' '(' ')' 'begin' Bloque 'end' ';'
			| 'func' 'variable' '(' Arg ')' 'begin' Bloque 'end' ';'
			| 'func' 'variable' '(' ')' '->' Tipo 'begin' Bloque 'return' Aritmetica ';' 'end' ';'
			| 'func' 'variable' '(' Arg ')' '->' Tipo 'begin' Bloque 'return' Aritmetica 'end' ';'
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

	Bloque  : 'if' Aritmetica 'then' Bloque 'end' ';'
			| 'if' Aritmetica 'then' Bloque 'else' Bloque 'end' ';'
			| 'while' Aritmetica 'do' Bloque 'end' ';'
			| 'for' 'variable' 'from' 'numero' 'to' 'numero' 'do' Bloque 'end' ';'
			| Aritmetica '=' Aritmetica;
			| 'tipo' 'variable' ';'
			| 'tipo' 'variable' '=' Aritmetica ';'
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
*/
	Aritmetica : '(' Aritmetica ')' {val[1]}
		| Variables { result = val[0]}
		| 'numero' {result = Num.new(val[0])}
		| '-' Aritmetica = UMENOS {result = UnaryMenos.new(val[1])}
		| Aritmetica '+' Aritmetica {result = OpSuma.new(val[0],val[2])}
		| Aritmetica '-' Aritmetica {result = OpResta.new(val[0],val[2])}
		| Aritmetica '/' Aritmetica {result = OpDivision.new(val[0],val[2])}
		| Aritmetica '*' Aritmetica {result = OpMultiplication.new(val[0],val[2])}
		| Aritmetica 'mod' Aritmetica {result = OpMod.new(val[0],val[2])}
		| Aritmetica 'div' Aritmetica {result = OpDiv.new(val[0],val[2])}
		| Aritmetica '%' Aritmetica {result = OpModulo.new(val[0],val[2])}
		;

	Logica: '(' Logica ')' {result = val[1]}
		| Variables { result = val[0]}
		| 'true' {result = True_.new(val[0])}
		| 'false' {result = False_.new(val[0])}
		| 'not' Logica {result = UnaryNot.new(val[1])}
		| Logica '>' Logica {result = OpMayor.new(val[0],val[2])}
		| Logica '<' Logica {result = OpMenor.new(val[0],val[2])}
		| Logica '>=' Logica {result = OpMayorIgual.new(val[0],val[2])}
		| Logica '<=' Logica {result = OpMenorIgual.new(val[0],val[2])}
		| Logica 'and' Logica {result = OpAnd.new(val[0],val[2])}
		| Logica 'or' Logica {result = OpOr.new(val[0],val[2])}
		| Logica '==' Logica {result = OpIgual.new(val[0],val[2])}
		| Logica '\=' Logica {result = OpDistinto.new(val[0],val[2])}
		;

	Variables: '(' Variables ')' { result = val[1]}
		| 'variable' {result = Identificado.new(val[0])}
		;

	TipoDeDato: 'number' {result = TipoDato_.new(val[0])}
	  | 'boolean' {result = TipoDato_.new(val[0])}
		;






---- header
require_relative "retina.rb"
require_relative "retina_ast.rb"

class SyntacticError < RuntimeError

    def initialize(tok)
        @token = tok
    end

    def to_s
        "Syntactic error on: #{@token}"
    end
end

---- inner
begin
def on_error(id, token, stack)
    #raise SyntacticError::new(token)
end

def next_token
		if !@tokens.empty?
	    token = @tokens[0]
			@tokens = @tokens[1..@tokens.length]
			#puts "#{token.class},#{token}"
			return [token.class,token]
		else
    	return [false,false]
		end
end

def parse(tokens)
    @yydebug = true
    #@lexer = lexer
    @tokens = tokens
		#puts " #{@tokens}..."
    ast = do_parse
		#puts "#{ast} astast"
    return ast
end
end
