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
	     | Datatype of string;

(**** you can put all your code here ****)

(* 1 *)
fun only_capitals (words) =
    List.filter (fn x => Char.isUpper(String.sub(x,0))) words;

(* 2 *)
fun longest_string1 (strs) =
    List.foldl (fn (x,y) =>
		   if String.size(x) > String.size(y)
		   then x
		   else y)
	       "" strs;

(* 3 *)
fun longest_string2 (strs) =
    List.foldl (fn (x,y) => if String.size(x) >= String.size(y) then x else y) "" strs;

(* 4 *)
fun longest_string_helper f =
    fn s => List.foldl (fn (x,y) => if f (String.size(x),String.size(y)) then x else y) "" s;

val longest_string3 = longest_string_helper op > ;

val longest_string4 = longest_string_helper op >= ;

(* 5 *)
val longest_capitalized = longest_string3 o only_capitals;

(* 6 *)
val rev_string = String.implode o List.rev o String.explode;

(* 7 *)
fun first_answer f xs =
    case xs of
	[] => raise NoAnswer
      | x::xs' => case f x of
		      NONE => first_answer f xs'
		    | SOME y => y;

(* 8 *)
fun all_answers f xs =
    let fun aux (ys, acc) =
	    case ys of
		[] => SOME acc
	      | y::ys' => case f y of
			      NONE => NONE
			    | SOME z => aux(ys',acc @ z)
    in
	aux(xs,[])
    end;

(* 9a *)
val count_wildcards = g (fn x => 1) (fn x => 0);

(* 9b *)
val count_wild_and_variable_lengths = g (fn x => 1) (fn x => String.size(x));

(* 9c *)
fun count_some_var (str,pat) =
    g (fn x => 0) (fn x => if x = str then 1 else 0) pat;

(* 10 *)
fun check_pat (pat) =
    let fun var_strings pat =
	    case pat of
		Variable x => [x]
	      | TupleP ps  => List.foldl (fn (p,i) => (var_strings p) @ i) [] ps
	      | ConstructorP(_,p) => var_strings p
	      | _ => [] 
	fun no_repeats strs =
	    case strs of
		[] => true
	      | str::strs' => if List.exists (fn x => x = str) strs'
			      then false
			      else no_repeats(strs')
    in
	(no_repeats o var_strings) pat
    end;

(* 11 *)
fun match (v,pat) =
    case (v,pat) of
	(_,Wildcard) => SOME []
      | (_,Variable x) => SOME [(x,v)]
      | (Unit,UnitP) => SOME []
      | (Const(x),ConstP y) => if x = y then SOME [] else NONE
      | (Tuple vs,TupleP ps) => if List.length vs <> List.length ps
				then NONE
				else all_answers match (ListPair.zip(vs,ps))
      | (Constructor(s1,v'),ConstructorP(s2,p')) => if s1 = s2 then match(v',p') else NONE
      | (_,_) => NONE ;

(* 12 *)
fun first_match v ps =
    SOME (first_answer (fn x => match(v,x)) ps) handle NoAnswer => NONE;
