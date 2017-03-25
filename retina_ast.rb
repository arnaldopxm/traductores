=begin
    Clases del AST de retina

Autores:
  -Arnaldo Quintero 13-11150
  -Gabriel Gutierrez 13-10625
=end

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

  def run
    @arg0.run
    @arg1.run
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

    def check table
      return ['number',@digit]
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

    def check table
      return ['boolean',@digit]
    end
end

class True_ < Bools_;end
class False_ < Bools_;end

# Variables
class Variables_ < AST
  attr_accessor :digit, :lin, :col

  def initialize d
      @digit = d.token
      @lin = d.lin
      @col = d.col
  end

  def print_ast indent=""
      puts "#{indent}Identificador:"
      puts "#{indent+'  '}nombre: #{@digit}"
  end

  def check table
    if table.exist @digit
      return table.find @digit
    else
      raise VariableNoDeclarada.new @digit, @lin, @col
    end
  end

  def run table
    rt=table.find @digit
    rt=rt[1]
    return rt
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

  def check table
    return ['string',@val]
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

    if @operand.class == Variables_

      if table.exist @operand.digit
        if @operand.check(table) != 'number'
          raise ErrorDeTipo.new @operand.digit,@operand.check(table),'number'
        else
          return ['number',"-#{@operand.digit}"]
        end
      else
        raise VariableNoDeclarada.new @operand.digit, @operand.lin, @operand.col
      end

    elsif @operand.class < OpAritmetico_
      return @operand.check table

    elsif @operand.class == Numero_
      return ['number',"-#{@operand.digit}"]

    else
      raise ErrorDeOperador.new @operand.digit, 'boolean', 'number', 'Menos Unario'
    end
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

    if @operand.class == Variables_
      if table.exist @operand.digit
        if @operand.check(table) != 'boolean'
          raise ErrorDeTipo.new @operand.digit,@operand.check(table),'boolean'
        else
          return ['boolean',"not #{@operand.digit}"]
        end
      else
        raise VariableNoDeclarada.new @operand.digit, @operand.lin, @operand.col
      end

    elsif @operand.class < OpComparacion_ or @operand.class < OpLogico_
      return @operand.check table

    elsif @operand.class < Bools_
      return ['boolean',"not #{@operand.digit}"]

    else
      raise ErrorDeOperador.new @operand.digit, 'number', 'boolean', 'Not'

    end
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
    x = self.check_ table, @left
    y = self.check_ table, @right
    if x
      return x
    else
      return y
    end
  end

  def check_ table, left

    if left.class == UnaryMenos
      x = left.check table
      return x

    elsif left.class < OpAritmetico_
      left.check table

    elsif left.class == Variables_
      if table.exist left.digit
        if left.check(table) != 'number'
          raise ErrorDeTipo.new left.digit,left.check(table),'number'
        else
          return ['number',left.digit]
        end
      else
        raise VariableNoDeclarada.new left.digit, left.lin, left.col
      end

    elsif left.class == Numero_
      return ['number',left.digit]

    elsif left.class < Bools_
      raise ErrorDeOperador.new left.digit, 'boolean','number', @name[0..-2]

    else
      raise ErrorDeOperador.new left.class,'boolean','number',@name[0..-2]

    end
  end
end

class OpSuma < OpAritmetico_
  def run
    if @left.class != Numero_
      left = @left.run
    else
      left = Float(@left.digit)
    end

    if @right.class != Numero_
      right = @right.run
    else
      right = Float(@right.digit)
    end

    puts left + right
    return left + right
  end
end

class OpResta < OpAritmetico_
  def run
    if @left.class != Numero_
      left = @left.run
    else
      left = Float(@left.digit)
    end

    if @right.class != Numero_
      right = @right.run
    else
      right = Float(@right.digit)
    end

    puts left - right
    return left - right
  end
end

class OpMultiplication < OpAritmetico_
  def run
    if @left.class != Numero_
      left = @left.run
    else
      left = Float(@left.digit)
    end

    if @right.class != Numero_
      right = @right.run
    else
      right = Float(@right.digit)
    end

    puts left * right
    return left * right
  end
end

