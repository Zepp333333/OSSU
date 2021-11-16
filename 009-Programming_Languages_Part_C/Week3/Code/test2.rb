class MyRange
    include Enumerable
    def initialize(low,high)
      @low = low
      @high = high
    end
    def each
      i=@low
      while i <= @high
        yield i
        i=i+1
      end
    end
  end

puts MyRange.new(4,2).any? {|i| i <= 4}