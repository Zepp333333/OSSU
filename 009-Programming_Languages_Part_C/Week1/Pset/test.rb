def rotations (point_array)
    rotate1 = point_array.map {|x,y| [-y,x]}  
    rotate2 = point_array.map {|x,y| [-x,-y]} 
    rotate3 = point_array.map {|x,y| [y,-x]}  
    [point_array, rotate1, rotate2, rotate3]  
  end


A = [[[0, 0], [1, 1], [2, 2]]]
B = [[[3,3], [4,4], [5,5]]]
L = [[0, 0], [0, -1], [0, 1], [1, 1]]

r = rotations(L)




