RACC = racc
PARSER = retina.y

retina_parser.rb: ${PARSER}
	(${RACC} $< -o $@)

clean:
	rm retina_parser.rb
