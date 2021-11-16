
class LineSegment
    attr_reader :x, :y
    def initialize(x, y)
        @x = x
        @y = y
    end
end

a = LineSegment.new(1, 2)
b = LineSegment.new(2, 3)

if a.x == b.x
    if a.y == b.y
        a
    else
        