class OpDivision < OpAritmetico_
  def run

    if @left.class != Numero_
      left = @left.run
    else
      left = Float(@left.digit)
    end

    if @right.class != Numero_
      right = @right.run
    else
      right = Float(@right.digit)
    end

    begin
      puts left / right
      return left / right
    rescue ZeroDivisionError
      raise DivisionPorCero.new
    end

  end
end

class OpDiv < OpAritmetico_
  def run

    if @left.class != Numero_
      left = @left.run
    else
      left = Integer(@left.digit)
    end

    if @right.class != Numero_
      right = @right.run
    else
      right = Integer(@right.digit)
    end

    begin
      puts left / right
      return left / right
    rescue ZeroDivisionError
      raise DivisionPorCero.new
    end

  end
end

class OpModulo < OpAritmetico_
  def run

    if @left.class != Numero_
      left = @left.run
    else
      left = Float(@left.digit)
    end

    if @right.class != Numero_
      right = @right.run
    else
      right = Float(@right.digit)
    end

    begin
      puts left % right
      return left % right
    rescue ZeroDivisionError
      raise DivisionPorCero.new
    end

  end
end

class OpMod < OpAritmetico_
  def run

    if @left.class != Numero_
      left = @left.run
    else
      left = Integer(@left.digit)
    end

    if @right.class != Numero_
      right = @right.run
    else
      right = Integer(@right.digit)
    end

    begin
      puts left % right
      return left % right
    rescue ZeroDivisionError
      raise DivisionPorCero.new
    end

  end
end

class OpComparacion_ < BinaryOP
  def check table
    x = self.check_ table, @left
    y = self.check_ table, @right
    if x[0] == 'number' and y[0] == 'number'
      z = ['boolean',x[1]+y[1]]
      return z
    else
      raise ErrorDeTipo.new z[1],z[0],'number'
    end
  end

  def check_ table, left
    if left.class == Numero_
      return ['number',left.digit]

    elsif left.class < OpAritmetico_
      return left.check table

    elsif left.class == Variables_
      if table.exist left.digit
        if left.check(table) != 'number'
          raise ErrorDeTipo.new left.digit,left.check(table),'number'
        else
          return ['number',left.digit]
        end
      else
        raise VariableNoDeclarada.new left.digit, left.lin, left.col
      end

    elsif left.class == UnaryMenos
      x = left.check table
      return x

    elsif left.class < Bools_
      raise ErrorDeOperador.new left.digit, 'boolean','number', @name[0..-2]

    else
      raise ErrorDeOperador.new left.class,'boolean','number',@name[0..-2]
    end

  end
end

class OpMayor < OpComparacion_
  def run
    if @left.class != Numero_
      left = @left.run
    else
      left = Float(@left.digit)
    end

    if @right.class != Numero_
      right = @right.run
    else
      right = Float(@right.digit)
    end

    puts left > right
    return left > right
  end
end

class OpMenor < OpComparacion_
  def run
    if @left.class != Numero_
      left = @left.run
    else
      left = Float(@left.digit)
    end

    if @right.class != Numero_
      right = @right.run
    else
      right = Float(@right.digit)
    end

    puts left < right
    return left < right
  end
end

class OpMayorIgual < OpComparacion_
  def run
    if @left.class != Numero_
      left = @left.run
    else
      left = Float(@left.digit)
    end

    if @right.class != Numero_
      right = @right.run
    else
      right = Float(@right.digit)
    end

    puts left >= right
    return left >= right
  end
end

class OpMenorIgual < OpComparacion_
  def run
    if @left.class != Numero_
      left = @left.run
    else
      left = Float(@left.digit)
    end

    if @right.class != Numero_
      right = @right.run
    else
      right = Float(@right.digit)
    end

    puts left <= right
    return left <= right
  end
end

class OpIgual < OpComparacion_
  def run
    if @left.class != Numero_
      left = @left.run
    else
      left = Float(@left.digit)
    end

    if @right.class != Numero_
      right = @right.run
    else
      right = Float(@right.digit)
    end

    puts left == right
    return left == right
  end
end

