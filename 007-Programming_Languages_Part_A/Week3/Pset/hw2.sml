(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* PROBLEM 1 *)

(* (a) *)

fun all_except_option (x, xs) =
(* string list_of_string -> string_list_option
Produce NONE if x not in xs, else produce list_of_string identical to xs except x not in it.
Assume x is in xs at most once.
  - x: string
  - xs: list_of_strings  *)
  let fun aux (ys) =
      case ys of
        [] => []
      | y::ys' => if same_string(x, y) then aux(ys') else y::aux(ys')
      val result = aux(xs)
  in if result = xs then NONE else SOME result
  end

(* (b) *)

fun get_substitutions1 (xxs, s) =
(* lisf_of_list_of_string string -> list_of_string
Produce list_of_string that contains all the strings from some list in xxs that also has s, but result doesn't
contain s itself. ex:
    get_substitutions1([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]],"Jeff") ->
    -> ["Jeffrey","Geoff","Jeffrey"]
Assume: each list in substitutions has no repeats
  - xxs: lisf_of_list_of_string
  - s  : string *)
  case xxs of
    [] => []
  | head::tail =>  case all_except_option(s, head) of
                     NONE => get_substitutions1(tail, s)
                   | SOME r => r @ get_substitutions1(tail, s)


(* (c) *)

fun get_substitutions2 (xxs, s) =
(* lisf_of_list_of_string string -> list_of_string
Tail recursive version of get_substitutions1. Produce list_of_string that contains all the strings
from some list in xxs that also has s, but result doesn't contain s itself. ex:
    get_substitutions1([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]],"Jeff") ->
    -> ["Jeffrey","Geoff","Jeffrey"]
Assume: each list in substitutions has no repeats
  - xxs: lisf_of_list_of_string
  - s  : string *)
  let fun aux (llos, acc) =
    case llos of
      [] => acc
    | head::tail =>  case all_except_option(s, head) of
                       NONE => aux(tail, acc)
                     | SOME r => aux(tail, acc @ r)
  in aux(xxs, [])
  end


(* (d) *)

fun similar_names(xxs, fname) =
(* list_of_list_of_string record -> list_of_records
Returns list of records containing full names produced by substituting the first name using substituions from xxs
- xxs   : lisf_of_list_of_string - represent list of lists of possible substitutions
- fname : {first:string,middle:string,last:string} - represent full name*)
  let val {first=f, last=l, middle=m} = fname
      val subs = get_substitutions2(xxs, f)
      fun make_lists (subs, acc) =
        case subs of
          [] => acc
        | head::tail => make_lists(tail, acc @ {first=head, last=l, middle=m}::[])
  in make_lists(subs, fname::[]) end


(*-------------------------------------------------------------------------------*)

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw

exception IllegalMove

(* PROBLEM 2 *)

(* (a) *)

fun card_color (card) =
(* card -> card_color
Produce color based on provided card
  - card : card = suit * rank *)
  case card of
    (Spades,_) => Black
  | (Clubs,_) => Black
  | (_,_) => Red

(* (b) *)

fun card_value(card) =
(* card -> int
Produce card's value (numbered cards have their number as the value, aces are 11, everything else is 10).
  - card : card = suit * rank *)
  case card of
    (_,Ace) => 11
  | (_, Num i) => i
  | (_,_) => 10


(* (c) *)

fun remove_card (cs, c, e) =
(* list_of_card card exception -> list_of_card
Produce list_of_card that has all elements of cs except first occurance of c. If no c in cs -> raise exception e
  - cs  : card list
  - c : card = suit * rank
  - e : exception *)
  let fun aux (ys) =
      case ys of
        [] => []
      | y::ys' => if y = c then ys' else y::aux(ys')
      val result = aux(cs)
  in if result <> cs then result else raise e
  end

(* (d) *)

fun all_same_color (cs) =
(* list_of_card -> bool
Produce true of all cards in the list are of the same color, otherwise - false
  - cs  : card list *)
  case cs of
    []    => true
  | c::[] => true
  | head::(neck::tail) => card_color(head) = card_color(neck)
                          andalso all_same_color(neck::tail)

(* (e) *)

fun sum_cards (cs) =
(* list_of_card -> int
Produce sum of values of the cards in the provided list. Tail recursive
  - cs  : card list *)
  let fun aux (cs, acc) =
    case cs of
      [] => acc
    | c::cs' => aux(cs', acc + card_value(c))
  in aux (cs, 0) end

(* (f) *)

fun score(held_cards, goal) =
(* list_of_card int -> int
Produce score based on provided list_of_card and goal
  - held_cards  : card list
  - goal : int*)
  let fun p_score (sum) =
    if sum > goal then  3 * (sum - goal) else  goal - sum
  in
    case all_same_color(held_cards) of
      true => p_score(sum_cards(held_cards)) div 2
    | false => p_score(sum_cards(held_cards))
  end

(* (g) *)

fun officiate (card_list, move_list, goal) =
(* list_of_card list_of_move int -> int
Produce int score of the game at the end based on game rules.
  - card_list  : card list
  - move_list  : move list
  - goal : int *)
  let
    fun state (card_list, move_list, held_cards) =
      if sum_cards(held_cards) > goal then score(held_cards, goal) else
        case move_list of
          []         => score(held_cards, goal)
        | move::move_list' =>
            case move of
              Discard c => state(card_list, move_list', remove_card(held_cards, c, IllegalMove))
            | Draw      =>
                case card_list of
                  [] => score(held_cards, goal)
                | card::card_list' => state(card_list', move_list', card::held_cards)
  in
    state(card_list, move_list, [])
  end
