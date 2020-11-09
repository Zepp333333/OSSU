(* Homework3 Simple Test*)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)
use "hw3.sml";

val test1 = only_capitals ["A","B","C"] = ["A","B","C"]
val test11 = only_capitals ["A","b","C"] = ["A","C"]
val test12 = only_capitals ["a","b","c"] = []
val test13 = only_capitals [] = []

val test2 = longest_string1 ["A","bc","C"] = "bc"
val test21 = longest_string1 [] = ""
val test23 = longest_string1 ["A","bc","Cdd"] = "Cdd"
val test24 = longest_string1 ["A","bcc","Cdd"] = "bcc"


val test3 = longest_string2 ["A","bc","C"] = "bc"
val test31 = longest_string2 [] = ""
val test33 = longest_string2 ["A","bc","Cdd"] = "Cdd"
val test34 = longest_string2 ["A","bcc","Cdd"] = "Cdd"


val test4a = longest_string3 ["A","bc","C"] = "bc"
val test4a1 = longest_string3 [] = ""
val test4a2 = longest_string3 ["A","bc","Cdd"] = "Cdd"
val test4a3 = longest_string3 ["A","bcc","Cdd"] = "bcc"


val test4b = longest_string4 ["A","B","C"] = "C"
val test4b1 = longest_string4 [] = ""
val test4b2 = longest_string4 ["A","bc","Cdd"] = "Cdd"
val test4b3 = longest_string4 ["A","bcc","Cdd"] = "Cdd"

val test5 = longest_capitalized ["A","bc","C"] = "A"
val test51 = longest_capitalized [] = ""
val test52 = longest_capitalized ["A","bc","Ca"] = "Ca"
val test53 = longest_capitalized ["A","Bc","Cc"] = "Bc"
val test54 = longest_capitalized ["A","Bcc","cccc"] = "Bcc"

val test6 = rev_string "abc" = "cba"
val test61 = rev_string "a" = "a"
val test62 = rev_string "" = ""
val test63 = rev_string "abc abc" = "cba cba"

val test7 = first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3,4,5] = 4
val test71 = first_answer (fn x => if x > 2 then SOME x else NONE) [1,2,3,4,5] = 3
val test71 = first_answer (fn x => if x mod 2 = 0 then SOME x else NONE) [1,2,3,4,5] = 2

val test8 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [2,3,4,5,6,7] = NONE
val test81 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [] = SOME []
val test82 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [1, 2,3,4,5,6,7] = NONE
val test83 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [1, 1, 1] = SOME [1,1,1]


val test9a = count_wildcards Wildcard = 1
val test9a1 = count_wildcards (TupleP [ConstP 1, Wildcard, Variable "x", Wildcard, UnitP, Wildcard]) = 3

val test9b = count_wild_and_variable_lengths (Variable("a")) = 1
val test9b1 = count_wild_and_variable_lengths (TupleP [ConstP 1, Wildcard, Variable "x", Wildcard, UnitP, Wildcard]) = 4
val test9b1 = count_wild_and_variable_lengths (TupleP []) = 0
val test9b1 = count_wild_and_variable_lengths (TupleP [ConstP 1, Wildcard, Variable "xy", Wildcard, Variable "x3y", Wildcard]) = 8

val test9c = count_some_var ("x", Variable("x")) = 1
val test9c1 = count_some_var ("x", Variable("y")) = 0
val test9c2 = count_some_var ("x", TupleP [ConstP 1, Wildcard, Variable "x", Wildcard, Variable "x", Wildcard]) = 2
val test9c3 = count_some_var ("x", TupleP []) = 0

val test10 = check_pat (Variable("x")) = true
val test101 = check_pat (Wildcard) = true
val test102 = check_pat (TupleP [ConstP 1, Wildcard, Variable "xy", Wildcard, Variable "x3y", Wildcard, Variable "kjkj", Variable "xy"]) = false
val test103 = check_pat (TupleP [ConstP 1, Wildcard, Variable "xy", Wildcard, Variable "x3y", Wildcard, Variable "kjkj", Variable "xyd"]) = true


val test11 = match (Const(1), UnitP) = NONE
val test111 = match (Const(1), ConstP(1)) = SOME []
val test112 = match (Const(1), Wildcard) = SOME []


val test12 = first_match Unit [UnitP] = SOME []
