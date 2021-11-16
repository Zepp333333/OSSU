(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)
fun all_except_option (s1, ls) =
  case ls of
       [] => NONE
     | s2::ls => if same_string (s1 ,s2)
                 then SOME(ls)
                 else case all_except_option(s1, ls) of
                           NONE => NONE
                         | SOME ls => SOME (s2::ls)

fun get_substitutions1 (xss, s) =
  case xss of
       [] => []
     | xs::xss => case all_except_option(s, xs) of
                       NONE => get_substitutions1 (xss, s)
                     | SOME ls => ls @ get_substitutions1 (xss, s)

fun get_substitutions2 (xss, s) =
  let
    fun tail (xss, s, acc) =
      case xss of
           [] => acc
         | xs::xss => case all_except_option (s, xs) of
                           NONE => tail (xss, s, acc)
                         | SOME ls => tail (xss, s, ls @ acc)
  in
    tail (xss, s, [])
  end

fun similar_names (xss, fullname) =
  let
    val {first=x, middle=y, last=z} = fullname
    fun aux (xs, acc) =
      case xs of
           [] => acc
         | s::xs => {first=s, middle=y, last=z} :: aux (xs, acc)
  in
    fullname :: aux (get_substitutions1 (xss, x), [])
  end

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)

fun card_color (suit, rank) =
  case suit of
       Clubs => Black
     | Spades => Black
     | _ => Red

fun card_value (suit, rank) =
  case rank of
       Num n => n
     | Ace => 11
     | _ => 10

fun remove_card (cs, c, e) =
  case cs of
       [] => raise e
     | x :: xs => if x = c
                  then xs
                  else x :: remove_card (xs, c, e)

fun all_same_color (cards) =
  case cards of
       [] => true
     | [_] => true
     | c1 :: c2 :: cs => card_color c1 = card_color c2 andalso all_same_color (c2 :: cs)

fun sum_cards (cards) =
  let
    fun sum_acc (cards, acc) =
      case cards of
           [] => acc
         | c :: cs => sum_acc (cs, card_value c + acc)
  in
    sum_acc (cards, 0)
  end

fun score (cards, goal) =
  let
    val sum = sum_cards (cards)
    val rate = if all_same_color (cards) then 2 else 1
  in
    if sum <= goal
    then (goal - sum) div rate
    else 3 * (sum - goal) div rate
  end

fun officiate (cards, moves, goal) =
  let
    fun aux (cards, moves, goal, helds) =
      case moves of
           [] => score (helds, goal)
         | Draw :: ms => (case cards of
                               [] => score (helds, goal)
                             | c::cs => if sum_cards (c::helds) > goal
                                        then score (c::helds, goal)
                                        else aux (cs, ms, goal, c::helds))
         | Discard c :: ms =>
             aux (cards, ms, goal, remove_card (helds, c, IllegalMove))
  in
    aux (cards, moves, goal, [])
  end

