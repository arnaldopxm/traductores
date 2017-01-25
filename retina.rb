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


$diccionario = {
  Booleano: /\A(true|false)\b/,
  Numero: /\A\d+(\.\d+)*\b/,
  OpLogico: /\A(and|or|not)\b/,
  OpComparacion: /\A(==|\/=|>=|<=|>|<)/,
  Signo: /\A(;|=|\\|\(|\)|->|,)/,
  OpAritmetico: /(\A(-|\*|\/|%|\+))|(\A(div|mod)\b)/,
  PalabraReserv: /\A(program|read|write|writeln|if|then|end|while|do|repeat|times|func|begin|return|for|from|to|by|is)\b/,
  TipoDato: /\A(number|boolean)\b/,
  Identificador: /\A(home|openeye|closeeye|forward|backward|rotatel|rotater|setposition|arc|[a-z]\w*)\b/,
  Strings: /\A("(.|\s)*[^\\,\n]?")|\A"[^"]*\n/
}


class Lexer
  attr_reader :file, :tokens, :errors

  def initialize input
    @file = input
    @tokens = []
    @errors = []
    @numL = 0
    @numC = 1
  end

  #funcion procesar strings
  def procesarString val
  string = val
  for pos in 1..string.length - 2

    if string[pos,2]=~/\\\\/ or string[pos-1,2]=~/\\\\/
      next
    end

    if string[pos] =~ /\\/

      if string[pos+1] !~ /(n|")/ or pos+1 == string.length - 1
        x = string[pos,1]
        if pos+1 != string.length-1
          x = string[pos,2]
        end
        @errors << CaractInesperado.new(x,@numL,@numC+pos)
      end
    end
  end
  return string
end

  def leerPorLinea

    #retornar si el archivo es vacio
    return if @file.empty?
    claseInst = CaractInesperado

    #para cada linea del archivo
    @file.each_line do |line|
      @numL+=1
      @numC = 1;

      # si la linea es un comentario. Ignorarla
      if line =~ /\A\#/
        next
      end

      # mientras que la linea no este vacia
      while line !~ /^$/ or line.nil?

        # eliminar espacios en blanco
        if line =~ /\A\s+/
          @numC+=$&.length
          line = line[$&.to_s.length..line.length-1]
        end

        # chequear tokens
        $diccionario.each do |clase,regex|

          $centinela = false
          claseInst = CaractInesperado

          #si es comentario
          if line =~ /\A\#/
            claseInst = nil
            break
          end

          #si hace match
          if line =~ regex
            claseInst = Object::const_get(clase)
            centinela = true
            break
          end
        end

        #caso es un comentario
        if claseInst.nil?
          break
        end

        #caso es un string
        if claseInst.eql? Strings

          if line =~ /\A"[^"]*\n/

            procesarString($&[0..$&.length-2]+"\"")
            @errors << CaractInesperado.new("\\n",@numL,@numC+line.length-1)
            line = line[0,0]
            next

          else

            line =~ /\A("(.|\s)*[^\\,\n]?")/
            string = procesarString($&.to_s)
            @tokens << claseInst.new(string,@numL,@numC)
            @numC += string.length
            line  = line[string.length..line.length-1]
            next
            
          end
        end

        # caso hizo match
        if !$&.nil?
          #agregar a tokens
          @tokens << claseInst.new($&,@numL,@numC)

        #caso caracter inesperado
        else
          if line =~ /\A[A-Z]\w*\b/
            @errors << CaractInesperado.new($&,@numL,@numC)
          else
            @errors << CaractInesperado.new(line[0,1],@numL,@numC)
            @numC+=1
            line = line[1..line.length-1]
            break
          end
        end

        #sumas los espacios necesarios, y recorta la linea
        l = $&.to_s.length
        @numC += l
        line = line[l..line.length-1]

        #elimina espacios en blanco
        if line =~ /\A\s+/
          @numC+=$&.length
          line = line[$&.to_s.length..line.length-1]
        end
      end
    end

    @errors.each do |e|

    end

    return @tokens

  end
end