class OpDistinto < OpComparacion_
  def run
    if @left.class != Numero_
      left = @left.run
    else
      left = Float(@left.digit)
    end

    if @right.class != Numero_
      right = @right.run
    else
      right = Float(@right.digit)
    end

    puts left != right
    return left != right
  end
end

class OpLogico_ < BinaryOP
  def check table
    x = self.check_ table, @left
    y = self.check_ table, @right
    if x
      return x
    else
      return y
    end
  end

  def check_ table, left

    if left.class == UnaryNot
      x = left.check table
      return x

    elsif left.class < OpLogico_ or left.class < OpComparacion_
      left.check table

    elsif left.class == Variables_
      if table.exist left.digit
        if left.check(table) != 'boolean'
          raise ErrorDeTipo.new left.digit,left.check(table),'boolean'
        else
          return ['boolean',left.digit]
        end
      else
        raise VariableNoDeclarada.new left.digit, left.lin, left.col
      end

    elsif left.class < Bools_
      return ['boolean',left.digit]

    elsif left.class == Numero_
      raise ErrorDeOperador.new left.digit, 'number','boolean', @name[0..-2]

    else
      raise ErrorDeOperador.new left.class,'number','boolean',@name[0..-2]
    end

  end
end

class OpAnd < OpLogico_
  def run
    if @left.class == True_
      left = true
    elsif @left.class == False_
      left = false
    else
      left  = @left.run
    end

    if @right.class == True_
      right = true
    elsif @right.class == False_
      right = false
    else
      right  = @right.run
    end

    res = (left and right)
    puts res
    return res
  end
end

class OpOr < OpLogico_
  def run
    if @left.class == True_
      left = true
    elsif @left.class == False_
      left = false
    else
      left  = @left.run
    end

    if @right.class == True_
      right = true
    elsif @right.class == False_
      right = false
    else
      right  = @right.run
    end

    res = (left or right)
    puts res
    return res
  end
end

class OpAsignacion < BinaryOP

  def run table
      table.modify @left.digit @right.run
  end

  def check table
    if  !table.exist @left.digit
      raise VariableNoDeclarada.new @left.digit, @left.lin, @left.col
    end

    esp = table.find @left.digit

    if @right.class < UnaryOP
      x = @right.check table
      act = x[0]
      tok = x[1]

    elsif @right.class == Variables_
      tok = @right.digit
      if table.exist @right.digit
        act = table.find tok
      else
        raise VariableNoDeclarada.new @right.digit, @right.lin, @right.col
      end


    elsif @right.class < Bools_ or @right.class == Numero_
      tok = @right.digit
      if @right.class == Numero_
        act = 'number'
      else
        act = 'boolean'
      end

    elsif @right.class == LlamadaFunciones_
      x = @right.check table
      act = x[0]
      tok = x[1]

    else
      x = @right.check table
      act = x[0]
      tok = x[1]

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
    if @ident.class != OpAsignacion
      if table.exist @ident.digit and !table.exist('s_$__')
        raise ErrorExistencia.new @ident.digit
      else
        table.remove 's_$__' if table.exist('s_$__')
        table.insert @ident.digit, [@tipo.digit,nil]
      end
    else
      x = @ident.right.check table
      x = x[0] if x.class == Array
      table.insert @ident.left.digit, x
    end
    return table
  end

end

