require_relative "errors.rb"

# Super Clase
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

# Operadores En Serie
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

  def check table
    @arg0.check table
    @arg1.check table
  end
end


# Estructuras de atributo unico
class Singleton < AST
    attr_accessor :operand

    def initialize operand
        @operand = operand
    end

    def print_ast indent=""
        attrs.each do |a|
        a.print_ast indent if a.respond_to? :print_ast
        end
    end
end

# Numeros
class Numero_ < AST
    attr_accessor :digit

    def initialize d
        @digit = d.token
    end

    def print_ast indent=""
        puts "#{indent}Literal Numerico:"
        puts "#{indent + '  '}valor: #{@digit}"
    end
end

# Booleanos
class Bools_ < AST
    attr_accessor :digit

    def initialize d
        @digit = d.token
    end

    def print_ast indent=""
        puts "#{indent}Literal Booleano:"
        puts "#{indent + '  '}valor: #{@digit}"
    end
end

class True_ < Bools_;end
class False_ < Bools_;end

# Variables
class Variables_ < AST
  attr_accessor :digit

  def initialize d
      @digit = d.token
  end

  def print_ast indent=""
      puts "#{indent}Identificador:"
      puts "#{indent+'  '}nombre: #{@digit}"
  end

  def check table
    return table.find @digit
  end
end

# Strings
class String_< AST
  attr_accessor :val

  def initialize val
    @val = val
  end

  def print_ast indent=""
      puts "#{indent}Cadena Caracteres:"
      puts "#{indent+ '  '}valor: #{@val.token}"
  end
end

# Tipos de Datos
class TipoDato_ < AST
  attr_accessor :digit

  def initialize d
      @digit = d.token
  end

  def print_ast indent=""
    puts "#{indent}Tipo:"
    puts "#{indent + '  '}nombre: #{@digit}"
  end
end

class Number_ < TipoDato_; end
class Boolean_ < TipoDato_; end

# Operadores Unarios
class UnaryOP < AST
    attr_accessor :operand

    def initialize operand
        @operand = operand
    end

    def print_ast indent=""
        puts "#{indent}Operador Unario: #{@digit}"
        attrs.each do |a|
        a.print_ast indent + "  " if a.respond_to? :print_ast
        end
    end

end

class UnaryMenos < UnaryOP
  def print_ast indent=""
      puts "#{indent}Menos Unario:"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end

  def check table
    #AARREEGLARRRR
    return ['number',"-#{@operand.digit}"]
  end
end

class UnaryNot < UnaryOP
  def print_ast indent=""
    puts "#{indent}Not:"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end

  def check table
    return ['boolean',"not #{@operand.digit}"]
  end

end

# Operadores Binarios
class BinaryOP < AST
    attr_accessor :left, :right

    def initialize lh, rh, name
        @left = lh
        @right = rh
        @name = name
    end

    def print_ast indent=""
        puts "#{indent}#{@name}"
        puts "#{indent+'  '}lado izquierdo:"
        @left.print_ast indent + '    '
        puts "#{indent+'  '}lado derecho:"
        @right.print_ast indent + '    '
    end
end

class OpAritmetico_ < BinaryOP

  def check table
    if @left.class == UnaryMenos
      puts 'caso1'
      x = @left.check table
      ##AARRREEEGLAARRR
      if []
    end

    if @left.class < OpAritmetico_
      @left.check table
      @right.check table
    end

    if @left.class == Variables_
      if table.exist @left.digit
        puts @left.exist(@left.digit)
        if @left.check(table) != 'number'
          raise ErrorDeTipo.new @left.digit,@left.check(table),'number'
        end
      else
        raise VariableNoDeclarada.new @left.digit
      end
    end

  end
end

