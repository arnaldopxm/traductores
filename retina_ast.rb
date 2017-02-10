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
        puts "#{indent}Literal Numerico: #{@digit}"
    end
end

class Bools < AST
    attr_accessor :digit

    def initialize d
        @digit = d.token
    end

    def print_ast indent=""
        puts "#{indent}#{self.class}: #{@digit}"
    end
end

class True_ < Bools;end
class False_ < Bools;end

class BinaryOP < AST
    attr_accessor :left, :right

    def initialize lh, rh
        @left = lh
        @right = rh
    end

    def print_ast indent=""
        puts "#{indent} Operador Binario:"

        attrs.each do |a|
        a.print_ast indent + "  " if a.respond_to? :print_ast
        end
    end
end

class ThreeOP < AST
    attr_accessor :left, :right, :c

    def initialize lh, rh, c
        @left = lh
        @right = rh
        @c = c
    end

    def print_ast indent=""
        puts "#{indent} Operador Ternario: #{@digit}"

        attrs.each do |a|
        a.print_ast indent + "  " if a.respond_to? :print_ast
        end
    end

end

class Identificado < AST
  attr_accessor :digit

  def initialize d
      @digit = d.token
  end

  def print_ast indent=""
      puts "#{indent}Identificador: #{@digit}"
  end
end

class TipoDato_ < AST
  attr_accessor :digit

  def initialize d
      @digit = d.token
  end

    def print_ast indent=""
      puts "#{indent} Tipo de Dato: #{@digit}"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end

end

class Funcion_ < AST
  attr_accessor :funcion, :args, :inst, :w

  def initialize f, a, i, w
      @funcion = f
      @args = a
      @inst = i
      @w = w

  end

end

class Funcion_R < AST
  attr_accessor :funcion, :var, :arg, :td, :ret, :ins

  def initialize f, v, a, i, r, w
      @funcion = f
      @var = v
      @arg = a
      @td = i
      @ret = r
      @ins = w

  end

end

class NoIndent
  def print_ast indent=""

      attrs.each do |a|
          a.print_ast indent + "" if a.respond_to? :print_ast
      end
  end

  def attrs
      instance_variables.map do |a|
          instance_variable_get a
      end
  end
end

class DosAttr < NoIndent
  attr_accessor :funcion, :var

  def initialize f, v
      @funcion = f
      @var = v

  end

end

class Nueva<DosAttr;end

class Funciones_ < AST
  attr_accessor :name,:arg1, :arg2

  def initialize name,arg1,arg2
    @arg0=name
    @arg1=arg1
    @arg2=arg2
  end

  def print_ast indent=""
      puts "#{indent} Llamada a funcion:"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end

end

class Number_ < TipoDato_; end
class Boolean_ < TipoDato_; end
class LlamadaFuncion < Funciones_; end
class FuncionArg < Funciones_; end

class UnaryMenos < UnaryOP
  def print_ast indent=""
      puts "#{indent} Operador Binario: - "

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class UnaryNot < UnaryOP
    def print_ast indent=""
      puts "#{indent} Operador Unario: not "

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class OpSuma < BinaryOP
  def print_ast indent=""
      puts "#{indent} Operador Binario: + "

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class OpResta < BinaryOP
  def print_ast indent=""
      puts "#{indent} Operador Binario: - "

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class OpMultiplication < BinaryOP
    def print_ast indent=""
      puts "#{indent} Operador Binario: * "

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class OpDivision < BinaryOP
    def print_ast indent=""
      puts "#{indent} Operador Binario: / "

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class OpDiv < BinaryOP
  def print_ast indent=""
      puts "#{indent} Operador Binario: div"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class OpModulo < BinaryOP
  def print_ast indent=""
      puts "#{indent} Operador Binario: mod "

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class OpMod < BinaryOP
    def print_ast indent=""
      puts "#{indent} Operador Binario: mod "

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class OpIgual < BinaryOP
    def print_ast indent=""
      puts "#{indent} Operador Binario: == "

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end


class OpDistinto < BinaryOP
    def print_ast indent=""
      puts "#{indent} Operador Binario: distinto"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class OpMayor < BinaryOP
    def print_ast indent=""
      puts "#{indent} Operador Binario: > "

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end


class OpMenor < BinaryOP
    def print_ast indent=""
      puts "#{indent} Operador Binario: < "

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end


class OpMayorIgual < BinaryOP
    def print_ast indent=""
      puts "#{indent} Operador Binario: >= "

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class OpMenorIgual < BinaryOP
    def print_ast indent=""
      puts "#{indent} Operador Binario: <= "

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end


class OpAnd < BinaryOP

  def print_ast indent=""
      puts "#{indent} Operador Binario: And"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end



class OpOr < BinaryOP
  def print_ast indent=""
      puts "#{indent} Operador Binario: or"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class OpDeclaracion < BinaryOP
   
   def print_ast indent=""
      puts "#{indent} Declaracion: #{@digit}"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class OpAsignacion < BinaryOP

  def print_ast indent=""
      puts "#{indent} Asignacion: ="

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end

end

class Palabra < TipoDato_

  def print_ast indent=""
      puts "#{indent} Palabra Reservada: #{@digit}"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
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
      puts "#{indent} Return"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end

end

class Bloque < BinaryOP

  def print_ast indent=""
      puts "#{indent} Bloque:"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class Condicional < ThreeOP 

  def print_ast indent=""
      puts "#{indent} Condicional:"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end

end

class BloqFrom < BinaryOP

def print_ast indent=""
      puts "#{indent} Bloque From: "

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class Iteracion < Funcion_; end
class Entrada < UnaryOP
  def print_ast indent=""
      puts "#{indent} Entrada "

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end
class String_<UnaryOP; end
class Salida_ <BinaryOP; end

class Programa < UnaryOP
  def print_ast indent=""
      puts "#{indent} Program:"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

class FinalRetina < BinaryOP

  def print_ast indent=""
      puts "#{indent} Retina:"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end

end
