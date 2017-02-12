=begin
	Funciones y clases para el analizador lexicografico lexer.rb
Autores
	-Arnaldo Quintero 13-11150
	-Gabriel Gutierrez 13-10625

Ultima modificacion: 25/01/2017
=end
require_relative 'clases.rb'

$diccionario = {
  True: /\Atrue\b/,
  False: /\Afalse\b/,
  Numero: /\A\d+(\.\d+)*\b/,
  And: /\Aand\b/,
  Or: /\Aor\b/,
  Not: /\Anot\b/,
  Igual: /\A==/,
  Distinto: /\A\/=/,
  MayorIgual: /\A>=/,
  MenorIgual: /\A<=/,
  Mayor: /\A>/,
  Menor: /\A</,
  Separador: /\A;/,
  Asignacion: /\A=/,
  BackSlash: /\A\\/,
  ParentesisA: /\A\(/,
  ParentesisC: /\A\)/,
  Flecha: /\A->/,
  Coma: /\A,/,
  Menos: /\A-/,
  Por: /\A\*/,
  Entre: /\A\//,
  Porcentaje: /\A\%/,
  Mas: /\A\+/,
  Div: /\Adiv\b/,
  Mod: /\Amod\b/,
  Program: /\Aprogram\b/,
  Read: /\Aread\b/,
  Write: /\Awrite\b/,
  Writeln: /\Awriteln\b/,
  If: /\Aif\b/,
  Then: /\Athen\b/,
  End: /\Aend\b/,
  While: /\Awhile\b/,
  Do: /\Ado\b/,
  Repeat: /\Arepeat\b/,
  Times: /\Atimes\b/,
  Func: /\Afunc\b/,
  Begin: /\Abegin\b/,
  Return: /\Areturn\b/,
  For: /\Afor\b/,
  From: /\Afrom\b/,
  To: /\Ato\b/,
  By: /\Aby\b/,
  Is: /\Ais\b/,
  Number: /\Anumber\b/,
  Boolean: /\Aboolean\b/,
  Home: /\Ahome\b/,
  OpenEye: /\Aopeneye\b/,
  CloseEye: /\Acloseeye\b/,
  Forward: /\Aforward\b/,
  Backward: /\Abackward\b/,
  RotateL: /\Arotatel\b/,
  RotateR: /\Arotater\b/,
  SetPosition: /\Asetposition\b/,
  Arc: /\Aarc\b/,
  Variables: /\A[a-z]\w*\b/,
  Strings: /\A("(.|\s)*[^\\,\n]?")|\A"[^"]*\n/
}
2
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

    return @tokens

  end
end
