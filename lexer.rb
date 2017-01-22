require_relative 'retina'

=begin
unless ARGV[0].end_with? ".rtn"
  abort("Por favor introduzca un archivo valido en formato .rtn")
end

file = File::read(ARGV[0])
=end
def main

  unless ARGV[0].end_with? ".rtn"
    abort("Por favor introduzca un archivo valido en formato .rtn")
  end

  input = "  true false 123 = and div mod x==10
  10 xa if   "
  #puts file
  lexer = Lexer.new(input)
#puts lexer.leerPorLinea
  puts ""
  begin
    lexer.leerPorLinea
  rescue CaractInesperado => e
    puts e
    puts ""
    return
  end

  lexer.tokens.each do |t|
    puts t
  end
  puts ""
end

main