class OpSuma < OpAritmetico_;end
class OpResta < OpAritmetico_;end
class OpMultiplication < OpAritmetico_;end
class OpDivision < OpAritmetico_;end
class OpDiv < OpAritmetico_;end
class OpModulo < OpAritmetico_;end
class OpMod < OpAritmetico_;end
class OpMayor < OpAritmetico_;end
class OpMenor < OpAritmetico_;end
class OpMayorIgual < OpAritmetico_;end
class OpMenorIgual < OpAritmetico_;end

class OpIgual < BinaryOP;end
class OpDistinto < BinaryOP;end

class OpAnd < BinaryOP;end
class OpOr < BinaryOP;end

class OpAsignacion < BinaryOP

  def check table
    if  !table.exist @left.digit
      raise VariableNoDeclarada.new @left.digit
    end

    esp = table.find @left.digit

    if @right.class < UnaryOP
      puts 'caso 1'
      x = @right.check table
      act = x[0]
      tok = x[1]

    elsif @right.class == Variables_
      tok = @right.digit
      if table.exist @right.digit
        act = table.find tok
      else
        raise VariableNoDeclarada.new @right.digit
      end


    elsif @right.class < Bools_ or @right.class == Numero_
      puts 'caso 2'
      tok = @right.digit
      if @right.class == Numero_
        act = 'number'
      else
        act = 'boolean'
      end

    else
      puts 'caso 3'
      puts '..'
      @right.check table
      puts '//'

    end

    unless esp == act
      raise ErrorDeTipo.new tok, act, esp
    end

  end

end

# Declaraciones
class Declaracion_ < AST

  attr_accessor :tipo, :ident

  def initialize t,i
    @tipo = t
    @ident = i
  end

   def print_ast indent=""
      puts "#{indent}Declaracion:"
      puts "#{indent + '  '}tipo:"
      @tipo.print_ast indent + '    '
      puts "#{indent + '  '}identificadores:"
      @ident.print_ast indent + '    '
  end

  def check table
    table.insert @ident.digit, @tipo.digit
    #puts table.attrs
    return table
  end
end

# Palabras Reservadas
class Palabra_ < AST

  attr_accessor :digit

  def initialize d
      @nombre = d.token
  end

  def print_ast indent=""
      puts "#{indent}Palabra Reservada:"
      puts "#{indent + '  '}nombre: #{@nombre}"
  end
end

# Funciones
class LlamadaFunciones_ < AST
  attr_accessor :name, :args

  def initialize name,arg
    @name=name
    @args=arg
  end

  def print_ast indent=""
      puts "#{indent}Llamada a funcion:"
      puts "#{indent + '  '}identificador:"
      @name.print_ast indent + '    '
      puts "#{indent + '  '}argumentos:" if @args.respond_to? :print_ast
      @args.print_ast indent + '    ' if @args.respond_to? :print_ast
  end
end

# Return
class Return_ < Singleton

  def print_ast indent=""
      puts "#{indent}Return:"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end

end

# Entrada
class Entrada < Singleton

  def print_ast indent=""
      puts "#{indent}Entrada:"

      attrs.each do |a|
          a.print_ast indent + "  " if a.respond_to? :print_ast
      end
  end
end

# Salida
class Salida_ < Singleton

  def print_ast indent=""
      puts "#{indent}Salida:"
      puts "#{indent + '  '}expresiones:"
      attrs.each do |a|
          a.print_ast indent + "    " if a.respond_to? :print_ast
      end
  end
end

class Salida_S < UnaryOP
  def print_ast indent=""
      puts "#{indent}Salida con Salto:"
      puts "#{indent + '  '}expresiones:"
      attrs.each do |a|
          a.print_ast indent + "    " if a.respond_to? :print_ast
      end
  end
end

# Bloques de instrucciones
class Bloque < AST
  attr_accessor :dec, :ins

  def initialize d, i
    @dec = d
    @ins = i
  end

  def print_ast indent=""
      puts "#{indent}Bloque:"
      puts "#{indent + '  '}declaraciones:"
      @dec.print_ast indent + '    ' if @dec.respond_to? :print_ast
      puts "#{indent + '  '}instrucciones:"
      @ins.print_ast indent + '    ' if @ins.respond_to? :print_ast
  end