# Palabras Reservadas
class Palabra_ < AST

  attr_accessor :nombre

  def initialize d
      @nombre = d.token
  end

  def print_ast indent=""
      puts "#{indent}Palabra Reservada:"
      puts "#{indent + '  '}nombre: #{@nombre}"
  end

  def check table
    return ['palabra_reser',@nombre]
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

  def check table
    reserv = false
    if @name.class == Palabra_
      ident = @name.nombre
      reserv = true
    else
      ident = @name.digit
      e = table.exist ident
      if !e
        raise FuncionNoDeclarada.new @name.digit, @name.lin, @name.col
      end
    end

    x = cantidadArgs ident, table
    cant = x[0]
    act = 0
    act = argsActuales @args if !args.nil?

    if act != cant
      raise ErrorCantArgumentos.new ident, cant, act
    else
      checkTypes @args, table, cant, ident, reserv, x[1] if act!=0
      if table.exist 'ret_$__'
        return [table.find('ret_$__'),ident]
      else
        return [nil,ident]
      end
    end

  end

  def recursive x, table
    z = []
    x.attrs.each do |a|
      if a.class != EnSerie
        y =  a.check(table)
        if y.class == Array
          z << y
        else
          z << [y,a.digit]
        end
      else
        w = recursive(a, table)
        w.each do |a|
          z << a
        end
      end
    end
    return z
  end

  def checkTypes args, table, cant, ident, reserv, array

    if cant == 1
      t = args.check table
      if reserv
        raise ErrorDeTipo.new args.digit,t,'number' if t != 'number'
      else
        raise ErrorDeTipo.new args.digit,t[0],array[0][1] if t[0] != array[0][1]
      end

    else
      z = recursive args, table
      for i in 0..cant-1
        raise ErrorDeTipo.new z[i][1],z[i][0],array[i][1][0] if array[i][1][0] != z[i][0]
      end
    end

  end

  def argsActuales args
    if args.class != EnSerie
      return 1
    else
      i = 0
      args.attrs.each do |a|
        if a.class != EnSerie
          i += 1
        else
          i += argsActuales a
        end
      end
    end
    return i
  end

  def cantidadArgs name, table

    if ['home','openeye','closeeye'].include? name
      return [0,[]]

    elsif ['forward','backward','rotatel','rotater'].include? name
      return [1,[['x','number']]]

    elsif ['setposition','arc'].include? name
      return [2,[['x','number'],['y','number']]]

    else
      i = 0
      x = []
      table.find(name).tabla.each do |a|
        if(a[1].class==TablasDeAlcance)
          
          if ['ret_$__','has_$_r$_'].include? a[0]
          elsif ! ['boolean','number'].include? a[1]
          else
            i = i+1
            x << a
          end
        else
          if ['ret_$__','has_$_r$_'].include? a[0]
          elsif ! ['boolean','number'].include? a[1][0]
          else
            i = i+1
            x << a
          end
        end

      end
      return [i,x]
    end
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

  def check table
    ret = table.exist 'ret_$__'

    if ret
      retType = table.find 'ret_$__'
      if retType == false
        raise ErrorReturn.new 0, nil, nil
      else
        y = @operand.check(table)
        y = y[0] if y.class == Array

        if retType != y
          raise ErrorReturn.new 1, y, retType
        else
          table.insert 'has_$_r$_', true
          x = table

          while x.padre
            x = x.padre
            x.insert 'has_$_r$_', true
          end

          return [retType,@operand]
        end
      end

    else
      raise ErrorReturn.new 0,nil,nil
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

  def check table
    if ! table.exist @operand.digit
      raise VariableNoDeclarada.new @operand.digit, @operand.lin, @operand.col
    end
  end
end

# Salida
class Salida_ < Singleton
  def run
    print @operand
  end
  def print_ast indent=""
      puts "#{indent}Salida:"
      puts "#{indent + '  '}expresiones:"
      attrs.each do |a|
          a.print_ast indent + "    " if a.respond_to? :print_ast
      end
  end

  def check table
    return @operand.check table
  end

end

class Salida_S < Singleton

  def run
    puts @operand
  end

  def print_ast indent=""
      puts "#{indent}Salida con Salto:"
      puts "#{indent + '  '}expresiones:"
      attrs.each do |a|
          a.print_ast indent + "    " if a.respond_to? :print_ast
      end
  end

  def check table
    return @operand.check table
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

  def run
    @dec.run
    @ins.run
  end


  def check table
    t = TablasDeAlcance.new table
    t.tabla['s_$__'] = true
    @dec.check t if @dec.respond_to? :check
    insert table, t
    @ins.check t
  end


  def insert table, t
    w = 1
    i = 1

    while t.exist(w)
      w = i.to_s
      i += 1
    end

    table.insert w,t
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
  def run
    if(@cond0.run)
      rt=@bloq.run
      puts rt
      return rt
    else
      #pongo el print para verificar si existe una condicion else.
      if @cond1.respond_to? :print_ast
        rt=@cond1.run
        puts rt
        return rt
      end
    end
  end

  def check table
    self.check_cond table,@cond0
    self.check_Bloq table,@bloq
    if @cond1!= nil
      self.check_Bloq table,@cond1
    end
  end

  def check_cond table, cond
    if cond.class < OpComparacion_ or cond.class < OpLogico_ or cond.class < Bools_
      x=cond.check table
      if x[0] != 'boolean'
        raise ErrorDeTipo.new 'El argumento del If' , x[0] ,'Operacion Comparacion'
      end
    elsif cond.class<=Variables_
      x= cond.check table
      if x==nil
        raise VariableNoDeclarada.new cond.digit, cond.lin, cond.col
      end
    else
      raise ErrorDeTipo.new 'El argumento del If' , cond.class,'Operacion Comparacion'
    end
  end

  def check_Bloq table, bloq
    bloq.check table
  end
