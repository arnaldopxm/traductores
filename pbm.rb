class Turtle
  $pi = Math::PI
  attr_accessor :act, :draw, :sent

  def initialize
    @draw=1
    @sent= $pi/2
    @act = [500,500]
    @mtrx = []
    x = []
    for i in 0..1000
      x << 0
    end

    for i in 0..1000
      y = x.clone
      @mtrx << y
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
    @act=[500,500]
  end

  def openeye
    @draw=1
  end

  def closeeye
    @draw=0
  end

  def forward steps
    x = Math.cos(@sent + $pi/2)*steps + @act[0]
    x = Integer(x)

    if @sent == $pi
      puts "if"
      x = act[0] - steps
      b = act[0]
      @mtrx[act[1]][b] = 1 if @draw == 1
      while b != x
        if b > x
          b = b - 1
        else
          b = b + 1
        end
        @mtrx[act[1]][b] = 1 if @draw == 1
      end
      @act = [b,act[1]]

    elsif @sent == 0 or @sent == 360
      puts "elsif"
      x = act[0] + steps
      b = act[0]
      @mtrx[act[1]][b] = 1 if @draw == 1
      while b != x
        if b > x
          b = b - 1
        else
          b = b + 1
        end
        @mtrx[act[1]][b] = 1 if @draw == 1
      end
      @act = [b,act[1]]

    else
      puts "else"
      b = @act[0]
      y = @act[1]
      puts "#{b},#{y}"
      @mtrx[b][y] = 1 if @draw == 1

      while b != x

        if b > x
          puts "igg"
          b = b - 1
        else
          puts "egg"
          b = b + 1
        end

        y = Math.tan(@sent + $pi/2)*(b-@act[1]) + @act[1]
        puts @sent*180/$pi
        # y = y - 30 if @sent !=0
        y = Integer(y)
        puts "..#{b},#{y}"
        begin
          @mtrx[b][y] = 1 if @draw == 1
        rescue
        end
      end
      @act = [b,y]
    end
  end

  def backward steps

    y = @sent
    if @sent == 0 or @sent == 360
      x = 180
    elsif @sent == $pi/2
      x = 270
    elsif @sent == $pi
      x = 0
    elsif @sent == 3*$pi/2
      x = 90
    elsif @sent>0 and @sent<$pi/2
      x = 270-@sent*180/$pi
    elsif @sent>$pi/2 and @sent<$pi
      x = 90+@sent*180/$pi
    elsif @sent>$pi and @sent<3*$pi/2
      x = @sent*180/$pi-90
    elsif @sent>3*$pi/2 and @sent<2*pi
      x = @sent*180/$pi-180
    end
    self.setGrade(x)
    forward(steps)
    self.setGrade(y)
  end

  def rotater degree
    @sent = @sent*180/$pi - degree
    @sent = @sent % 360
    @sent = @sent*$pi/180
  end

  def rotatel degree
    @sent = @sent + degree*$pi/180
    if @sent == 2*$pi
      @sent = 0
    elsif @sent > 2*$pi
      resto = @sent / (2*$pi)
      resto = Integer(resto)
      @sent = @sent - resto*2*$pi
    end
  end

  def setPosition hor, ver
    @act = [-(ver-500),hor+500]
  end

  def setGrade val
    @sent = val*$pi/180
  end

  def planoC
    x = @sent
    y = @act
    w = @draw

    self.setPosition(0,0)
    self.forward(500)
    self.setPosition(0,0)
    self.backward(500)
    self.setGrade(0)
    self.setPosition(0,0)
    self.forward(500)
    self.setPosition(0,0)
    self.backward(500)

    @act = y
    @sent = x
    @draw = w
  end

end

x = Turtle.new
# x.planoC
x.openeye()
x.forward(10)
puts x.act
x.forward(20)
puts x.act
x.rotater(45)
x.forward(40)
x.write "prueba"
