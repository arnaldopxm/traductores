class VariableNoDeclarada < RuntimeError
  def initialize tok
    @token = tok
  end

  def to_s
    "Error: variable no declarada '#{@token}'"
  end
end

class ErrorDeTipo < RuntimeError
  def initialize tok,actual, esperado
    @token = tok
    @act = actual
    @esp = esperado
  end

  def to_s
    "Error: '#{@token}' es una expresion de tipo '#{@act}' y se esperaba una de tipo '#{@esp}'"
  end
end
