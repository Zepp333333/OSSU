class A
    attr_accessor :x
    def m1
      @x = 4
    end
    def m2
      m1
      @x > 4
    end
    def m3
      @x = 4
      @x > 4
    end
    def m4
      self.x = 4
      @x > 4
    end
  end

class B < A 
    attr_accessor :x
    def m1
        @x = 3
    end
end

