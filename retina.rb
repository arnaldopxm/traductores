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
  # ",;,=,\,#,->,
  def to_s
    "line #{lin}, columna #{col}: signo '#{token}'"
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

$diccionario = {
  Booleano: /\A(true|false)\z/,
  Numero: /\A\d+\.*\d+\z/,
  OpLogico: /\A(and|or|not)\z/,
  OpComparacion: 
}