end

class IteracionIndeterminada < AST
  attr_accessor :exp,:bloque

  def run
      while(@exp.run)
        @bloque.run
      end
  end

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

  def check table
    self.check_exp table
    self.check_Bloq table
  end

  def check_exp table
    x=@exp.check table
    if x==nil
      raise VariableNoDeclarada.new @exp.digit, @exp.lin, @exp.col
    end

    if [True_,False_,Variables_].include? @exp.class or @exp.class<OpLogico_ or @exp.class<OpComparacion_
        if x[0] != 'boolean' and x !='boolean'
          raise ErrorDeTipo.new 'El argumento del while' , x[0] ,'Booleano'
        end
    else
      raise ErrorDeTipo.new 'El argumento del while' , @exp.class ,'Booleano'
    end
  end

  def check_Bloq table
    @bloque.check table
  end
end

class IteracionDeterminada < AST
  attr_accessor :var, :desde, :hasta, :incremento ,:bloque

  def run table
     #consigo el simbolo de la variable
     x=@var.digit
     l1=@desde.run
     l2=@hasta.run
     if @incremento==nil by=1
     else by=@incremento.run end

     while l1<=l2
      #Actualizo la tabla con el valor que me da el for.
      table.modify x.digit l1
      @bloque.run
      l1+=by
     end
  end

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

  def check table
    tableFor = TablasDeAlcance.new table
    insert table, tableFor
    self.check_var tableFor if @var.respond_to? :check
    self.check_inter tableFor,@desde if @desde.respond_to? :check
    self.check_inter tableFor, @hasta
    self.check_inter tableFor, @incremento if @incremento.respond_to? :check
    self.check_Bloq tableFor
  end

  def insert table, t
    w = 1
    i = 1
    while t.exist(w)
     i += 1
     w = i.to_s
    end
    table.insert w,t
  end


  def check_Bloq table
    @bloque.check table
  end


  def check_inter table,inter
    if inter.class<OpAritmetico_ or inter.class<=Numero_
      x=inter.check table
      if x[0] != 'number'
        raise ErrorDeTipo.new 'El for' , inter.class ,'number'
      end

    elsif inter.class<=Variables_
      x = inter.check table
      if x==nil
        raise VariableNoDeclarada.new inter.digit, inter.lin, inter.col
      end

      if x != 'number'
        raise ErrorDeTipoArg.new 'El for' , inter.class ,'number'
      end

    else
      raise ErrorDeTipoArg.new 'El for' , inter.class ,'number'
    end
  end

  def check_var table
    if @var.class<OpAritmetico_
      x=@var.check table
      if x[0] != 'number'
        raise ErrorDeTipo.new 'El argumento del for' , @var.class ,'number'
      end
    elsif @var.class<=Variables_
      table.insert @var.digit,['number',nil]
      x = @var.check table
      if x == nil
        raise VariableNoDeclarada.new @var.digit, @var.lin, @var.col
      end

      if x != 'number'
        raise ErrorDeTipoArg.new 'El argumento del for' , @var.class ,'number'
      end

    elsif @var.class<=Numero_
      x=@var.check table
      if x[0] != 'number'
        raise ErrorDeTipo.new 'El argumento del for' , @var.class ,'number'
      end
    else
      raise ErrorDeTipo.new 'El argumento del for' , @var.class ,'number'
    end
  end

  def check_Bloq table
    @bloque.check table
  end
