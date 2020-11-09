(* Homework2 Simple Test *)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

use "hw2provided.sml";

val test01 = all_except_option ("string", ["string"]) = SOME []
val test02 = all_except_option ("", ["string"]) = NONE
val test03 = all_except_option ("string", []) = NONE
val test05 = all_except_option ("string", ["string", "a"]) = SOME ["a"]
val test06 = all_except_option ("string", ["string", "a", "b"]) = SOME ["a", "b"]
val test07 = all_except_option ("string", [ "a","string", "b"]) = SOME ["a", "b"]
val test08 = all_except_option ("string", ["a", "b", "string"]) = SOME ["a", "b"]
val test09 = all_except_option ("s", ["a", "b", "string"]) = NONE
val test10 = all_except_option ("", ["a", "", "string"]) = SOME ["a", "string"]

val test2 = get_substitutions1 ([["foo"],["there"]], "foo") = []
val test21 = get_substitutions1 ([], "") = []
val test22 = get_substitutions1 ([[]], "") = []
val test23 = get_substitutions1 ([[],[]], "") = []
val test24 = get_substitutions1 ([[""]], "") = []
val test25 = get_substitutions1 ([["", "foo"]], "") = ["foo"]
val test26 = get_substitutions1 ([["", "foo"],[""]], "") = ["foo"]
val test27 = get_substitutions1 ([["", "foo"],["", "bar"]], "") = ["foo","bar"]
val test28 = get_substitutions1 ([["", "foo"],["", "bar"],["foo",""]], "") = ["foo","bar","foo"]

val test3 = get_substitutions2 ([["foo"],["there"]], "foo") = []
val test31 = get_substitutions2 ([], "") = []
val test32 = get_substitutions2 ([[]], "") = []
val test33 = get_substitutions2 ([[],[]], "") = []
val test34 = get_substitutions2 ([[""]], "") = []
val test35 = get_substitutions2 ([["", "foo"]], "") = ["foo"]
val test36 = get_substitutions2 ([["", "foo"],[""]], "") = ["foo"]
val test37 = get_substitutions2 ([["", "foo"],["", "bar"]], "") = ["foo","bar"]
val test38 = get_substitutions2 ([["", "foo"],["", "bar"],["foo",""]], "") = ["foo","bar","foo"]


val test4 = similar_names ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]], {first="Fred", middle="W", last="Smith"}) =
	    [{first="Fred", last="Smith", middle="W"}, {first="Fredrick", last="Smith", middle="W"},
	     {first="Freddie", last="Smith", middle="W"}, {first="F", last="Smith", middle="W"}]
val test41 = similar_names ([], {first="a", middle="b", last="c"}) = [{first="a", last="c", middle="b"}]
val test42 = similar_names ([], {first="", middle="", last=""}) = [{first="", last="", middle=""}]
val test43 = similar_names ([], {first="a", middle="b", last="c"}) = [{first="a", last="c", middle="b"}]
val test44 = similar_names ([["z", "x", "t"]], {first="a", middle="b", last="c"}) = [{first="a", last="c", middle="b"}]
val test45 = similar_names ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"], ["ff", "Fred", "F"]], {first="Fred", middle="W", last="Smith"}) =
	    [{first="Fred", last="Smith", middle="W"}, {first="Fredrick", last="Smith", middle="W"},
	     {first="Freddie", last="Smith", middle="W"}, {first="F", last="Smith", middle="W"},
			 {first="ff", last="Smith", middle="W"}, {first="F", last="Smith", middle="W"}]

val test5 = card_color (Clubs, Num 2) = Black
val test51 = card_color (Spades, Num 2) = Black
val test52 = card_color (Diamonds, Num 2) = Red
val test53 = card_color (Hearts, Num 2) = Red



val test6 = card_value (Clubs, Num 2) = 2
val test61 = card_value (Clubs, Queen) = 10
val test62 = card_value (Diamonds, Num 10) = 10
val test63 = card_value (Hearts, Ace) = 11

val test7 = remove_card ([(Hearts, Ace)], (Hearts, Ace), IllegalMove) = []
val test71 = remove_card ([(Hearts, Ace),(Diamonds, Num 10)], (Hearts, Ace), IllegalMove) = [(Diamonds, Num 10)]
val test72 = remove_card ([(Hearts, Ace),(Diamonds, Num 10),(Hearts, Ace)], (Hearts, Ace), IllegalMove) = [(Diamonds, Num 10),(Hearts, Ace)]
val test73 = remove_card ([(Diamonds, Num 10),(Hearts, Ace),(Hearts, Ace)], (Hearts, Ace), IllegalMove) = [(Diamonds, Num 10),(Hearts, Ace)]
val test74 = remove_card ([(Diamonds, Num 10),(Hearts, Ace),(Clubs, King),(Hearts, Ace)], (Hearts, Ace), IllegalMove) = [(Diamonds, Num 10),(Clubs, King),(Hearts, Ace)]
(*val test7 = remove_card ([(Diamonds, Num 10),(Clubs, King)], (Hearts, Ace), IllegalMove) = [(Diamonds, Num 10),(Clubs, King),(Hearts, Ace)]*)

val test8 = all_same_color [(Hearts, Ace), (Hearts, Ace)] = true
val test81 = all_same_color [(Hearts, Ace), (Diamonds, Ace)] = true
val test82 = all_same_color [] = true
val test83 = all_same_color [(Hearts, Ace)] = true
val test84 = all_same_color [(Hearts, Ace), (Diamonds, Ace), (Clubs, Jack)] = false
val test85 = all_same_color [(Clubs, Jack),(Hearts, Ace), (Diamonds, Ace)] = false

val test9 = sum_cards [(Clubs, Num 2),(Clubs, Num 2)] = 4
val test91 = sum_cards [] = 0
val test92 = sum_cards [(Clubs, Num 2),(Clubs, Ace)] = 13
val test93 = sum_cards [(Clubs, Num 2),(Clubs, Ace), (Spades, King)] = 23

val test10 = score ([(Hearts, Num 2),(Clubs, Num 4)],10) = 4 (* sum < goal *)
val test11 = score ([(Hearts, Num 8),(Clubs, Num 4)],10) = 6 (* sum > goal *)
val test12 = score ([(Hearts, Num 6),(Clubs, Num 4)],10) = 0 (* sum = goal *)
val test13 = score ([(Hearts, Num 2),(Diamonds, Num 4)],10) = 2 (* sum < goal + color *)
val test14 = score ([(Hearts, Num 8),(Diamonds, Num 4)],10) = 3 (* sum > goal + color *)
val test15 = score ([(Hearts, Num 6),(Diamonds, Num 4)],10) = 0 (* sum = goal + color *)






val test110 = officiate ([(Hearts, Num 2),(Clubs, Num 4)],[Draw], 15) = 6

val test112 = officiate ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                        [Draw,Draw,Draw,Draw,Draw],
                        42)
             = 3

val test113 = ((officiate([(Clubs,Jack),(Spades,Num(8))],
                         [Draw,Discard(Hearts,Jack)],
                         42);
               false)
              handle IllegalMove => true)
