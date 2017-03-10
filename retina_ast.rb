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
  attr_accessor :digit

  def initialize d
      @digit = d.token
  end

  def print_ast indent=""
      puts "#{indent}Identificador:"
      puts "#{indent+'  '}nombre: #{@digit}"
  end

  def check table
    if table.exist @digit
      return table.find @digit
    else
      raise VariableNoDeclarada.new @digit
    end
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
        raise VariableNoDeclarada.new @operand.digit
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
      #puts 1

      if table.exist @operand.digit
        if @operand.check(table) != 'boolean'
          raise ErrorDeTipo.new @operand.digit,@operand.check(table),'boolean'
        else
          return ['boolean',"not #{@operand.digit}"]
        end
      else
        raise VariableNoDeclarada.new @operand.digit
      end

    elsif @operand.class < OpComparacion_ or @operand.class < OpLogico_
      #puts 2
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
      #puts 'caso1'
      x = left.check table
      return x

    elsif left.class < OpAritmetico_
      #puts 'caso2'
      left.check table

    elsif left.class == Variables_
      #puts 'caso3'
      if table.exist left.digit
        if left.check(table) != 'number'
          raise ErrorDeTipo.new left.digit,left.check(table),'number'
        else
          return ['number',left.digit]
        end
      else
        raise VariableNoDeclarada.new left.digit
      end

    elsif left.class == Numero_
      #puts 'caso4'
      return ['number',left.digit]

    elsif left.class < Bools_
      raise ErrorDeOperador.new left.digit, 'boolean','number', @name[0..-2]

    else
      raise ErrorDeOperador.new left.class,'boolean','number',@name[0..-2]

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
      #puts 1
      return ['number',left.digit]

    elsif left.class < OpAritmetico_
      #puts 2
      return left.check table

    elsif left.class == Variables_
      #puts 3
      if table.exist left.digit
        if left.check(table) != 'number'
          raise ErrorDeTipo.new left.digit,left.check(table),'number'
        else
          return ['number',left.digit]
        end
      else
        raise VariableNoDeclarada.new left.digit
      end

    elsif left.class == UnaryMenos
      #puts 4
      x = left.check table
      return x

    elsif left.class < Bools_
      #puts 5
      raise ErrorDeOperador.new left.digit, 'boolean','number', @name[0..-2]

    else
      raise ErrorDeOperador.new left.class,'boolean','number',@name[0..-2]
    end

  end
end

class OpMayor < OpComparacion_;end
class OpMenor < OpComparacion_;end
class OpMayorIgual < OpComparacion_;end
class OpMenorIgual < OpComparacion_;end
class OpIgual < OpComparacion_;end
class OpDistinto < OpComparacion_;end

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
      #puts 'caso1'
      x = left.check table
      return x

    elsif left.class < OpLogico_ or left.class < OpComparacion_
      #puts 'caso2'
      left.check table

    elsif left.class == Variables_
      #puts 'caso3'
      if table.exist left.digit
        if left.check(table) != 'boolean'
          raise ErrorDeTipo.new left.digit,left.check(table),'boolean'
        else
          return ['boolean',left.digit]
        end
      else
        raise VariableNoDeclarada.new left.digit
      end

    elsif left.class < Bools_
      #puts 'caso4'
      return ['boolean',left.digit]

    elsif left.class == Numero_
      raise ErrorDeOperador.new left.digit, 'number','boolean', @name[0..-2]

    else
      raise ErrorDeOperador.new left.class,'number','boolean',@name[0..-2]
    end

  end
end

class OpAnd < OpLogico_;end
class OpOr < OpLogico_;end

