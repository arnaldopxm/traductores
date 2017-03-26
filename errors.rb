=begin
Libreria que contiene los errores que se llaman en los checks del AST

Autores:
  -Arnaldo Quintero 13-11150
  -Gabriel Gutierrez 13-10625
=end

class VariableNoDeclarada < RuntimeError
  def initialize tok, lin, col
    @token = tok
    @lin = lin
    @col = col
  end

  def to_s
    "Error: variable no declarada '#{@token}'. lin: #{@lin}, col: #{@col}"
  end
end

class FuncionNoDeclarada < RuntimeError
  def initialize tok, lin, col
    @token = tok
    @lin = lin
    @col = col
  end

  def to_s
    "Error: funcion no declarada '#{@token}'. lin: #{@lin}, col: #{@col}"
  end
end

class ErrorDeTipo < RuntimeError
  def initialize tok,actual, esperado
    @token = tok
    @act = actual
    @esp = esperado
    self.Sustituir
  end

  def to_s
    "Error: '#{@token}' es una expresion de tipo '#{@act}' y se esperaba una de tipo '#{@esp}'"
  end

  def Sustituir
    if @act==OpSuma
      @act='Operacion Suma'
    elsif @act==OpResta
      @act='Operacion Resta'
    elsif @act=='OpMultiplicacion'
      @act='Operacion Multiplicacion'
    elsif @act==OpDivision
      @act='Operacion Division'
    elsif @act==OpDiv
      @act='Operacion Div'
    elsif @act==OpModulo
      @act='Operacion Modulo'
    elsif @act==OpMod
      @act='Operacion Mod'
    end

  end
end

class ErrorDeOperador < RuntimeError
  def initialize tok,actual, esperado, operador
    @token = tok
    @act = actual
    @esp = esperado
    @op = operador
  end

  def to_s
    "Error: el operador '#{@op}' utiliza tipo '#{@esp}' y '#{@token}' es de tipo '#{@act}'"
  end
end

class ErrorReturn < RuntimeError
  def initialize tipo,act,esp
    @tipo = tipo
    @act = act
    @esp = esp
  end

  def to_s
    if @tipo == 0
      "Error: instruccion 'return' inesperada"
    elsif @tipo == 1
      "Error: instruccion 'return' es de tipo '#{@act}' y deberia ser de tipo '#{@esp}'"
    else
      "Error: instruccion 'return' de tipo '#{@esp}' faltante"
    end
  end
end

class ErrorExistencia < RuntimeError
  def initialize ide
    @iden = ide
  end

  def to_s
    "Error: identificador '#{@iden}' ya existe"
  end
end

class ErrorCantArgumentos < RuntimeError
  def initialize tok, esp, act
    @tok = tok
    @esp = esp
    @act = act
  end

  def to_s
    "Error: funcion '#{@tok}', '#{@esp}' argumentos esperados, '#{@act}' recibidos"
  end
end

class ErrorDeTipoArg < ErrorDeTipo
  def to_s
    "Error: '#{@token}' contiene una expresion de tipo '#{@act}' y se esperaba una de tipo '#{@esp}'"
  end
end

class DivisionPorCero < RuntimeError
  def to_s
    "Error: Division por cero"
  end
end

class VariableNoInicializada < RuntimeError
  def to_s
    "Error: Variable no inicializada"
  end
end
