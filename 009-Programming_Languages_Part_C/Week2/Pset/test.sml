use "hw7.sml";
fun real_equal(x,y) = Real.compare(x,y) = General.EQUAL;

(* Preprocess tests *)
let
	val Point(a,b) = Point(3.2,4.1)
	val Point(c,d) = Point(3.2,4.1)
in
	if real_equal(a,c) andalso real_equal(b,d)
	then (print "preprocess converts a LineSegment to a Point successfully\n")
	else (print "preprocess does not convert a LineSegment to a Point succesfully\n")
end;
