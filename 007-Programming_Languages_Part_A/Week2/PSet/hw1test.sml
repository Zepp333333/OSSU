(* Homework1 Simple Test *)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

use "pset1.sml";


val test10  = is_older ((1,2,3),(2,3,4)) = true
val test11 = is_older ((1,2,3),(1,2,3)) = false
val test12 = is_older ((2012,2,3),(2012,3,2)) = true
val test13 = is_older ((2012,2,3),(2012,2,1)) = false

val test20  = number_in_month ([(2012,2,28),(2013,12,1)],2) = 1
val test21 = number_in_month ([],3) = 0
val test22 = number_in_month ([(2012,2,28),(2013,12,1)],3) = 0
val test23 = number_in_month ([(2012,2,28),(2013,2,1)],2) = 2
val test24 = number_in_month ([(2012,2,28),(2013,2,1),(2014,3,3)],2) = 2

val test30  = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = 3
val test31 = number_in_months ([],[]) = 0
val test32 = number_in_months ([],[2,3,4]) = 0
val test33 = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[]) = 0
val test34 = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2]) = 1
val test35 = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,12,3,4]) = 4
val test36 = number_in_months ([(2012,2,28),(2013,2,1),(2011,2,31),(2011,2,28)],[3]) = 0
val test37 = number_in_months ([(2012,2,28),(2013,2,1),(2011,2,31),(2011,2,28)],[2]) = 4


val test40 = dates_in_month ([(2012,2,28),(2013,12,1)],2) = [(2012,2,28)]
val test41 = dates_in_month ([],2) = []
val test42 = dates_in_month ([(2012,2,28),(2013,12,1)],3) = []
val test43 = dates_in_month ([(2012,2,28),(2013,2,1)],2) = [(2012,2,28),(2013,2,1)]
val test44 = dates_in_month ([(2012,2,28),(2011,3,5),(2013,2,1)],2) = [(2012,2,28),(2013,2,1)]

val test50 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = [(2012,2,28),(2011,3,31),(2011,4,28)]
val test51 = dates_in_months ([],[]) = []
val test52 = dates_in_months ([],[2,3,4]) = []
val test53 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[]) = []
val test54 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[5]) = []
val test55 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[5,6]) = []
val test56 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,5,6]) = [(2012,2,28)]
val test57 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4,12]) = [(2012,2,28),(2011,3,31),(2011,4,28),(2013,12,1)]

val test60  = get_nth (["hi", "there", "how", "are", "you"], 2) = "there"
val test61 = get_nth (["hi", "there", "how", "are", "you"], 1) = "hi"
val test62 = get_nth (["hi", "there", "how", "are", "you"], 5) = "you"

val test7 = date_to_string (2013, 6, 1) = "June 1, 2013"

val test8  = number_before_reaching_sum (10, [1,2,3,4,5]) = 3
val test81 = number_before_reaching_sum (3, [4,2,3,4,5]) = 0
val test82 = number_before_reaching_sum (10, []) = 0
val test83 = number_before_reaching_sum (10, [1,2,3,3,5]) = 4
val test84 = number_before_reaching_sum (15, [1,2,3,3,5]) = 5


val test9  = what_month 70 = 3
val test91 = what_month 1 = 1
val test92 = what_month 365 = 12
val test93 = what_month 59 = 2

val test10 = month_range (31, 34) = [1,2,2,2]
val test101 = month_range (1, 1) = [1]
val test102 = month_range (1, 2) = [1,1]
val test103 = month_range (59, 62) = [2,3,3,3]
val test103 = month_range (364, 365) = [12,12]


val test11  = oldest([(2012,2,28),(2011,3,31),(2011,4,28)]) = SOME (2011,3,31)
val test112 = oldest([]) = NONE
val test113 = oldest([(2012,2,28)]) = SOME (2012,2,28)
val test114 = oldest([(2012,2,28),(2012,2,28),(2012,2,28)]) = SOME (2012,2,28)

val test12  = number_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = 3
val test121 = number_in_months_challenge ([],[]) = 0
val test122 = number_in_months_challenge ([],[2,3,4]) = 0
val test123 = number_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,12,2,3,12,3,4]) = 4

val test13 = dates_in_months_challenge ([],[]) = []
val test131 = dates_in_months_challenge ([],[2,3,4]) = []
val test132 = dates_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[]) = []
val test133 = dates_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[5]) = []
val test134 = dates_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,5,6,2,3,5,2]) = [(2012,2,28),(2011,3,31)]

val test14 = reasonable_date (0,1,1) = false
val test141 = reasonable_date (~1,1,1) = false
val test142 = reasonable_date (1,~1,1) = false
val test143 = reasonable_date (1,1,~1) = false
val test144 = reasonable_date (1,0,1) = false
val test145 = reasonable_date (1,1,0) = false
val test145 = reasonable_date (2020,1,32) = false
val test145 = reasonable_date (2020,13,20) = false
val test145 = reasonable_date (2020,2,29) = true
val test145 = reasonable_date (2019,2,29) = false
val test145 = reasonable_date (2019,12,31) = true
