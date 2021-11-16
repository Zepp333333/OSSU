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


fun only_capitals sl =
    List.filter(fn (v) => Char.isUpper(String.sub(v, 0))) sl

fun longest_string1 sl =
    List.foldl (fn (candidate, best) => (if (String.size(candidate) > String.size(best)) then candidate else best)) "" sl 

fun longest_string2 sl =
    List.foldl (fn (candidate, best) => (if (String.size(candidate) >= String.size(best)) then candidate else best)) "" sl 

fun longest_string_helper f sl =
    List.foldl (fn (candidate, best) => if f(String.size(candidate), String.size(best)) then candidate else best) "" sl

fun longest_string3 sl =
    let
	val partial = longest_string_helper(fn (candidate, best) => candidate > best)
    in
	partial sl
    end
    
fun longest_string4 sl =
    let
	val partial = longest_string_helper(fn (candidate, best) => candidate >= best)
    in
	partial sl
    end
	
fun longest_capitalized sl =
    let
	val firstUpper = Char.isUpper o String.sub
				      
    in
	List.foldl (fn (candidate, best) =>
		       if ((String.size(candidate) > String.size(best))
			  andalso (firstUpper (candidate, 0)))
		       then candidate
		       else best) "" sl
		   
    end
	

fun rev_string sl =
    (String.implode o List.rev o String.explode) sl

fun first_answer f sl =
    case sl of
	[] => raise NoAnswer
      | first::sl' =>
	case f first of
	    NONE => first_answer f sl'
	  | SOME v => v

fun all_answers f sl =
    let
	fun helper (acc, ff, slist) =
	    case slist of
		[] => SOME acc
	      | first::slist' => case ff first of
				  NONE => NONE
				| SOME elt => helper (acc@elt, ff, slist')
    in
	helper ([], f, sl)
    end
	

fun count_wildcards pt =
    g (fn x => 1) (fn x => 0) pt

fun count_wild_and_variable_lengths pt =
    g (fn x => 1) (fn x => String.size(x)) pt

fun count_some_var (str, pt) =
    g (fn x => 0) (fn x => if (x = str) then 1 else 0) pt

fun check_pat pt =
    let
	fun  getAllStrings (pt) =
	     case pt of
		 Variable x        => [x]
	       | TupleP ps         => List.foldl (fn (p,i) => getAllStrings(p)@i) [] ps
	       | ConstructorP(_,p) => getAllStrings(p)
	       | _ => []
					  
	fun hasNoRepeats (stringList) =
	    case stringList of
		[] => true
	      | str::stringList' => if (List.exists (fn (elt) => (str = elt)) stringList') then false
					else hasNoRepeats(stringList')
    in
	(hasNoRepeats o getAllStrings) pt
    end
	

fun match (v, p) =
    case p of
	Wildcard => SOME []
      | Variable x => SOME [(x, v)]
      | UnitP => (case v of Unit => SOME [] 
			  | _ => NONE)
      | ConstP x => (case v of Const c => if (c=x) then SOME[] else NONE 
			     | _ => NONE) 
      | TupleP ps => (case v of Tuple vlist => if (List.length(ps) <> List.length(vlist)) then NONE
					       else
						   let
						       val pairs = ListPair.zip(vlist, ps)
						   in
						       all_answers (fn (d, e) => match(d, e)) pairs
						   end
			      | _ => NONE)
			 
      | ConstructorP(s1, pt) => (case v of
				     Constructor(s2, vt) => if (s1 = s2)
							    then
								let
								    val mt = match(vt, pt)
								in
								    case mt of
									NONE => NONE
								      | SOME blist => SOME blist 
								end
							    else NONE
				   | _ => NONE)

fun first_match v plist =
    SOME (first_answer (fn (p) => match(v, p)) plist)
		 handle NoAnswer => NONE


	
