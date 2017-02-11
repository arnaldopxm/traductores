class Parser

	token 'true' 'false' 'and' 'or' 'not' '==' '\=' '>=' '<=' '>' '<' ';' '=' '\\' '(' ')' '->' ',' 'numero' 'string' '-' '*' '/' '%' 'mod' 'div' 'program' 'read' 'write' 'writeln' 'if' 'then' 'end' 'while' 'do' 'repeat' 'times' 'func' 'begin' 'return' 'for' 'from' 'to' 'by' 'is' 'home' 'openeye' 'closeeye' 'forward' 'backward' 'rotatel' 'rotater' 'setposition' 'arc' 'boolean' 'number' 'variable' 'with' UMENOS

	prechigh
			right UMENOS ',' 'not' '='
			left '*' '/' '%' 'mod' 'div' '==' '\=' '>=' '<=' '>' '<' 'and'
			left '+' '-' 'or'
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
		'else' 'Else'

end

start Retina

rule

	Aritmetica : '(' Aritmetica ')' {result = val[1]}
		| Numero {result = val[0]}
		| '-' Aritmetica = UMENOS {result = UnaryMenos.new(val[1])}
		| Aritmetica '+' Aritmetica {result = OpSuma.new(val[0],val[2],'Suma:')}
		| Aritmetica '-' Aritmetica {result = OpResta.new(val[0],val[2],'Resta:')}
		| Aritmetica '/' Aritmetica {result = OpDivision.new(val[0],val[2],'Division:')}
		| Aritmetica '*' Aritmetica {result = OpMultiplication.new(val[0],val[2],'Multiplicacion:')}
		| Aritmetica 'mod' Aritmetica {result = OpMod.new(val[0],val[2],'Modulo:')}
		| Aritmetica 'div' Aritmetica {result = OpDiv.new(val[0],val[2],'Division:')}
		| Aritmetica '%' Aritmetica {result = OpModulo.new(val[0],val[2],'Modulo:')}
		| '-' Variables = UMENOS {result = UnaryMenos.new(val[1])}
		| Aritmetica '+' Variables {result = OpSuma.new(val[0],val[2],'Suma:')}
		| Aritmetica '-' Variables {result = OpResta.new(val[0],val[2],'Resta:')}
		| Aritmetica '/' Variables {result = OpDivision.new(val[0],val[2],'Division:')}
		| Aritmetica '*' Variables {result = OpMultiplication.new(val[0],val[2],'Multiplicaion:')}
		| Aritmetica 'mod' Variables {result = OpMod.new(val[0],val[2],'Modulo:')}
		| Aritmetica 'div' Variables {result = OpDiv.new(val[0],val[2],'Division:')}
		| Aritmetica '%' Variables {result = OpModulo.new(val[0],val[2],'Modulo:')}
		| Variables '+' Aritmetica {result = OpSuma.new(val[0],val[2],'Suma:')}
		| Variables '-' Aritmetica {result = OpResta.new(val[0],val[2],'Resta:')}
		| Variables '/' Aritmetica {result = OpDivision.new(val[0],val[2],'Division:')}
		| Variables '*' Aritmetica {result = OpMultiplication.new(val[0],val[2],'Multiplicacion:')}
		| Variables 'mod' Aritmetica {result = OpMod.new(val[0],val[2],'Modulo:')}
		| Variables 'div' Aritmetica {result = OpDiv.new(val[0],val[2],'Division:')}
		| Variables '%' Aritmetica {result = OpModulo.new(val[0],val[2],'Modulo:')}
		| Variables '+' Variables {result = OpSuma.new(val[0],val[2],'Suma:')}
		| Variables '-' Variables {result = OpResta.new(val[0],val[2],'Resta:')}
		| Variables '/' Variables {result = OpDivision.new(val[0],val[2],'Division:')}
		| Variables '*' Variables {result = OpMultiplication.new(val[0],val[2],'Multiplicacion:')}
		| Variables 'mod' Variables {result = OpMod.new(val[0],val[2],'Modulo:')}
		| Variables 'div' Variables {result = OpDiv.new(val[0],val[2],'Division:')}
		| Variables '%' Variables {result = OpModulo.new(val[0],val[2],'Modulo:')}

		;

	Logica: '(' Logica ')' {result = val[1]}
		| 'true' {result = True_.new(val[0])}
		| 'false' {result = False_.new(val[0])}
		| 'not' Logica {result = UnaryNot.new(val[1])}
		| Aritmetica '>' Aritmetica {result = OpMayor.new(val[0],val[2],'Mayor Estricto:')}
		| Aritmetica '<' Aritmetica {result = OpMenor.new(val[0],val[2],'Menor Estricto:')}
		| Aritmetica '>=' Aritmetica {result = OpMayorIgual.new(val[0],val[2],'Mayor Igual:')}
		| Aritmetica '<=' Aritmetica {result = OpMenorIgual.new(val[0],val[2],'Menor Igual')}
		| Variables '>' Aritmetica {result = OpMayor.new(val[0],val[2],'Mayor Estricto:')}
		| Variables '<' Aritmetica {result = OpMenor.new(val[0],val[2],'Menor Estricto:')}
		| Variables '>=' Aritmetica {result = OpMayorIgual.new(val[0],val[2],'Mayor Igual:')}
		| Variables '<=' Aritmetica {result = OpMenorIgual.new(val[0],val[2],'Menor Igual')}
		| Aritmetica '>' Variables {result = OpMayor.new(val[0],val[2],'Mayor Estricto:')}
		| Aritmetica '<' Variables {result = OpMenor.new(val[0],val[2],'Menor Estricto:')}
		| Aritmetica '>=' Variables {result = OpMayorIgual.new(val[0],val[2],'Mayor Igual:')}
		| Aritmetica '<=' Variables {result = OpMenorIgual.new(val[0],val[2],'Menor Igual')}
		| Variables '>' Variables {result = OpMayor.new(val[0],val[2],'Mayor Estricto:')}
		| Variables '<' Variables {result = OpMenor.new(val[0],val[2],'Menor Estricto:')}
		| Variables '>=' Variables {result = OpMayorIgual.new(val[0],val[2],'Mayor Igual:')}
		| Variables '<=' Variables {result = OpMenorIgual.new(val[0],val[2],'Menor Igual')}
		| Logica 'and' Logica {result = OpAnd.new(val[0],val[2],'And:')}
		| Logica 'or' Logica {result = OpOr.new(val[0],val[2],'Or:')}
		| Logica '==' Logica {result = OpIgual.new(val[0],val[2],'Equivalente:')}
		| Logica '\=' Logica {result = OpDistinto.new(val[0],val[2],'Distinto:')}
		| 'not' Variables {result = UnaryNot.new(val[1])}
		| Variables 'and' Logica {result = OpAnd.new(val[0],val[2],'And:')}
		| Variables 'or' Logica {result = OpOr.new(val[0],val[2],'Or:')}
		| Variables '==' Logica {result = OpIgual.new(val[0],val[2],'Equivalente:')}
		| Variables '\=' Logica {result = OpDistinto.new(val[0],val[2],'Distinto:')}
		| Logica 'and' Variables {result = OpAnd.new(val[0],val[2],'And:')}
		| Logica 'or' Variables {result = OpOr.new(val[0],val[2],'Or:')}
		| Logica '==' Variables {result = OpIgual.new(val[0],val[2],'Equivalente:')}
		| Logica '\=' Variables {result = OpDistinto.new(val[0],val[2],'Distinto')}
		| Variables 'and' Variables {result = OpAnd.new(val[0],val[2],'And:')}
		| Variables 'or' Variables {result = OpOr.new(val[0],val[2],'Or:')}
		| Variables '==' Variables {result = OpIgual.new(val[0],val[2],'Equivalente:')}
		| Variables '\=' Variables {result = OpDistinto.new(val[0],val[2],'Distinto:')}
		| Aritmetica '==' Variables {result = OpIgual.new(val[0],val[2],'Equivalente:')}
		| Variables '\=' Aritmetica {result = OpDistinto.new(val[0],val[2],'Distinto:')}
		| Variables '==' Aritmetica {result = OpIgual.new(val[0],val[2],'Equivalente:')}
		| Aritmetica '\=' Variables {result = OpDistinto.new(val[0],val[2],'Distinto:')}
		| Aritmetica '==' Aritmetica {result = OpIgual.new(val[0],val[2],'Equivalente:')}
		| Aritmetica '\=' Aritmetica {result = OpDistinto.new(val[0],val[2],'Distinto:')}
		;

	Variables: '(' Variables ')' { result = val[1]}
		| 'variable' {result = Identificado.new(val[0])}
		;

	TipoDeDato: 'number' {result = TipoDato_.new(val[0])}
	  | 'boolean' {result = TipoDato_.new(val[0])}
		;

	Declaracion: TipoDeDato Variables {result = OpDeclaracion.new(val[0],val[1],'')}
		|TipoDeDato Asignacion {result = OpDeclaracion.new(val[0],val[1],'')}
		;

	Declaraciones: Declaracion ';' {result = val[0]}
		| Declaracion ';' Declaraciones {result = EnSerie.new(val[0],val[2])}
		;

	Asignacion: Variables '=' Logica {result = OpAsignacion.new(val[0],val[2],'Asignacion:')}
		| Variables '=' Aritmetica {result = OpAsignacion.new(val[0],val[2],'Asignacion')}
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

	LLamadaFunciones: Variables '(' ')' {result = Funciones_.new(val[0],nil,nil)}
		| FuncionesSinArg '(' ')' {result = Funciones_.new(val[0],nil,nil)}
		| FuncionesUnArg '(' Arg ')' {result = Funciones_.new(val[0],val[2],nil)}
		| FuncionesDosArgs '(' Arg ',' Arg ')' {result = Funciones_.new(val[0],val[2],val[4])}
		| Variables '(' Args ')' {result = Funciones_.new(val[0],val[2],nil)}
		;

	Arg: Logica {result = Argumento.new(val[0])}
		| Aritmetica {result = Argumento.new(val[0])}
		| Variables {result = Argumento.new(val[0])}
		;

	Args: Arg {result = val[0]}
		| Args ',' Arg{result = EnSerie.new(val[0],val[2])}
		;

	PalabraFunc: 'func' {result = Palabra.new(val[0])};

	Instruccion: LLamadaFunciones {result = val[0]}
		| Asignacion {result = val[0]}
		| Aritmetica {result = val[0]}
		| Logica {result = val[0]}
		| BloqueW {result = val[0]}
		| BloqueDo {result = val[0]}
		| Entrada {result = val[0]}
		| Salida {result = val[0]}

	Instrucciones: Instruccion ';' {result = val[0]}
		| Instrucciones Instruccion ';' {result = EnSerie.new(val[0],val[1])}
		;

	Argumento: Declaracion {result = val[0]}
		| Declaracion ',' Argumento {result = EnSerie.new(val[0],val[2])}
		;

		##
	Return: 'return' Aritmetica ';' {result = Return_.new(val[1])}
		| 'return' LLamadaFunciones ';' {result = Return_.new(val[1])}
		| 'return' Logica ';' {result = Return_.new(val[1])}
		;

		##
	DeclaracionFunciones: PalabraFunc Variables '(' Argumento ')' 'begin' Instrucciones 'end' ';' {result = Funcion_.new(val[0],val[1],val[3],val[6])}
		| PalabraFunc Variables '(' ')' 'begin' Instrucciones 'end' ';' {result = Funcion_.new(val[0,val[1],nil,val[5]])}
		| PalabraFunc Variables '(' Argumento ')' '->' TipoDeDato 'begin' Instrucciones Return 'end' ';' {result = Funcion_R.new(val[0],val[1],val[3],val[6],val[8],val[9])}
		| PalabraFunc Variables '(' ')' '->' TipoDeDato 'begin' Instrucciones Return 'end' ';' {result = Funcion_R.new(val[0],val[1],nil,val[5],val[7],val[8])}
		;

	BloqueDo: 'do' Instrucciones 'end' {result = val[1]}
		;

	Numero: 'numero' {result = Num.new(val[0])}
		;

	BloqueW: 'with' Declaraciones BloqueDo {result = Bloque.new(val[1],val[2],'aa')}
		| 'if' Logica 'then' Instrucciones 'end' {result = Condicional.new(val[1],nil,val[3])}
		| 'if' Logica 'then' Instrucciones 'else' Instrucciones 'end' {result = Condicional.new(val[1],val[3],val[5])}
		| 'while' Logica BloqueDo {result = IteracionIndeterminada.new(val[1],val[2])}
		| 'for' Variables 'from' Numero 'to' Numero BloqueDo {result = IteracionDeterminada.new(val[1],val[3],val[5],nil,val[6])}
		| 'for' Variables 'from' Numero 'to' Numero Incremento BloqueDo {result= IteracionDeterminada.new(val[1],val[3],val[5],val[6],val[7])}
		| 'repeat' Numero 'times' Instrucciones 'end' {result = IteracionDeterminadaRepeat.new(nil,nil,val[1],nil,val[3])}
		| 'repeat' Variables 'times' Instrucciones 'end' {result = IteracionDeterminadaRepeat.new(nil,nil,val[1],nil,val[3])}
		;

	Incremento: 'by' Numero {result= val[1]}
		| 'by' Variables {result= val[1]}
		;

	Entrada: 'read' Variables {result = Entrada.new(val[1])}
		;

	CadenaCarac: 'string' {result = String_.new(val[0])}
		;

	ElemSalida: CadenaCarac {result = val[0]}
		| Logica {result = val[0]}
		| Aritmetica {result = val[0]}
		| LLamadaFunciones {result = val[0]}
		| Variables {result = val[0]}
		;

	BloqSalida: ElemSalida {result = val[0]}
		| ElemSalida ',' BloqSalida {result = EnSerie.new(val[0],val[2])}
		;

	Salida: 'write' BloqSalida {result = Salida_.new(val[1])}
		| 'writeln' BloqSalida {result = Salida_S.new(val[1])}
		;

		##
	Program: 'program' Instrucciones 'end' ';' {result = Programa.new(val[1])}
		| 'program' 'end' ';' {result = Programa.new(nil)}
		;

		##
	Retina:  DeclaracionFunciones Program {result = FinalRetina.new(val[0],val[1])}
		| DeclaracionFunciones {result = FinalRetina.new(val[0],nil)}
		| Program {result = FinalRetina.new(val[0],nil,'')}
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
