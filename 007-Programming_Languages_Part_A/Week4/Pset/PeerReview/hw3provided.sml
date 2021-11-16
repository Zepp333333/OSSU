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

(* Problem 1. *)
val only_capitals = List.filter (fn x => (Char.isUpper o String.sub) (x,0))

(* Problem 2. *)
val longest_string1 = List.foldl (fn (s,acc) =>
				     if String.size s > String.size acc
				     then s
				     else acc) ""

(* Problem 3. *)
val longest_string2 = List.foldl (fn (s,acc) =>
				     if String.size s >= String.size acc
				     then s
				     else acc) ""

(* Problem 4.*)
fun longest_string_helper f =
    List.foldl (fn (s,acc) => if f (String.size s,String.size acc)
			      then s
			      else acc) ""

val longest_string3 = longest_string_helper (fn (a,b) => a > b)

val longest_string4 = longest_string_helper (fn (a,b) => a >= b)

(* Problem 5. *)
val longest_capitalized = longest_string1 o only_capitals

(* Problem 6. *)
val rev_string = String.implode o List.rev o String.explode

(* Problem 7. *)
fun first_answer f lst =
    case lst of
	[] => raise NoAnswer
      | x::xs => case f x of NONE => first_answer f xs
			   | SOME v => v

(* Problem 8. *)
fun all_answers f lst =
    let
	fun aux lst acc =
	    case lst of
		[] => SOME acc
	      | x::xs => case f x of
			    NONE => NONE
			  | SOME lst' => aux xs (lst' @ acc)
    in
	aux lst []
    end

(* Problem 9. *)
(* a *)
val count_wildcards = g (fn () => 1) (fn _ => 0)

(* b *)
val count_wild_and_variable_lengths =
    g (fn () => 1) String.size

(* c *)
fun count_some_var (s,ptrn) =
    g (fn () => 0) (fn x => if s = x then 1 else 0) ptrn

(* Problem 10. *)
fun check_pat ptrn =
    let
	fun create_list ptrn =
	    case ptrn of
		Variable x => [x]
	      | TupleP ps =>
		List.foldl (fn (p,acc) => create_list p @ acc) [] ps
	      | ConstructorP(_,p) => create_list p
	      | _ => []
	fun is_unique lst =
	    case lst of
		[] => true
	      | x::xs => List.all (fn e => e <> x) xs andalso is_unique xs
    in
	(is_unique o create_list) ptrn
    end

(* Problem 11. *)
fun match (vlue,ptrn) =
    case (vlue,ptrn) of
	(_,Wildcard) => SOME []
      | (_,Variable s) => SOME [(s,vlue)]
      | (Unit,UnitP) => SOME []
      | (Const v1,ConstP v2) => if v1 = v2 then SOME [] else NONE
      | (Constructor (s1,v),ConstructorP (s2,p)) =>
	if s1 = s2 then match(v,p)
	else NONE
      | (Tuple vs,TupleP ps) =>
	if List.length vs <> List.length ps then NONE
	else (all_answers match o ListPair.zip) (vs,ps)
      | _ => NONE

(* Problem 12. *)
fun first_match vlue lst =
    SOME (first_answer (fn x => match(vlue,x)) lst)
    handle NoAnswer => NONE
