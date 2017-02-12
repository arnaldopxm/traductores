class AST
    def print_ast indent=""
        puts "#{indent}#{self.class}:"

        attrs.each do |a|
            a.print_ast indent + "  " if a.respond_to? :print_ast
        end
    end

    def attrs
        instance_variables.map do |a|
            instance_variable_get a
        end
    end
end

class UnaryOP < AST
    attr_accessor :operand

    def initialize operand
        @operand = operand
    end

    def print_ast indent=""
        puts "#{indent} Operador Unario: #{@digit}"
        attrs.each do |a|
        a.print_ast indent + "  " if a.respond_to? :print_ast
        end
    end
end

class Num < AST
    attr_accessor :digit

    def initialize d
        @digit = d.token
    end

    def print_ast indent=""
        puts "#{indent}Literal Numerico:"
        puts "#{indent + '  '}valor: #{@digit}"
    end
end

class Bools < AST
    attr_accessor :digit

    def initialize d
        @digit = d.token
    end

    def print_ast indent=""
        puts "#{indent}Literal Booleano:"
        puts "#{indent + '  '}valor: #{@digit}"
    end
end

class True_ < Bools;end
class False_ < Bools;end

class BinaryOP < AST
    attr_accessor :left, :right

    def initialize lh, rh, name
        @left = lh
        @right = rh
        @name = name
    end

    def print_ast indent=""
        puts "#{indent} #{@name}"
        puts "#{indent+'  '}lado izquierdo:"
        @left.print_ast indent + '    '
        puts "#{indent+'  '}lado derecho:"
        @right.print_ast indent + '    '
    end
end

class Identificado < AST
  attr_accessor :digit

  def initialize d
      @digit = d.token
  end

  def print_ast indent=""
      puts "#{indent}Identificador:"
      puts "#{indent+'  '}nombre: #{@digit}"
  end
end

class TipoDato_ < AST
  attr_accessor :digit

  def initialize d
      @digit = d.token
  end

  def print_ast indent=""
    puts "#{indent} Tipo:"
    puts "#{indent + '  '}nombre: #{@digit}"
  end
end

class Funcion_ < AST
  attr_accessor :funcion, :args, :inst, :ret

  def initialize f, a, r, i
      @funcion = f
      @args = a
      @ret = r
      @inst = i
  end

  def print_ast indent=""
      puts "#{indent} Declaracion de funcion:"
      puts "#{indent + '  '}identificador:"
      @funcion.print_ast indent + '    '
      puts "#{indent + '  '}argumentos:" if @args.respond_to? :print_ast
      @args.print_ast indent + '    ' if @args.respond_to? :print_ast
      puts "#{indent + '  '}retorna:" if @ret.respond_to? :print_ast
      @ret.print_ast indent + '    ' if @ret.respond_to? :print_ast
      puts "#{indent + '  '}instrucciones:"
      @inst.print_ast indent + '    '

  end

end

class Funciones_ < AST
  attr_accessor :name,:arg1, :arg2

  def initialize name,arg1,arg2
    @arg0=name
    @arg1=arg1
    @arg2=arg2
  end

  def print_ast indent=""
      puts "#{indent} Llamada a funcion:"
      puts "#{indent + '  '}identificador:" if @arg0.respond_to? :print_ast
      @arg0.print_ast indent + '    ' if @arg0.respond_to? :print_ast
      puts "#{indent + '  '}argumentos:" if @arg1.respond_to? :print_ast
      @arg1.print_ast indent + '    ' if @arg1.respond_to? :print_ast
      @arg2.print_ast indent + '    ' if @arg2.respond_to? :print_ast
  end
end

class Number_ < TipoDato_; end
class Boolean_ < TipoDato_; end

class UnaryMenos < UnaryOP
  def print_ast indent=""
      puts "#{indent} Menos Unario:"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class UnaryNot < UnaryOP
    def print_ast indent=""
      puts "#{indent} Not:"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class OpSuma < BinaryOP;end
class OpResta < BinaryOP;end
class OpMultiplication < BinaryOP;end
class OpDivision < BinaryOP;end
class OpDiv < BinaryOP;end
class OpModulo < BinaryOP;end
class OpMod < BinaryOP;end
class OpIgual < BinaryOP;end
class OpDistinto < BinaryOP;end
class OpMayor < BinaryOP;end
class OpMenor < BinaryOP;end
class OpMayorIgual < BinaryOP;end
class OpMenorIgual < BinaryOP;end
class OpAnd < BinaryOP;end
class OpOr < BinaryOP;end

class EnSerie < AST
  attr_accessor :arg0, :arg1

  def initialize arg0, arg1
    @arg0 = arg0
    @arg1 = arg1
  end

  def print_ast indent=""
    attrs.each do |a|
        a.print_ast indent if a.respond_to? :print_ast
    end
  end
end

