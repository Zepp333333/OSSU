(* Problem 1:
   evaluate to true if date1 appears before date2, otherwise false *)
fun is_older(date1 : (int * int * int), date2: (int * int * int))=
    #1 date1 < #1 date2
    orelse ((#1 date1 = #1 date2) andalso (#2 date1 < #2 date2))
    orelse ((#1 date1 = #1 date2) andalso(#2 date1 = #2 date2) andalso (#3 date1 < #3 date2))


(* Problem 2:
   return number of dates whose month is equal to the input month *)
fun number_in_month(datesList : (int * int * int) list, month : int) =
    let
    	fun recursive_helper(dates : (int * int * int) list) =
    	    if null dates
    	    then 0
    	    else
    		if #2 (hd dates) = month
    		then 1 + recursive_helper(tl dates)
    		else recursive_helper(tl dates)

    	val answer = recursive_helper(datesList)
    in
    	answer
    end


(* Problem 3:
   return the number of dates in the datesList whose month appears in the monthsList *)
fun number_in_months(datesList : (int * int * int) list,  monthsList : int list) =
    let fun helper(monthsList : int list) =
	    if null monthsList
	    then 0
	    else number_in_month(datesList, hd monthsList) + helper(tl monthsList)
    in
    	helper(monthsList)
    end


(* Problem 4:
   returns a list of dates in datesList whose month is equal to input month *)
fun dates_in_month(datesList : (int * int * int) list, month : int)=
    let fun get_matching_dates(datesList : (int * int * int) list)=
	    if null datesList
	    then []
	    else
  		if #2(hd datesList) = month
  		then (hd datesList) :: get_matching_dates(tl datesList)
  		else get_matching_dates(tl datesList)
    in
    	get_matching_dates(datesList)
    end


(* Problem 5
   return a list of dates whose month matches any of the month in the monthsList *)
fun dates_in_months(datesList : (int * int * int) list, monthsList : int list) =
    if null datesList orelse null monthsList
    then []
    else
    	let
    	  fun helper(months : int list) =
      		if null months
      		then []
      		else dates_in_month(datesList, hd months) @ helper(tl months)
    	in
    	  helper(monthsList)
    	end


(* Problem 6
   return nth element of the string list
   Assumptions: hd list is 1, empty list doesn't have to be handled according to prob statement *)
fun get_nth(stringList : string list, n : int) =
    let
      fun helper(stringList : string list, i : int)=
  	    if i = n
  	    then hd stringList
  	    else helper(tl stringList, i + 1)
    in
    	helper(stringList, 1)
    end


(* Problem 7
   return stringified form of the input date e.g "January 20, 2020" *)
fun date_to_string(date : (int * int * int)) =
    let
    	val monthsList = ["January", "February", "March", "April",
    			  "May", "June", "July", "August", "September",
    			  "October", "November", "December"]

    	val monthString = get_nth(monthsList, #2 date)
    	val dayString = Int.toString(#3 date)
    	val yearString = Int.toString(#1 date)

    	val dateString = monthString ^ " " ^ dayString ^ ", " ^ yearString
    in
    	dateString
    end


(* Problem 8
   return n where n is the first n elements of the numbersList whose sum is < the input sum
   Assumption: sum(numbersList) > sum i.e. from problem statement *)
fun number_before_reaching_sum(sum : int, numbersList : int list) =
    let
    	fun helper(numbersList : int list, sum_so_far : int, i : int) =
    	    if (hd numbersList + sum_so_far) < sum
    	    then helper(tl numbersList, hd numbersList + sum_so_far, i + 1)
    	    else i - 1
    in
    	helper(numbersList, 0, 1)
    end


(* Problem 9
   return the month the day_of_year belong to *)
fun what_month(day_of_year : int)=
    let
    	val  days_in_each_month = [31, 28, 31, 30, 31, 30, 31, 
                                  31, 30, 31, 30, 31]
    in
    	number_before_reaching_sum(day_of_year, days_in_each_month) + 1
    end


(* Problem 10
   return a list of months where each month in the list is the month:
   day1, day1+1, day1+2,...day2-1, day2 belongs to *)
fun month_range(day1 : int, day2 : int) =
    if day1 > day2
    then []
    else what_month(day1) :: month_range(day1 + 1, day2)


(* Problem 11
   return an (int * int * int) option, if datesList is empty then returns a NONE *)
fun oldest(datesList : (int * int * int) list) =
    if null datesList
    then NONE
    else
    	let
    	    fun find_oldest(datesList : (int * int * int) list, oldest_so_far : (int * int * int)) =
    		if null datesList
    		then oldest_so_far
    		else
    		    if is_older(oldest_so_far, hd datesList)
    		    then find_oldest(tl datesList, oldest_so_far)
    		    else find_oldest(tl datesList, hd datesList)
    	in
    	    SOME (find_oldest(tl datesList, hd datesList))
    	end


(* Problem 12-a-helper 
   remove duplicate numbers in the array NOTE: elements are returned in the original order *)
fun remove_duplicates(a : int list) =
    let
    	(* checks if i is in the answer List *)
    	fun number_exists(i : int, answerList : int list) =
    	    if null answerList
    	    then false
    	    else
    		if i = hd answerList
    		then true
    		else number_exists(i, tl answerList)

    	(* remove the duplicate numbers in the input list  *)
    	fun vaporize_duplicates(inputList : int list, visitedList : int list) =
    	    if null inputList
    	    then []
    	    else
    		if number_exists(hd inputList, visitedList)
    		then vaporize_duplicates(tl inputList, visitedList)
    		else hd inputList ::  vaporize_duplicates(tl inputList, hd inputList::visitedList)
    in
      vaporize_duplicates(a, [])
    end 


(* Problem 12-a
   remove duplicate entries in monthsList, and then count the number of times the dates in datesList
   match monthList *)			      
fun number_in_months_challenge(datesList : (int * int * int) list, monthsList : int list) =
    let
      val monthsList = remove_duplicates(monthsList)
    in
      number_in_months(datesList, monthsList)
    end


(* Problem 12-b 
   return a list dates in the datesList if they match a month in the monthsList,
   repeated months in the monthsList are ignored *)
fun dates_in_months_challenge(datesList : (int * int * int) list, monthsList : int list) =
    let
    	val monthsList = remove_duplicates(monthsList)
    in
    	dates_in_months(datesList, monthsList)
    end


(* Problem 13
   return true if it's a real date: 
   1. Has a positive year (not 0)
   2. Month is between 1 & 12
   3. Day appropriate for the month for e.g. February in leap year has 29 days
   otherwise return false *)
fun reasonable_date(date: (int * int * int)) =
    let
    	fun is_zero_or_negative(year : int) =
    	    year <= 0

    	fun is_leap_year(year : int) =
    	    ((year mod 4 = 0) orelse (year mod 400 = 0)) andalso (year mod 100 <> 0)

    	fun days_in_feb(year : int) =
    	    if is_leap_year(year)
    	    then 29
    	    else 28

    	val days_in_each_month = [31, days_in_feb(#1 date), 31, 30, 31, 30, 31,
    				                    31, 30, 31, 30, 31]

    	fun is_month_valid(month : int) =
    	    let
    		val january = 1
    		val december = 12
    	    in
    		month >= january andalso month <= december
    	    end

    	fun is_day_valid(day : int, month : int) =
    	    let
    		fun get_num_of_days(days_in_each_month : int list, i : int) =
    		    if month = i
    		    then hd days_in_each_month
    		    else get_num_of_days(tl days_in_each_month, i + 1)
    		    
    		val num_of_days_in_month = get_num_of_days(days_in_each_month, 1)
    	    in
    		day >= 1 andalso day <= num_of_days_in_month
    	    end							 
    in
    	not(is_zero_or_negative(#1 date))
    	andalso is_month_valid(#2 date)
    	andalso is_day_valid(#3 date, #2 date)
    end
