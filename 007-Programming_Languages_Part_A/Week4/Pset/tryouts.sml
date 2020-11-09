datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

 datatype valu = Const of int
 	      | Unit
 	      | Tuple of valu list
 	      | Constructor of string * valu

val p = TupleP [Wildcard, ConstP 3, Wildcard, UnitP, Wildcard]

fun g f1 f2 p =
    let
	val r = g f1 f2
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

val p = TupleP [ConstP 1, Wildcard, Variable "xy", Wildcard, Variable "x3y", Wildcard, Variable "kjkj", Variable "xy"]

fun patternToLos (x) =
  case x of
    Variable x => [x]
  | TupleP ps => List.foldl (fn (rest, acc) => acc@patternToLos(rest)) [] ps
  | (_) => []

val str = patternToLos(p)

val res = List.exists (fn(y) => y = "x1") str

fun has_repeats xs =
  case xs of
    [] => false
  |	x::xs' => (List.exists (fn(y) => y = x) xs') orelse has_repeats xs'

val res2 = has_repeats str

fun all_answers f xs =
(*('a -> 'b list option) -> 'a list -> 'b list option
Produce NONE if f(x) produce NONE for any element of xs. Else if f(x) produce
SOME list for all elements of x -> produce SOME list containing all lists from
applying f to all elements of xs. Note: all_answers f [] = SOME []
	- f  : fn (a -> b list option)
	- xs : a list *)
	let fun aux acc lst = case lst of
				[] => SOME acc
			|	head::tail => case f head of
					NONE => NONE
				|	SOME i => aux (i@acc) tail
	in aux [] xs end

val pairs = ListPair.zip ([1,2,3],[1,2,3])

val res3 = all_answers (fn (x,y) => if x = y then SOME [x] else NONE) (ListPair.zip ([1,2,3],[1,2,3]))
