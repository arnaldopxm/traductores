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
  Booleano: /\A(true|false)\b/,
  Numero: /\A\d+\.*\d+\b/,
  OpLogico: /\A(and|or|not)\b/,
  OpComparacion: /\A(==|\/=|>=|<=|>|<)/,
  OpAritmetico: /(\A(-|\*|\/|%|\+))|(\A(div|mod)\b)/,
  PalabraReserv: /\A(program|read|write|writeln|if|then|end|while|do|repeat|times|func|begin|return|for|from|to|by|is)\b/,
  TipoDato: /\A(number|boolean)\b/,
  Identificador: /\A(home|openeye|closeeye|forward|backward|rotatel|rotater|setposition|arc|[a-z]\w*)\b/,
  Signo: /\A("|"|;|=|\\|#|->)/
}

class Lexer
  attr_reader :file, :tokens

  def initialize input
    @file = input
    @tokens = []
    @numL = 0
    @numC = 1
  end


  def leerPorLinea

    return if @file.empty?
    claseInst = CaractInesperado

    @file.each_line do |line|
      #puts line
      @numL+=1
      @numC = 1;
      while line !~ /^$/ or line.nil?
        #puts "b"

        if line =~ /\A\s+/
          #puts line+" 1"
          #puts "..#{$&}.."
          @numC+=$&.length
          #puts @numC
          line = line[$&.to_s.length..line.length-1]
          #puts line+" 2"
        end

        $diccionario.each do |clase,regex|

          $centinela = false
          claseInst = CaractInesperado



          if line =~ regex
            claseInst = Object::const_get(clase)
            #puts "#{$&} #{claseInst}"
            centinela = true
            break
          end
        end

        if $centinela or claseInst.eql? CaractInesperado
          #revisar regex
          if line =~ /\A({|}|:)|[A-Z]\w*/
            #puts "f"
            raise CaractInesperado.new($&,@numL,@numC)
          end
        end

        @tokens << claseInst.new($&,@numL,@numC)

        #puts ".#{$&}."
        l = $&.to_s.length
        @numC += l
        line = line[l..line.length-1]
        #puts line + " 3"

        if line =~ /\A\s+/
          #puts line+" 1"
          #puts "..#{$&}.."
          @numC+=$&.length
          #puts @numC
          line = line[$&.to_s.length..line.length-1]
          #puts line+" 2"
        end

        #line = line[$&.length..line.length-1]
      end

    end
    return @tokens
  end


end
