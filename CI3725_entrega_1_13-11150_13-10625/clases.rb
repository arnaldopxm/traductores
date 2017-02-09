class Token
  attr_reader :token, :lin, :col

  def initialize text, lin, col
    @token = text
    @lin = lin
    @col = col
  end
end

class Booleano < Token
  #true y false,
  def to_s
    "line #{lin}, columna #{col}: literal booleano '#{token}'"
  end
end

class Numero < Token
  #/\d*\.*\d+/
  def to_s
    "line #{lin}, columna #{col}: literal numerico '#{token}'"
  end
end

class OpLogico < Token
  #and, or, not
  def to_s
    "line #{lin}, columna #{col}: operador logico '#{token}'"
  end
end

class OpComparacion < Token
  #==, /=, >=, <=, >, <
  def to_s
    "line #{lin}, columna #{col}: operador de comparacion '#{token}'"
  end
end

class OpAritmetico < Token
  #-, *, /, %, div, mod, +
  def to_s
    "line #{lin}, columna #{col}: operador aritmetico '#{token}'"
  end
end

class PalabraReserv < Token
  #program, read, write, writeln, if, then, end, while, do
  #repeat, times, func, begin, return, for, from, to, by, is
  def to_s
    "line #{lin}, columna #{col}: palabra reservada '#{token}'"
  end
end

class TipoDato < Token
  # number, boolean
  def to_s
    "line #{lin}, columna #{col}: tipo de dato '#{token}'"
  end
end

class Identificador < Token
  # home, openeye, closeeye, forward, backward, rotatel,
  # rotater, setposition, arc
  # [a-z]\w*
  def to_s
    "line #{lin}, columna #{col}: identificador '#{token}'"
  end
end

class Signo < Token
  # ",;,=,\,->,(,)
  def to_s
    "line #{lin}, columna #{col}: signo '#{token}'"
  end
end

class Strings < Token
  def to_s
    "line #{lin}, columna #{col}: string '#{token}'"
  end
end

class CaractInesperado < RuntimeError
  #{,},:
  def initialize carac, lin, col
    @carac = carac
    @lin = lin
    @col = col
  end

  def to_s
    "linea #{@lin}, columna #{@col}: caracter inesperado '#{@carac}'"
  end
end

class True < Booleano; end
class False < Booleano; end
class And < OpLogico; end
class Or < OpLogico; end
class Not < OpLogico; end
class Igual  < OpComparacion; end
class Distinto  < OpComparacion; end
class MayorIgual  < OpComparacion; end
class MenorIgual  < OpComparacion; end
class Mayor  < OpComparacion; end
class Menor  < OpComparacion; end
class Separador  < Signo; end
class Asignacion  < Signo; end
class BackSlash  < Signo; end
class ParentesisA  < Signo; end
class ParentesisC  < Signo; end
class Flecha  < Signo; end
class Coma  < Signo; end
class Menos < OpAritmetico; end
class Por < OpAritmetico; end
class Entre < OpAritmetico; end
class Porcentaje < OpAritmetico; end
class Mas < OpAritmetico; end
class Div < OpAritmetico; end
class Mod < OpAritmetico; end
class Program < PalabraReserv; end
class Read < PalabraReserv; end
class Write < PalabraReserv; end
class Writeln < PalabraReserv; end
class If < PalabraReserv; end
class Then < PalabraReserv; end
class End < PalabraReserv; end
class While < PalabraReserv; end
class Do < PalabraReserv; end
class Repeat < PalabraReserv; end
class Times < PalabraReserv; end
class Func < PalabraReserv; end
class Begin < PalabraReserv; end
class Return < PalabraReserv; end
class For < PalabraReserv; end
class From < PalabraReserv; end
class To < PalabraReserv; end
class By < PalabraReserv; end
class Is < PalabraReserv; end
class Number < TipoDato; end
class Boolean < TipoDato; end
class Home < Identificador; end
class OpenEye < Identificador; end
class CloseEye < Identificador; end
class Forward < Identificador; end
class Backward < Identificador; end
class RotateL < Identificador; end
class RotateR < Identificador; end
class SetPosition < Identificador; end
class Arc < Identificador; end
class Variables < Identificador; end
