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

  Operador: 'numero'                {result = Numero_.new(val[0])}
    | 'true'                        {result = True_.new(val[0])}
    | 'false'                       {result = False_.new(val[0])}
    | Variable                      {result = val[0]}
    ;

  Variable: 'variable'              {result = Variables_.new(val[0])}
    ;

  Variables: Variable             {result = val[0]}
    | Variables ',' Variable      {result = EnSerie.new(val[0],val[2])}
    ;

  TipoDeDato: 'number'              {result = Number_.new(val[0])}
    | 'boolean'                     {result = Boolean_.new(val[0])}
    ;

  Operaciones: '(' Operaciones ')'  {result = val[1]}
    | Operador                      {result = val[0]}
    | '-' Operador = UMENOS         {result = UnaryMenos.new(val[1])}
    | 'not' Operador                {result = UnaryNot.new(val[1])}
    | Operador '+' Operador         {result = OpSuma.new(val[0],val[2],'Suma:')}
    | Operador '-' Operador         {result = OpResta.new(val[0],val[2],'Resta:')}
    | Operador '/' Operador         {result = OpDivision.new(val[0],val[2],'Division:')}
    | Operador '*' Operador         {result = OpMultiplication.new(val[0],val[2],'Multiplicacion:')}
    | Operador 'mod' Operador       {result = OpMod.new(val[0],val[2],'Modulo:')}
    | Operador 'div' Operador       {result = OpDiv.new(val[0],val[2],'Division:')}
    | Operador '%' Operador         {result = OpModulo.new(val[0],val[2],'Modulo:')}
    | Operador '>' Operador         {result = OpMayor.new(val[0],val[2],'Mayor Estricto:')}
    | Operador '<' Operador         {result = OpMenor.new(val[0],val[2],'Menor Estricto:')}
    | Operador '>=' Operador        {result = OpMayorIgual.new(val[0],val[2],'Mayor Igual:')}
    | Operador '<=' Operador        {result = OpMenorIgual.new(val[0],val[2],'Menor Igual')}
    | Operador'and' Operador        {result = OpAnd.new(val[0],val[2],'And:')}
    | Operador'or' Operador         {result = OpOr.new(val[0],val[2],'Or:')}
    | Operador'==' Operador         {result = OpIgual.new(val[0],val[2],'Equivalente:')}
    | Operador'\=' Operador         {result = OpDistinto.new(val[0],val[2],'Distinto:')}
    ;

  Declaracion: TipoDeDato Variables ';' {result = Declaracion_.new(val[0],val[1])}
    | TipoDeDato Asignacion ';'        {result = Declaracion_.new(val[0],val[1])}
    ;

  Declaraciones: Declaracion     {result = val[0]}
    | Declaracion Declaraciones {result = EnSerie.new(val[0],val[2])}
    ;

  Asignacion: Variable '=' Operaciones {result = OpAsignacion.new(val[0],val[2],'Asignacion:')}
    ;

  PalabrasReserv:'home'             {result = Palabra_.new(val[0])}
    | 'openeye'                     {result = Palabra_.new(val[0])}
    | 'closeeye'                    {result = Palabra_.new(val[0])}
    | 'forward'                     {result = Palabra_.new(val[0])}
    | 'backward'                    {result = Palabra_.new(val[0])}
    | 'rotatel'                     {result = Palabra_.new(val[0])}
    | 'rotater'                     {result = Palabra_.new(val[0])}
    | 'setposition'                 {result = Palabra_.new(val[0])}
    | 'arc'                         {result = Palabra_.new(val[0])}
    ;

  Args: Operaciones
    | Operaciones ',' Args          {result = EnSerie.new(val[0],val[2])}
    ;

  LLamadaFunciones: Variable '(' ')' {result = LlamadaFunciones_.new(val[0],nil)}
    | Variable '(' Args ')'         {result = LlamadaFunciones_.new(val[0],val[2])}
    | PalabrasReserv '(' ')'        {result = LlamadaFunciones_.new(val[0],nil)}
    | PalabrasReserv '(' Args ')'   {result = LlamadaFunciones_.new(val[0],val[2])}
    ;

  Return: 'return' Operaciones      {result = Return_.new(val[1])}
    | 'return' LLamadaFunciones     {result = Return_.new(val[1])}
    ;

  Entrada: 'read' Variable {result = Entrada.new(val[1])}
    ;

  ElemSalida: 'string'              {result = val[0]}
    | Operaciones                   {result = val[0]}
    | LLamadaFunciones              {result = val[0]}
    ;

  BloqSalida: ElemSalida            {result = val[0]}
    | ElemSalida ',' BloqSalida     {result = EnSerie.new(val[0],val[2])}
    ;

  Salida: 'write' BloqSalida        {result = Salida_.new(val[1])}
    | 'writeln' BloqSalida          {result = Salida_S.new(val[1])}
    ;

  Bloque: 'with' Declaraciones 'do' Instrucciones 'end' {result = Bloque.new(val[1],val[3])}
    | 'with' 'do' Instrucciones 'end'                   {result = Bloque.new(nil,val[2])}

  Control:
    | 'if' Operaciones 'then' Instrucciones 'end'       {result = Condicional.new(val[1],nil,val[3])}
    | 'if' Operaciones 'then' Instrucciones 'else' Instrucciones 'end' {result = Condicional.new(val[1],val[3],val[5])}
    | 'while' Operaciones 'do' Instrucciones 'end'      {result = IteracionIndeterminada.new(val[1],val[3])}
    | 'for' Operador 'from' Operaciones 'to' Operaciones 'do' Instrucciones 'end' {result = IteracionDeterminada.new(val[1],val[3],val[5],nil,val[7])}
    | 'for' Operador 'from' Operaciones 'to' Operaciones 'by' Operaciones 'do' Instrucciones 'end' {result= IteracionDeterminada.new(val[1],val[3],val[5],val[7],val[9])}
    | 'repeat' Operaciones 'times' Instrucciones 'end'  {result = IteracionDeterminadaRepeat.new(nil,nil,val[1],nil,val[3])}
    ;

  Instruccion: LLamadaFunciones     {result = val[0]}
    | Asignacion                    {result = val[0]}
    | Operaciones                   {result = val[0]}
    | Bloque                        {result = val[0]}
    | Control                       {result = val[0]}
    | Entrada                       {result = val[0]}
    | Salida                        {result = val[0]}
    | Return                        {result = val[0]}

  Instrucciones: Instruccion ';'    {result = val[0]}
    | Instruccion ';' Instrucciones {result = EnSerie.new(val[0],val[2])}
    ;

  Arg: TipoDeDato Variable {result = Declaracion_.new(val[0],val[1])}
    ;

  Argumento: Arg            {result = val[0]}
    | Argumento ',' Arg     {result = EnSerie.new(val[0],val[2])}
    ;

  DeclaracionFuncion: 'func' Variable '(' Argumento ')' 'begin' Instrucciones 'end'  {result = Funcion_.new(val[1],val[3],nil,val[6])}
    | 'func' Variable '(' ')' 'begin' Instrucciones 'end'                            {result = Funcion_.new(val[1],nil,nil,val[5])}
    | 'func' Variable '(' Argumento ')' '->' TipoDeDato 'begin' Instrucciones 'end'  {result = Funcion_.new(val[1],val[3],val[6],val[8])}
    | 'func' Variable '(' ')' '->' TipoDeDato 'begin' Instrucciones 'end'            {result = Funcion_.new(val[1],nil,val[5],val[7])}
    ;

  DeclaracionFunciones: DeclaracionFuncion ';'      {result = val[0]}
    | DeclaracionFuncion ';' DeclaracionFunciones   {result = EnSerie.new(val[0],val[1])}
    ;

  Program: 'program' Instrucciones 'end' ';'        {result = val[1]}
    | 'program' 'end' ';'                           {result = nil}
    ;

  Retina: DeclaracionFunciones Program      {result = Retina_.new(val[0],val[1])}
    | DeclaracionFunciones                  {result = Retina_.new(val[0],nil)}
    | Program                               {result = Retina_.new(nil,val[0])}
    ;


---- header
require_relative "retina.rb"
require_relative "retina_ast.rb"

class SyntacticError < RuntimeError

    def initialize(tok)
        @token = tok
    end

    def to_s
        "linea: #{@token.lin},columna: #{@token.col}: token inesperado: '#{@token.token}'"
    end
end

---- inner
begin
  attr_accessor :errors

  def initialize
    @errors = []
  end

  def on_error(id, token, stack)
      @errors << SyntacticError.new(token)
  end

  def next_token
      if !@tokens.empty?
        token = @tokens[0]
        @tokens = @tokens[1..@tokens.length]
        return [token.class,token]
      else
        return [false,false]
      end
  end

  def parse(tokens)
      @yydebug = true
      @tokens = tokens
      ast = do_parse
      return ast
  end
end
