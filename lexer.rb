require_relative 'retina'

input = "false true"

lexer = Lexer.new(input)
puts(lexer.leerPorLinea)
