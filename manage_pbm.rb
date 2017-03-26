class Turtle
  attr_accessor :act

  def initialize
    @act = [500,500]
    @mtrx = []
    x = []
    for i in 0..1000
      x << 0
    end

    for i in 0..1000
      @mtrx << x
    end

  end

  def write name
    name = name + ".pbm"
    open(name,'w') do |f|

      f.puts "P1"
      f.puts "1001 1001"

      @mtrx.each do |m|

        m.each do |x|
          f.print "#{x}\s"
        end

        f.print"\n"

      end

    end
  end

end

x = Turtle.new
x.write "prueba"
