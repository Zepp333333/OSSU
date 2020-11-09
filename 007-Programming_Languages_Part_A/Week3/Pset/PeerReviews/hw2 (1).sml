(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_element(s1, s2) =
    s1 = s2

(* put your solutions for problem 1 here *)

fun elementPresent(str, list)=
      case (str, list) of
        (_, []) => false
      | (str, xs::xs') =>  if same_element(str, xs) 
                          then true else elementPresent(str, xs')                              

fun getElements(str, list)= 
      case (str, list) of
        (str, []) => []
        | (str, xs::xs')  => if same_element(str, xs) then getElements(str, xs') else xs :: getElements(str, xs')

fun all_except_option(str, list) = 
    if elementPresent(str, list)
      then SOME(getElements(str, list))
      else NONE
  (* all_except_option("hi",["str","hi","hoi"]); *)

fun get_substitutions1(strLists, str)=
  case (strLists, str) of 
      ([], _) => []
    | (xs::xs',str) => if elementPresent(str, xs) 
                          then getElements(str, xs) @ get_substitutions1(xs', str)
                          else get_substitutions1(xs', str)

(* get_substitutions1([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],"Fred"); *)
(* get_substitutions1([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]],"Jeff") *)

fun get_substitutions2(strLists, str)=
  let
    fun helper(strLists, str, newList)=
      case (strLists, str, newList) of
        ([], _, _) => newList
      | (xs::xs', str, newList) => if elementPresent(str, xs)
                                  then newList @ getElements(str, xs) @ helper(xs', str, newList)
                                  else helper(xs', str, newList)
  in
    helper(strLists, str, [])
  end
(* get_substitutions2([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],"Fred"); *)

fun similar_names(strLists, fullNames)=
  let
    fun createNames(strList, fullNames, nameList)=
      case (strList, fullNames, nameList) of
        ([],_,_) => nameList
      | (xs::xs', {first=fs,middle=mn,last=ln}, nameList) => {first= xs,middle= mn,last=ln} :: createNames(xs', fullNames, nameList)
    fun helper(strLists, fullNames, nameList)=
      case (strLists, fullNames, nameList) of
        ([], _, _) => nameList
      | (xs::xs', {first=fs,middle=mn,last=ln}, nameList) => createNames(get_substitutions2(strLists, fs),fullNames, nameList)
  in
    helper(strLists, fullNames, [fullNames])
  end
(* similar_names([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],{first="Fred", middle="W", last="Smith"}) *)
(* [{first="Fred", middle="W", last="Smith"}] *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank
datatype color = Red | Black
datatype move = Discard of card | Draw 
exception IllegalMove

(* put your solutions for problem 2 here *)

fun card_color(card)=
  case (card) of 
    ((Clubs | Spades),_) => Black
  | ((Diamonds | Hearts),_) => Red 

  (* card_color(Clubs,Jack); *)

fun card_value(card)=
  case card of 
    (_,Ace) => 11
  | (_,(Jack | Queen | King)) => 10
  | (_,Num(xs)) => xs

fun removeOneCard(card, cardList)=
  let
    fun helper(str, list, newList, isRemoved)=
      case (str, list, newList, isRemoved) of
        (str, [], _, _) => newList
      | (str, xs::xs', _, _)  => if isRemoved then xs :: helper(str, xs', newList, isRemoved)
                           else if same_element(str, xs) then helper(str, xs',newList,true) 
                           else xs :: helper(str, xs', newList, isRemoved)
  in
    helper(card, cardList, [], false)
  end
  (* removeOneCard((Clubs,Ace),[(Clubs,Ace),(Diamonds,Jack)]); *)

fun remove_card(cardList, card, e)=
  case (cardList, card, e) of
    ([],c,e) => raise e
  | (_,_,_) => if elementPresent(card, cardList)
                   then removeOneCard(card, cardList)
                   else raise e                  
(* remove_card([(Clubs,Ace),(Clubs,Ace),(Diamonds,Jack)],(Clubs,Ace),IllegalMove); *)

fun all_same_color(cardList)=
  case cardList of
    []  => true
  | (_::[])  => true
  | xs::(rest::rest') => card_color(xs) = card_color(rest) andalso all_same_color(rest::rest')
(* all_same_color([(Clubs,Ace),(Spades,Num(5))]) *)

fun sum_cards(cardList)=
  let
    fun helper(cardList, sum)=
      case (cardList,sum) of
        ([],_) => sum
      | (xs::xs',sum) => helper(xs', sum + card_value(xs))
  in
    helper(cardList, 0)
  end
  (* sum_cards([(Clubs,Ace),(Spades,Jack),(Diamonds,Num(8))]) *)

fun score(cardList, goal)=
  let
    fun helper(cardList, goal, sum)=
      if sum > goal andalso all_same_color(cardList) then (3 * (sum - goal)) div 2
        else if sum > goal then (3 * (sum - goal)) 
        else if all_same_color(cardList) then (goal-sum) div 2
        else goal-sum
  in
    helper(cardList, goal, sum_cards(cardList))
  end
(* score([(Clubs,Ace),(Spades,Jack),(Diamonds,Num(1))],30) *)
(* score([(Clubs,Ace),(Spades,Jack),(Spades,Num(8))],11) *)

fun draw_card1(cardList,e)=
      case (cardList,e) of
        ([],e) => raise e
      | (xs::_,_) => xs

fun officiate(cardList, moveList, goal)=
  let
    fun top_card(cardList,e)=
      case (cardList,e) of
        ([],e) => raise e
      | (xs::_,_) => xs
    fun helper(moveList, currentCardList,cardList, goal)=
      case (moveList, currentCardList, cardList, goal) of
      (* (ms,ls,[],goal) *)
        ([],_,_,_) => score(currentCardList, goal)
      | (Draw::_,_,[],_) => score(currentCardList, goal)
      | (move::moves',_,_,goal) => ( case (move) of
                                (Discard(card)) => helper(moves', remove_card(currentCardList, card, IllegalMove), cardList, goal)
                              | (Draw) => helper(moves', top_card(cardList, IllegalMove) :: currentCardList, remove_card(cardList, top_card(cardList, IllegalMove), IllegalMove) ,goal) 
                              )
      (* | ([],[],[],goal) => score(currentCardList, goal) *)

      
      
  in                        
    helper(moveList,[],cardList, goal)
  end

  (* officiate([(Clubs,Ace),(Spades,Jack),(Spades,Num(8))],[Draw, Discard(Clubs,Ace)], 10); *)
  (* val tst1 = officiate([(Clubs,Ace),(Spades,Jack),(Spades,Num(8))],[Draw, Draw, Draw, Discard(Clubs,Ace)], 10) = 12 *)
  (* val tst2 = officiate([(Clubs,Ace),(Spades,Jack),(Spades,Num(8))],[Draw, Draw, Draw, Discard(Clubs,Ace),Discard(Spades,Num(8))], 10) = 0  *)
  (* val tst3= officiate([(Clubs,Ace),(Spades,Jack),(Spades,Num(8))],[Draw, Draw, Draw, Discard(Clubs,Ace),Discard(Spades,Jack)], 10) = 1 *)
  (* val tst3= officiate([(Clubs,Ace),(Spades,Jack),(Spades,Num(8))],[Draw, Draw, Draw, Discard(Clubs,Ace),Discard(Spades,Jack),Discard(Spades,Num(8))], 10) = 5 *)
  (* officiate ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],[Draw,Draw,Draw,Draw,Draw],42); *)
  (* officiate([],[Discard(Clubs,Ace)], 10); *)
  (* officiate([],[Draw], 10); *)


(* fun score_challenge *)

fun remove_card (cs,c,e) =
    case cs of
	      [] => raise e
      | x::cs' => if x = c then cs' else x :: remove_card(cs',c,e)
