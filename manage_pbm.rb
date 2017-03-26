class Turtle
  attr_accessor :act :x :y :draw :sentido

  def initialize
    @x=0
    @y=0
    @draw=0
    @sentido=[1,1]
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

  def home 
    @x=0
    @y=0
  end

  def openeye
    @pintar=1
  end

  def closeeye
    @pintar=0
  end

  def forward steps
    x+=(@sentido[0]*steps)
    y+=(@sentido[1]*steps)
    @mtrx[x][y]=@pintar if @pintar==1
  end

  def backward steps
    x-=(@sentido[0]*steps)
    y-=(@sentido[1]*steps)
    @mtrx[x][y]=@pintar if @pintar==1
  end

  def rotatel degree
  end

  def rotatel degree
  end

  def setPosition vert hor
    @x=hor
    @y=vert
  end




end

x = Turtle.new
x.write "prueba"
