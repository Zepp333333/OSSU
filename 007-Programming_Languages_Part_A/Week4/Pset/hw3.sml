(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

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

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)

(*Problem 1*)
fun only_capitals xs =
(* string list -> string list
Produce list_of_string that contains only strings strating with uppercase letter from imput list.
Assume: all string have at least 1 char
	-xs : string list *)
	List.filter (fn x => Char.isUpper(String.sub(x, 0))) xs

(*Problem 2*)
fun longest_string1 xs =
(* string list -> string
Produce first longest string from provided list or "" if list is empty
	-xs : string list *)
	foldl (fn (x, acc) => if String.size x > String.size acc then x else acc) "" xs

(*Problem 3*)
fun longest_string2 xs =
(* string list -> string
Produce last longest string from provided list or "" if list is empty
	-xs : string list *)
	foldl (fn (x, acc) => if String.size x >= String.size acc then x else acc) "" xs

(*Problem 4*)
fun longest_string_helper f xs =
(* fn(int*int->bool) -> string list -> string
Produce string list containing subset of provided list cotaining only items that produce true when f is applied
	-f  : fn (int*int->bool)
	-xs : string list *)
	foldl (fn (x, acc) => if f(String.size x, String.size acc) then x else acc) "" xs

val longest_string3 = longest_string_helper (fn (x, y) => x > y)
(* fn: string list -> string
Produce first longest string from provided list or "" if list is empty *)


val longest_string4 = longest_string_helper (fn (x, y) => x >= y)
(* fn: string list -> string
Produce last longest string from provided list or "" if list is empty *)

(*Problem 5*)
val longest_capitalized = longest_string3 o only_capitals
(*fn: string list -> string
Produce first longest string that starts with capital char from provided string list
Assime all strings are at least 1 char long*)


(*Problem 6*)
val rev_string = String.implode o List.rev o String.explode
(*fn: string -> string
Produce string where chars are in reverse order vs provided string*)

(*Problem 7*)
fun first_answer f xs =
(* ('a -> 'b option) -> 'a list -> 'b
Produce first v if f(v) produces SOME v. If f(v) produces NONE for all v -> raise NoAnswer
	- f  : fn (a -> b option)
	- xs : a list *)
	case xs of
		[] => raise NoAnswer
	| x::xs' => case (f x) of
			SOME v => v
		| NONE => first_answer f xs'

(*Problem 8*)
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

(*Problem 9a*)
val count_wildcards = g (fn () => 1) (fn x => 0)
(* pattern -> int
Produce how many Wildcards pattern p contains*)

(*Problem 9b*)
val count_wild_and_variable_lengths = g (fn () => 1) (fn x => String.size x)
(* pattern -> int
Produce number of Wildcard patterns in Pattenr p plus the sum of the string lengths of all the variables
in the variable patterns it contains.*)

(*Problem 9c*)
fun count_some_var (n,p) = g (fn () => 0) (fn x => if x = n then 1 else 0) p
(* String * Pattern -> int
Produce number of times the string appears as a variable in pattern p.
	-n : string representing variable name
	-p : pattern*)

(*Problem 10*)
fun check_pat p =
(* pattern -> bool
Produce true if all variables in the pattern p are distinct (do not repeat)
	-p : pattern *)
	let fun patternToLos (x) = case x of
			    Variable x => [x]
			  | TupleP ps => List.foldl (fn (rest, acc) => acc@patternToLos(rest)) [] ps
			  | (_) => []
			fun has_repeats xs = case xs of
			    [] => false
			  |	x::xs' => (List.exists (fn(y) => y = x) xs') orelse has_repeats xs'
	in
		not (has_repeats (patternToLos p))
	end

(*Problem 11*)
fun match (v, p) =
(* valu * pattern -> (string * valu) list option
Produce NONE if pattern doesn't match and SOME lst where lst is the list of bindings if it does.
*)
	case (p, v) of
		(Wildcard,_) => SOME []
	| (Variable s,_) => SOME [(s, v)]
	| (UnitP, Unit) => SOME []
	| (ConstP i, Const j) => if i = j then SOME [] else NONE
	|	(TupleP ps, Tuple vs) => if List.length ps = List.length vs
															then all_answers ((fn (x,y) => match(x,y))) (ListPair.zip (vs,ps))
															else NONE
	| (ConstructorP (s1, pp), Constructor (s2, pv)) => if s1 = s2
																											then match(pv, pp)
																											else NONE
	|_ => NONE


(*Problem 12*)
fun first_match v ps =
(*valu -> pattern list -> (string * valu) list option
Produce NONE if no pattern in the list matches or SOME lst where
lst is the list of bindings for therst pattern in the list that matches.
	-v : valu
	-ps : pattern list *)
	SOME (first_answer (fn p => match(v,p)) ps) handle NoAnswer => NONE
