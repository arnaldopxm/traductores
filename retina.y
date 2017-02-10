class Parser

	token 'true' 'false' 'and' 'or' 'not' '==' '\=' '>=' '<=' '>' '<' ';' '=' '\\' '(' ')' '->' ',' 'numero' 'string' '-' '*' '/' '%' 'mod' 'div' 'program' 'read' 'write' 'writeln' 'if' 'then' 'end' 'while' 'do' 'repeat' 'times' 'func' 'begin' 'return' 'for' 'from' 'to' 'by' 'is' 'home' 'openeye' 'closeeye' 'forward' 'backward' 'rotatel' 'rotater' 'setposition' 'arc' 'boolean' 'number' 'variable' 'with' UMENOS

	prechigh
			right UMINUS ','
			left Por Entre Porcentaje Div Mod Coma
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
		'string' 'Strings'
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
		'openeye' 'OpenEye'
		'closeeye' 'CloseEye'
		'forward' 'Forward'
		'backward' 'Backward'
		'rotatel' 'RotateL'
		'rotater' 'RotateR'
		'setposition' 'SetPosition'
		'arc' 'Arc'
		'variable' 'Variables'
		'with' 'With'

end

start Retina

rule

	Aritmetica : '(' Aritmetica ')' {val[1]}
		| Variables { result = val[0]}
		| Numero {result = val[0]}
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

		#no esta imprimiendo bien el nombre
	TipoDeDato: 'number' {result = TipoDato_.new(val[0])}
	  | 'boolean' {result = TipoDato_.new(val[0])}
		;

	Declaracion: TipoDeDato Variables {result = OpDeclaracion.new(val[0],val[1])}
		|TipoDeDato Asignacion {result = OpDeclaracion.new(val[0],val[1])}
		;

	Declaraciones: Declaracion ';' {result = val[0]}
		| Declaracion ';' Declaraciones {result = BinaryOP.new(val[0],val[2])}
		;

	Asignacion: Variables '=' Logica {result = OpAsignacion.new(val[0],val[2])}
		| Variables '=' Aritmetica {result = OpAsignacion.new(val[0],val[2])}
		;

	FuncionesSinArg: 'home' {result = Palabra.new(val[0])}
		| 'openeye' {result = Palabra.new(val[0])}
		| 'closeeye' {result = Palabra.new(val[0])}
		;

	FuncionesUnArg: 'forward' {result = Palabra.new(val[0])}
		|	'backward' {result = Palabra.new(val[0])}
		| 'rotatel' {result = Palabra.new(val[0])}
		| 'rotater' {result = Palabra.new(val[0])}
		;

	FuncionesDosArgs: 'setposition' {result = Palabra.new(val[0])}
		| 'arc' {result = Palabra.new(val[0])}
		;

	LLamadaFunciones: Variables '(' ')' {result = LlamadaFuncion.new(val[0])}
		| FuncionesSinArg '(' ')' {result = LlamadaFuncion.new(val[0])}
		| FuncionesUnArg '(' Arg ')' {result = FuncionArg.new(val[0],val[2])}
		| FuncionesDosArgs '(' Arg ',' Arg ')' {result = ThreeOP.new(val[0],val[2],val[4])}
		| Variables '(' Arg ')' {result = FuncionArg.new(val[0],val[2])}
		| Variables '(' Args ')' {result = FuncionArg.new(val[0],val[2])}
		;

	Arg: Variables {result = Argumento.new(val[0])}
		| Logica {result = Argumento.new(val[0])}
		| Aritmetica {result = Argumento.new(val[0])}

	Args: Arg {result = val[0]}
		| Arg ',' Args {result = BinaryOP.new(val[0],val[2])}

	PalabraFunc: 'func' {result = Palabra.new(val[0])};

	Instrucciones: LLamadaFunciones ';' {result = val[0]}
		| Asignacion ';' {result = val[0]}
		| Aritmetica ';' {result = val[0]}
		| Logica ';' {result = val[0]}
		| BloqueW ';' {result = val[0]}
		| BloqueDo ';' {result = val[0]}
		| Entrada ';' {result = val[0]}
		| Salida ';' {result = val[0]}
		| Instrucciones Instrucciones {result = Instruccion_.new(val[0],val[1])}

	Argumento: Declaracion {result = val[0]}
		| Declaracion ',' Argumento {result = BinaryOP.new(val[0],val[2])}
		;

	Return: 'return' Aritmetica ';' {result = Return_.new(val[1])}
		| 'return' LLamadaFunciones ';' {result = Return_.new(val[1])}
		| 'return' Logica ';' {result = Return_.new(val[1])}
		;

	DeclaracionFunciones: PalabraFunc Variables '(' Argumento ')' 'begin' Instrucciones 'end' ';' {result = Funcion_.new(val[0],val[1],val[3],val[6])}
		| PalabraFunc Variables '(' ')' 'begin' Instrucciones 'end' ';' {result = Funcion_.new(val[0,val[1],nil,val[5]])}
		| PalabraFunc Variables '(' Argumento ')' '->' TipoDeDato 'begin' Instrucciones Return 'end' ';' {result = Funcion_R.new(val[0],val[1],val[3],val[6],val[8],val[9])}
		| PalabraFunc Variables '(' ')' '->' TipoDeDato 'begin' Instrucciones Return 'end' ';' {result = Funcion_R.new(val[0],val[1],nil,val[5],val[7],val[8])}
		;

	BloqueDo: 'do' Instrucciones 'end' {result = Bloque.new(val[1],nil)}
		|
		;

	Numero: 'numero' {result = Num.new(val[0])}
		|
		;

	BloqueW: 'with' Declaraciones BloqueDo {result = Bloque.new(val[1],val[2])}
		| 'if' Logica 'then' Instrucciones 'end' {result = Condicional.new(val[1],val[3],nil)}
		| 'if' Logica 'then' Instrucciones 'else' Instrucciones 'end' {result = Bloque.new(val[1],val[3],val[5])}
		| 'while' Logica BloqueDo {result = Bloque.new(val[1],val[3])}
		| 'for' Variables 'from' Numero 'to' Numero BloqueDo {result = Iteracion.new(val[1],val[3],val[5],val[6])}
		| 'repeat' Numero 'times' Instrucciones 'end' {result = Iteracion.new(val[1],val[3],nil,nil)}
		| 'repeat' Variables 'times' Instrucciones 'end' {result = Iteracion.new(val[1],val[3],nil,nil)}
		;

	Entrada: 'read' Variables {result = Entrada.new(val[1])}
		|
		;

	CadenaCarac: 'string' {result = String_.new(val[0])}
		|
		;

	ElemSalida: CadenaCarac {result = val[0]}
		| Logica {result = val[0]}
		| Aritmetica {result = val[0]}
		| LLamadaFunciones {result = val[0]}
		;

	BloqSalida: ElemSalida {result = Salida_.new(val[0],nil)}
		| ElemSalida ',' BloqSalida {result = Salida_.new(val[0],val[2])}
		;

	Salida: 'write' BloqSalida {result = val[1]}
		| 'writeln' BloqSalida {result = val[1]}
		;

	Program: 'program' Instrucciones 'end' ';' {result = Programa.new(val[1])}
		|
		;

	Retina:  DeclaracionFunciones Program {result = FinalRetina.new(val[0],val[1])}
		| DeclaracionFunciones {result = FinalRetina.new(val[0],nil)}
		| Program {result = FinalRetina.new(val[0],nil)}
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
    raise SyntacticError::new(token)
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
