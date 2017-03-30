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
    steps = steps.round
    if (@sent*180/$pi).round == 90 or (@sent*180/$pi).round == 270
      # puts "AQUIIIII"
      x0 = @act[1]
      y = -steps + @act[0] if (@sent*180/$pi).round == 90
      y = steps + @act[0] if (@sent*180/$pi).round == 270
      y0 = @act[0]
      not_eql = true

      begin
        @mtrx[y0][x0] = 1 if @draw == 1 and !(y0 >1000 or x0 > 1000 or y0 < 0 or x0 < 0)
      rescue
      end

      while not_eql

        if y0 > y
          # puts y0
          y0 = y0 - 1
        else
          # puts y0
          y0 = y0 + 1
        end

        begin
          @mtrx[y0][x0] = 1 if @draw == 1 and !(y0 >1000 or x0 > 1000 or y0 < 0 or x0 < 0)
        rescue
        end

        not_eql = false if y0 == y
      end
      @act = [y0,x0]

    else
      x = Math.cos(@sent)*steps
      x = Integer(x) + @act[1]
      x0 = @act[1]
      y = @act[0]
      y_max = Math.sin(@sent)*steps
      y_max = Integer(y_max)
      not_eql = true
      # puts "x = #{x}"
      # puts "angle = #{@sent*180/$pi}"
      # puts "act[0] = #{@act[0]}"

      begin
        @mtrx[y][x0] = 1 if @draw == 1 and !(y >1000 or x0 > 1000 or y < 0 or x0 < 0)
      rescue
      end

      while not_eql

        if x0 > x
          x0 = x0 - 1
          y = (x - x0)*Math.tan(@sent) + @act[0] - y_max
          y = Integer(y)
        else
          x0 = x0 + 1
          y = (x - x0)*Math.tan(@sent) + @act[0] - y_max
          y = Integer(y)
        end

        begin

          if @draw == 1 and !(y >1000 or x0 > 1000 or y < 0 or x0 < 0)
            # puts "#{x0},#{y}"
            @mtrx[y][x0] = 1
          end
        rescue
        end

        not_eql = false if x0 == x

      end
      @act = [y,x0]
    end
    # puts @act.to_s

  end

  def backward steps
    self.rotater(180)
    forward(steps)
    self.rotatel(180)
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
    @act = [ver-500,hor-500]
  end

  def setDegree val
    @sent = val*$pi/180
  end

  def planoC
    x = @sent
    y = @act
    w = @draw

    self.home
    self.setDegree(90)
    self.forward 500
    self.home
    self.backward 500
    self.home
    self.setDegree(0)
    self.forward 500
    self.home
    self.backward 500

    @act = y
    @sent = x
    @draw = w
  end

end

# x = Turtle.new
# # x.rotatel(45)
# x.planoC
# # x.forward(800)
#
# for i in 1..200
#   x.forward(i)
#   x.rotater(19)
# end
#
# x.write "prueba"
