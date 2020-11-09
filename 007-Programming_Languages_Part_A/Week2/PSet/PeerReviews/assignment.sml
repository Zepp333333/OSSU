(* Function No. 1 *)

fun is_equal (dateno1: int * int * int, dateno2: int * int * int)=
    (#1 dateno1 = #1 dateno2) andalso (#2 dateno1 = #2 dateno2) andalso (#3 dateno1 = #3 dateno2)

fun is_older (dateno1: int * int * int, dateno2: int * int * int)=
    if is_equal (dateno1, dateno2)
    then false
    else (#1 dateno1 <= #1 dateno2) andalso (#2 dateno1 <= #2 dateno2) andalso (#3 dateno1 <= #3 dateno2)
									  
(* Function No. 2 *)
										
fun number_in_month (dates: (int * int * int) list, month: int)=
    (* repeat/iterate months ( dates, month, 0); *)
    if null dates
    then 0
    else if #2 (hd dates) = month
    then 1 + number_in_month (tl dates, month)
    else number_in_month (tl dates, month)

(* Function No. 3 *)

fun number_in_months (dates: (int * int * int) list, months: int list) =
    if null months
    then 0
    else number_in_month( dates, hd months) + number_in_months(dates, tl months)
							      
(* Function No. 4 *)
							      
fun dates_in_month (dates: (int * int * int) list, month: int)=
    if null dates
    then []
    else if #2 (hd dates) = month
    then hd dates :: dates_in_month (tl dates, month)
    else dates_in_month (tl dates, month)
			
(* Function No. 5 *)
			
fun dates_in_months (dates: (int * int * int) list, months: int list) =
    if null months
    then []
    else dates_in_month (dates, hd months) @ dates_in_months ( dates, tl months)
							     
(* Function No. 6 *)
							   
fun get_nth (strings: string list, n: int)=
    if n = 1
    then hd strings
    else get_nth (tl strings, n - 1)
		 
(* Function No. 7 *)

val months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
fun date_to_string (date : (int* int * int))=
    get_nth (months, #2 date) ^ " " ^ Int.toString(#3 date) ^ ", " ^ Int.toString (#1 date);

(* Function No. 8 *)

fun number_before_reaching_sum ( sum: int, values: int list)=
    let
	fun iterate_sum (i : int, sum_stop: int, max: int, v: int list)=
	    if sum_stop + hd v >= max
	    then i - 1
	    else iterate_sum (i + 1, sum_stop + hd v, max, tl v)
    in
	iterate_sum (1, 0, sum, values)
    end;

(* Function No. 9 *)

val month_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
fun what_month ( day_of_year : int)=
    number_before_reaching_sum (day_of_year, month_days) + 1;

(* Function No. 10 *)

fun month_range (day1 : int, day2 : int)=
    if day1 > day2
    then []
    else
	let fun countUp (from : int, to : int)=
		if from = to
		then [to]
		else from :: countUp (from + 1, to)
	in
	    countUp (what_month (day1), what_month (day2))
	end
(* Function No. 11 *)

fun oldest (dates: (int * int * int) list)=
    if null dates
    then NONE
    else
	let fun get_oldest (dates: (int * int * int) list)=
		if null (tl dates)
		then hd dates
		else
		    let
			val last = get_oldest (tl dates)
			val first = hd dates
		    in
			if is_older (first, last)
			then first
			else last
		    end
	in
	    SOME (get_oldest dates)
	end
	    
		