end

# Estructuras de Control
class Condicional < AST

  attr_accessor :cond0, :cond1, :bloq

  def initialize a, b, c
    @cond0 = a
    @cond1 = b
    @bloq = c
  end
  def print_ast indent=""
      puts "#{indent}Condicional:"
      puts "#{indent + '  '}if:"
      @cond0.print_ast indent + '    '
      puts "#{indent + '  '}else:" if @cond1.respond_to? :print_ast
      @cond1.print_ast indent + '    ' if @cond1.respond_to? :print_ast
      puts "#{indent + '  '}instrucciones:"
      @bloq.print_ast indent + '    '
  end
end

class IteracionIndeterminada < AST
  attr_accessor :exp,:bloque

  def initialize e, b
      @exp = e
      @bloque = b
  end

  def print_ast indent=""
    puts "#{indent}Iteracion Indeterminada: "
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
    puts "#{indent}Iteracion Determinada: "
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
    puts "#{indent}Iteracion Determinada: "
    puts "#{indent + '  '}repeat:"
    @bloque.print_ast indent + '    '
    puts "#{indent + '  '}times:"
    @hasta.print_ast indent + '    '
  end
end

# Declaracion de Funciones
class Funcion_ < AST
  attr_accessor :funcion, :args, :inst, :ret

  def initialize f, a, r, i
      @funcion = f
      @args = a
      @ret = r
      @inst = i
  end

  def print_ast indent=""
      puts "#{indent}Declaracion de funcion:"
      puts "#{indent + '  '}identificador:"
      @funcion.print_ast indent + '    '
      puts "#{indent + '  '}argumentos:" if @args.respond_to? :print_ast
      @args.print_ast indent + '    ' if @args.respond_to? :print_ast
      puts "#{indent + '  '}retorna:" if @ret.respond_to? :print_ast
      @ret.print_ast indent + '    ' if @ret.respond_to? :print_ast
      puts "#{indent + '  '}instrucciones:"
      @inst.print_ast indent + '    '
  end

  def check table
    t = TablasDeAlcance.new table
    #puts t.attrs
    if @ret
      if @ret.class == Bools_
        t.tabla['ret'] = 'boolean'
      else
        t.tabla['ret'] = 'number'
      end
    else
      t.tabla['ret']=false
    end
    table.insert @funcion.digit, @args.check(t)

    @inst.check t
  end

end

# Programa
class Retina_ < AST
  attr_accessor :dec, :inst

  def initialize d, i
    @dec = d
    @inst = i
  end

  def print_ast indent=""
      puts "declaraciones:" if @dec.respond_to? :print_ast
      @dec.print_ast indent + '  ' if @dec.respond_to? :print_ast
      puts "instrucciones:" if @inst.respond_to? :print_ast
      @inst.print_ast indent + '  ' if @inst.respond_to? :print_ast
  end

  def check
    table = TablasDeAlcance.new nil
    @dec.check table
    #table.insert 'declaraciones', @dec.check table if @dec.respond_to? :check
    #table.insert 'instrucciones', @inst.check table if @inst.respond_to? :check
    return table
  end

end

class TablasDeAlcance
  attr_accessor :tabla, :padre

  def initialize padre
    @tabla = Hash.new
    @padre = padre
  end

  def insert name, value
    @tabla[name] = value
  end

  def attrs
      instance_variables.map do |a|
          instance_variable_get a
      end
  end

  def exist value
    return true if @tabla[value]
    if @padre
      #puts "#{self.attrs} tengo papa #{@padre.attrs}"
      return @padre.exist value
    end
    return false
  end

  def find value
    return @tabla[value] if @tabla[value]
    if @padre
      return @padre.find value
    end
    return nil
  end
  # def insertSub name, value
  #   @sub[name] = value
  # end

end