class OpAsignacion < BinaryOP

  def check table
    if  !table.exist @left.digit
      raise VariableNoDeclarada.new @left.digit
    end

    esp = table.find @left.digit

    if @right.class < UnaryOP
      #puts 'caso 1'
      x = @right.check table
      act = x[0]
      tok = x[1]

    elsif @right.class == Variables_
      #puts '4'
      tok = @right.digit
      if table.exist @right.digit
        act = table.find tok
      else
        raise VariableNoDeclarada.new @right.digit
      end


    elsif @right.class < Bools_ or @right.class == Numero_
      #puts 'caso 2'
      tok = @right.digit
      if @right.class == Numero_
        act = 'number'
      else
        act = 'boolean'
      end

    elsif @right.class == LlamadaFunciones_
      #puts 'caso 5'
      x = @right.check table
      act = x[0]
      tok = x[1]

    else
      #puts 'caso 3'
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

  ##################
  def check table
    #puts "#{table},#{table.attrs}"
    if table.exist @ident.digit and !table.exist('s')
      raise ErrorExistencia.new @ident.digit
    else
      table.remove 's' if table.exist('s')
      table.insert @ident.digit, @tipo.digit
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
        raise FuncionNoDeclarada.new @name.digit
      end
    end

    x = cantidadArgs ident, table
    cant = x[0]
    act = argsActuales @args
    #puts "#{act}, #{cant}"
    #puts x[1]

    if act != cant
      raise ErrorCantArgumentos.new ident, cant, act
    else
      ###
      checkTypes @args, table, cant, ident, reserv, x[1]
      if table.exist 'ret'
        return [table.find('ret'),ident]
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

    #puts array

    if cant == 1
      t = args.check table
      if reserv
        raise ErrorDeTipo.new args.digit,t,'number' if t != 'number'
      else
        raise ErrorDeTipo.new args.digit,t,array[0][1] if t != array[0][1]
      end

    else
      z = recursive args, table
      #puts z
      #puts '.'
      for i in 0..cant-1
        #puts "#{z[i]}, #{array[i]}"
        raise ErrorDeTipo.new z[i][1],z[i][0],array[i][1] if array[i][1] != z[i][0]
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
      return 0
    elsif ['forward','backward','rotatel','rotater'].include? name
      return 1
    elsif ['setposition','arc'].include? name
      return 2
    else
      i = 0
      x = []
      table.find(name).tabla.each do |a|
        if ['ret','has_r'].include? a[0]
        elsif ! ['boolean','number'].include? a[1]
        else
          i = i+1
          x << a
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
    ret = table.exist 'ret'

    if ret
      retType = table.find 'ret'
      if retType == false
        raise ErrorReturn.new 0, nil, nil
      else
        #puts @operand.check(table)[0]
        #puts retType
        y = @operand.check(table)
        y = y[0] if y.class == Array

        if retType != y
          raise ErrorReturn.new 1, y, retType
        else
          table.insert 'has_r', true
          x = table

          while x.padre
            x = x.padre
            x.insert 'has_r', true
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
      raise VariableNoDeclarada.new @operand.digit
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

  def check table
    return @operand.check table
  end

end

class Salida_S < Singleton
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

  def check table
    t = TablasDeAlcance.new table
    ####################
    t.tabla['s'] = true
    @dec.check t if @dec.respond_to? :check
    insert table, t
    #table.insert 'sub_alcance',t
    @ins.check t
    #table.insert 'sub_alcance',
  end


  def insert table, t
    w = 'sub_alcance'
    i = 1

    #puts t.exist(w)
    while t.exist(w)
      #puts w
      w = w + i.to_s
      i += 1
    end

    #puts "insert #{w}"
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
        raise VariableNoDeclarada.new cond.digit
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
      raise VariableNoDeclarada.new @exp.digit
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
    #table.insert 'sub_alcance' , tableFor
    insert table, tableFor
    self.check_var tableFor if @var.respond_to? :check
    self.check_inter tableFor,@desde if @desde.respond_to? :check
    self.check_inter tableFor, @hasta
    self.check_inter tableFor, @incremento if @incremento.respond_to? :check
    self.check_Bloq tableFor
  end

  def insert table, t
    w = 'sub_alcance'
    i = 1
    while t.exist(w)
     #puts w
     w = w + i.to_s
     i += 1
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
        raise VariableNoDeclarada.new inter.digit
      end

      if x != 'number'
        raise ErrorDeTipoArg.new 'El for' , inter.class ,'number'
      end

    else
      raise ErrorDeTipoArg.new 'El for' , inter.class ,'number'
    end
  end

  def check_var table
    puts "El checkvar recibe #{@var.class}"
    if @var.class<OpAritmetico_
      x=@var.check table
      if x[0] != 'number'
        raise ErrorDeTipo.new 'El argumento del for' , @var.class ,'number'
      end
    elsif @var.class<=Variables_
      table.insert @var.digit,'number'
      x = @var.check table
      if x == nil
        raise VariableNoDeclarada.new @var.digit
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
    puts "salio"
  end

  def check_Bloq table
    @bloque.check table
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
        raise VariableNoDeclarada.new inter.digit
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
    #puts t.attrs
    if @ret
      #puts @ret.class
      if @ret.class == Number_
        t.tabla['ret'] = 'number'
      else
        t.tabla['ret'] = 'boolean'
      end
    else
      t.tabla['ret']=false
    end
    if table.exist @funcion.digit
      raise ErrorExistencia.new @funcion.digit
    else
      table.insert @funcion.digit, TablasDeAlcance.new(table)
      table.insert @funcion.digit, @args.check(t) if @args. respond_to? :check
    end

    @inst.check t
    ret  = t.exist 'has_r'
    esp = t.find 'ret'
    #puts esp;
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
    @inst.check tableProg
    #table.insert 'declaraciones', @dec.check table if @dec.respond_to? :check
    #table.insert 'instrucciones', @inst.check table if @inst.respond_to? :check
    table.to_s
    return table
  end

end

class TablasDeAlcance
  attr_accessor :tabla, :padre

  def to_s
    @tabla.map { |e| if e!='has_r' or e!='ret' then puts e end}
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

  def remove value
    @tabla.delete(value)
  end
  # def insertSub name, value
  #   @sub[name] = value
  # end

end