end

class IteracionDeterminadaRepeat < IteracionDeterminada

  def run table
     sentinela=0
     l2=@hasta.run
     by=1
     else by=@incremento.run end

     while sentila<hasta
      @bloque.run
      sentila+=1
     end
  end


  def print_ast indent=""
    puts "#{indent}Iteracion Determinada: "
    puts "#{indent + '  '}repeat:"
    @bloque.print_ast indent + '    '
    puts "#{indent + '  '}times:"
    @hasta.print_ast indent + '    '
  end

  def check_Bloq table
    @bloque.check table
  end

  def check_inter table,inter
    if inter.class<OpAritmetico_ or inter.class<=Numero_
      x=inter.check table
      if x[0] != 'number'
        raise ErrorDeTipo.new 'El repeat' , inter.class ,'number'
      end

    elsif inter.class<=Variables_
      x = inter.check table
      if x==nil
        raise VariableNoDeclarada.new inter.digit, inter.lin, inter.col
      end

      if x != 'number'
        raise ErrorDeTipoArg.new 'El repeat' , x ,'number'
      end

    else
      raise ErrorDeTipoArg.new 'El repeat' , inter.class ,'number'
    end
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
    if @ret
      if @ret.class == Number_
        t.tabla['ret_$__'] = 'number'
      else
        t.tabla['ret_$__'] = 'boolean'
      end
    else
      t.tabla['ret_$__']=false
    end
    if table.exist @funcion.digit
      raise ErrorExistencia.new @funcion.digit
    else
      table.insert @funcion.digit, TablasDeAlcance.new(table)
      table.insert @funcion.digit, @args.check(t) if @args. respond_to? :check
    end

    @inst.check t
    ret  = t.exist 'has_$_r$_'
    esp = t.find 'ret_$__'
    if !ret and esp
      raise ErrorReturn.new 2,nil,esp
    end

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
    @dec.check table if @dec.respond_to? :check
    tableProg = TablasDeAlcance.new table
    table.insert 'program' , tableProg
    insertar_base table
    @inst.check tableProg

    table.to_s
    return table
  end

  def run
    @inst.run
  end

  def insertar_base padre
    x = Hash.new
    y = x.clone
    y['arg0'] = 'number'
    z = y.clone
    z['arg1'] = 'number'

    t_0 = TablasDeAlcance.new padre
    t_0.tabla = x

    t_1 = t_0.clone
    t_1.tabla = y

    t_2 = t_1.clone
    t_2.tabla = z

    ['home','openeye','closeeye'].each do |e|
      padre.insert e, t_0
    end

    ['forward','backward','rotatel','rotater'].each do |e|
      padre.insert e, t_1
    end

    ['setposition','arc'].each do |e|
      padre.insert e, t_2
    end
  end
end

class TablasDeAlcance
  attr_accessor :tabla, :padre

  def print_
    @tabla.each do |a|
      print_table a, "" if !['has_$_r$_','ret_$__','arc','setposition','forward','backward','rotatel','rotater','home','openeye','closeeye'].include? a[0]
      puts "" if !['has_$_r$_','ret_$__','arc','setposition','forward','backward','rotatel','rotater','home','openeye','closeeye'].include? a[0]
    end
  end

  def print_table table, indent=""
    puts "#{indent}Alcance #{table[0]}_:"

    puts "#{indent +'  '}Variables:"
    table[1].tabla.each do |a|
      if (! ['has_$_r$_','ret_$__','s_$__'].include? a[0]) and (a[1].class != TablasDeAlcance)
        puts "#{indent+'    '}#{a[0]}: #{a[1][0]}"
      end
    end

    print "#{indent +'  '}Sub_alcance:"
    x = false
    table[1].tabla.each do |a|
      if a[1].class == TablasDeAlcance and !['has_$_r$_','ret_$__'].include? a[0]
        puts '' if !x
        print_table a, indent + '    '
        x = true
      end
    end
    puts " None" if !x

  end

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

  def remove value
    @tabla.delete(value)
  end

  def modify element, value
    @tabla[element][1]=value
  end

end