class OpDeclaracion < BinaryOP

   def print_ast indent=""
      puts "#{indent} Declaracion: #{@digit}"

      puts "#{indent + '  '}tipo:"
      @left.print_ast indent + '    '
      puts "#{indent + '  '}identificadores:"
      @right.print_ast indent + '    '
  end
end

class OpAsignacion < BinaryOP;end

class Palabra < TipoDato_

  def print_ast indent=""
      puts "#{indent} Palabra Reservada:"
      puts "#{indent + '  '}nombre: #{@digit}"
  end
end

class Argumento < UnaryOP

  def print_ast indent=""
      puts "#{indent} Argumento: "

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class Instruccion_ < BinaryOP
      def print_ast indent=""
      puts "#{indent} Instruccion: #{@digit}"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class Return_ < UnaryOP

  def print_ast indent=""
      puts "#{indent} Return:"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end

end

class Bloque < AST
  attr_accessor :dec, :ins

  def initialize d, i
    @dec = d
    @ins = i
  end

  def print_ast indent=""
      puts "#{indent} Bloque:"
      puts "#{indent + '  '}declaraciones:"
      @dec.print_ast indent + '    ' if @dec.respond_to? :print_ast
      puts "#{indent + '  '}instrucciones:"
      @ins.print_ast indent + '    ' if @ins.respond_to? :print_ast
  end
end

class Condicional < AST

  attr_accessor :cond0, :cond1, :bloq

  def initialize a, b, c
    @cond0 = a
    @cond1 = b
    @bloq = c
  end
  def print_ast indent=""
      puts "#{indent} Condicional:"
      puts "#{indent + '  '}if:"
      @cond0.print_ast indent + '      '
      puts "#{indent + '  '}else:" if @cond1.respond_to? :print_ast
      @cond1.print_ast indent + '      ' if @cond1.respond_to? :print_ast
      puts "#{indent + '  '}instrucciones:"
      @bloq.print_ast indent + '      '
  end
end

class IteracionIndeterminada < AST
  attr_accessor :exp,:bloque

  def initialize e, b
      @exp = e
      @bloque = b
  end

  def print_ast indent=""
    puts "#{indent} Iteracion Indeterminada: "
    puts "#{indent + '  '}mientras:"
    @exp.print_ast indent + '    '
    puts "#{indent + '  '}instrucciones:"
    @bloque.print_ast indent + '    '
  end
end



class IteracionDeterminada < AST
  attr_accessor :var, :desde, :hasta, :incremento ,:bloque

  def initialize v, d, h, i, b
      @var = v
      @desde = d
      @hasta = h
      @incremento = i
      @bloque = b
  end

  def print_ast indent=""
    puts "#{indent} Iteracion Determinada: "
    puts "#{indent + '  '}sobre:" if @var.respond_to? :print_ast
    @var.print_ast indent + '    ' if @var.respond_to? :print_ast
    puts "#{indent + '  '}desde:" if @desde.respond_to? :print_ast
    @desde.print_ast indent + '    ' if @desde.respond_to? :print_ast
    puts "#{indent + '  '}hasta:"
    @hasta.print_ast indent + '    '
    puts "#{indent + '  '}incremento:" if @incremento.respond_to? :print_ast
    @incremento.print_ast indent + '    ' if @incremento.respond_to? :print_ast
    puts "#{indent + '  '}instrucciones:"
    @bloque.print_ast indent + '    '
  end
end

class IteracionDeterminadaRepeat < IteracionDeterminada
  def print_ast indent=""
    puts "#{indent} Iteracion Determinada: "
    puts "#{indent + '  '}repeat:"
    @bloque.print_ast indent + '    '
    puts "#{indent + '  '}times:"
    @hasta.print_ast indent + '    '
  end
end


class Entrada < UnaryOP
  def print_ast indent=""
      puts "#{indent} Entrada:"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class String_< AST
  attr_accessor :val

  def initialize val
    @val = val
  end

  def print_ast indent=""
      puts "#{indent + '  '}String:"
      puts "#{indent+ '    '}valor: #{@val.token}"
  end
end

class Salida_ < UnaryOP
  def print_ast indent=""
      puts "#{indent} Salida:"
      puts "#{indent + '  '}expresiones:"
      attrs.each do |a|
          a.print_ast indent + "    " if a.respond_to? :print_ast
      end
  end
end

class Salida_S < UnaryOP
  def print_ast indent=""
      puts "#{indent} Salida con Salto:"
      puts "#{indent + '  '}expresiones:"
      attrs.each do |a|
          a.print_ast indent + "    " if a.respond_to? :print_ast
      end
  end
end

class Retina_ < AST
  attr_accessor :dec, :inst

  def initialize d, i
    @dec = d
    @inst = i
  end

  def print_ast indent=""
      puts "declaraciones:"
      @dec.print_ast indent if @dec.respond_to? :print_ast
      puts "instrucciones:"
      @inst.print_ast indent if @inst.respond_to? :print_ast
  end
end
