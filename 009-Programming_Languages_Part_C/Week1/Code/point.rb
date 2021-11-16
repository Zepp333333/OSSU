class Point
  attr_accessor :x, :y # defines getters and setters

  def initialize(a,b)
    @x = a
    @y = b
  end

  def distFromOrigin
    Math.sqrt(@x * @x + @y * @y) # uses instance varibales
  end

  def distFromOrigin2
    Math.sqrt(x * x + y * y) # uses getters
  end
end

class ColorPoint < Point
  attr_accessor :color

  def initialize(x, y, c="clear")
    super(x,y)
    @color = c
  end
end

class ThreeDPoint < Point
  attr_accessor :z

  def initialize(x, y, z)
    super(x,y)
    @z = z
  end
  def distFromOrigin
    d = super
    Math.sqrt(d * d + @z * @z)
  end
  def distFromOrigin2
    d = super
    Math.sqrt(d * d + z * z)
  end
end
