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

class Number < AST
    attr_accessor :digit

    def initialize d 
        @digit = d
    end

    def print_ast indent=""
        puts "#{indent}#{self.class}: #{@digit.to_i}"
    end
end

class UnaryOP < AST
    attr_accessor :operand

    def initialize operand
        @operand = operand
    end
end

class BinaryOP < AST
    attr_accessor :left, :right

    def initialize lh, rh
        @left = lh
        @right = rh
    end
end

class Bloque < AST
	attr_accessor :Declaracion, :Instruccion

class Declaracion < AST
	attr_accessor :tipo, :variable

class UnaryMenos < UnaryOP;end
class UnaryNot < UnaryOP; end
class OpSuma < BinaryOP;end
class OpResta < BinaryOP;end
class OpMultiplication < BinaryOP;end
class OpDivision < BinaryOP;end
class OpDiv < BinaryOP;end
class OpModulo < BinaryOP;end
class OpMod < BinaryOP;end

class OpAsignacion < BinaryOp;end

class OpAnd < BinaryOp;end
class OpOr < BinaryOp;end
class OpIgual < BinaryOp;end
class OpDistinto < BinaryOp;end
class OpMayor < BinaryOp;end
class OpMenor < BinaryOp;end
class OpMayorIgual < BinaryOp;end
class OpMenorIgual < BinaryOp;end
