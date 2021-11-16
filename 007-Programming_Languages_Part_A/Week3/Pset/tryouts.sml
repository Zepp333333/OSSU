datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw

exception IllegalMove

val c = (Clubs, Num 2)

let fun gen_lists (held_cards, acc) =
  case held_cards of
    [] => acc
  | (_, Ace)::rest =>  gen_lists(rest, (Num(1)::rest)::(Ace::rest)::acc)
  | head :: rest => gen_lists(rest)

val lst = [(Clubs,Ace),(Spades,Ace),(Clubs,10),(Spades,Ace)]
