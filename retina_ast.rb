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
end

class Num < AST
    attr_accessor :digit

    def initialize d
        @digit = d.token
    end

    def print_ast indent=""
        puts "#{indent}#{self.class}: #{@digit}"
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
end

class Identificado < AST
  attr_accessor :digit

  def initialize d
      @digit = d.token
  end

  def print_ast indent=""
      puts "#{indent}#{self.class}: #{@digit}"
  end
end

class Bloque < AST
	attr_accessor :Declaracion, :Instruccion
end

class Declaracion < AST
	attr_accessor :tipo, :variable
  def initialize t, v
      @tipo = t.digit
      @variable = v.digit
  end

end

class TipoDato_ < AST
  attr_accessor :digit

  def initialize d
      @digit = d.token
  end

  def print_ast indent=""
      puts "#{indent}#{self.class}: #{@digit}"
  end
end

class Number_ < TipoDato_; end
class Boolean_ < TipoDato_; end

class UnaryMenos < UnaryOP;end
class UnaryNot < UnaryOP; end
class OpSuma < BinaryOP;end
class OpResta < BinaryOP;end
class OpMultiplication < BinaryOP;end
class OpDivision < BinaryOP;end
class OpDiv < BinaryOP;end
class OpModulo < BinaryOP;end
class OpMod < BinaryOP;end
class OpIgual < BinaryOP; end
class OpDistinto < BinaryOP;end
class OpMayor < BinaryOP;end
class OpMenor < BinaryOP;end
class OpMayorIgual < BinaryOP;end
class OpMenorIgual < BinaryOP;end
class OpAnd < BinaryOP; end
class OpOr < BinaryOP; end
=begin
class OpAsignacion < BinaryOp; end


=end
