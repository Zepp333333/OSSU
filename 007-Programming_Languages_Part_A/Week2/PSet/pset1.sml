fun is_older(date1 : int*int*int, date2: int*int*int) =
(* date date -> bool
Produce true if first argument date is before the second argument date. Otherwise false (incl. the case if both date are equal)
  - date is int*int*int where first part is the year, the second part is the month, and the third part is the day.
Assume dates provided is "reasonable" - a positive year, a month between 1 and 12, and a day no greater than 31
(or less depending on the month) *)
  let
    (*assume every month is 31 day long - this is fine for
    the purpose of comparison of 2 dates*)
    val d1 = (#1 date1 * 365) + (#2 date1 * 31) + #3 date1
    val d2 = (#1 date2 * 365) + (#2 date2 * 31) + #3 date2
  in
    d1 < d2
  end

fun number_in_month (lod : (int*int*int) list, month : int) =
  (*
  list_of_dates month -> int
  produce number of how many dates in the provided list_of_dates are in the given month
    -list_of_dates as list of (int*int*int)
    -moth is an int
  *)
  if null lod then 0
  else
    let val result = if #2 (hd lod) = month then 1 else 0
    in result + number_in_month(tl lod, month)
    end

fun number_in_months (lod : (int*int*int) list, lom : int list) =
(* list_of_dates list_of_months -> int
produce number of how many dates in the provided list_of_dates are in any month the given list_of_month
takes a list of dates and a month (i.e., an int) and returns
  -list_of_dates as list of (int*int*int)
  -list_of_moths is an int list
Assume the list of months has no number repeated. *)
  if null lom then 0
  else
    number_in_month(lod, (hd lom)) + number_in_months (lod, (tl lom))

fun dates_in_month (lod : (int*int*int) list, month : int) =
(* list_of_dates month -> list_of_dates
Produce list holding the dates from the argument list_of_dates that are in the month. The returned list
contain dates in the order they were originally given.
  -list_of_dates as list of (int*int*int)
  -moth is an int*)
  if null lod then []
  else
    if #2 (hd lod) = month
    then (hd lod) :: dates_in_month((tl lod), month)
    else dates_in_month((tl lod), month)

fun dates_in_months (lod : (int*int*int) list, lom : int list) =
(* list_of_dates list_of_month -> list_of_dates
Produce list_of dates holding the dates from the argument list of dates that are in any of the months in
the list of months. Assume the list of months has no number repeated.
  -list_of_dates as list of (int*int*int)
  -list_of_moths is an int list*)
  if null lom then []
  else
    dates_in_month(lod, (hd lom)) @ dates_in_months(lod, (tl lom))

fun get_nth (los : string list, n : int) =
(* list_of_strings int -> string
Produce n-th element of a provided list of strings assuming head of the list is 1st.
  -los - list of strings (string list)
  -n is and int *)
  if n = 1 then (hd los)
  else
    get_nth((tl los), n - 1)

fun date_to_string (date : int*int*int) =
(* date -> string
Produce string of form January 20, 2013 given a date
  -date is int*int*int where first part is the year, the second part is the month, and the third part is the day.
Assume date provided is "reasonable" - a positive year, a month between 1 and 12, and a day no greater than 31
(or less depending on the month) *)
  let
    val months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  in
    get_nth(months, #2 date) ^ " " ^ Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
  end

fun number_before_reaching_sum(sum : int, loi : int list) =
(* int, list_of_integers -> int
Produce int n such as first n elements of provided list_of_integers add to less than provided sum while
first n+1 elements add to sum or more.
  -sum - int
  -loi - int list_of
Assumptions:
  - sum is positive
  - elements of loi are all positive
  - sumary of all elements of loi > sum *)
  if null loi then 0
  else if (hd loi) >= sum then 0
  else
    1 + number_before_reaching_sum(sum - (hd loi), tl loi)

fun what_month (day : int) =
(* int -> int
Produce a number of a month (1 for January, 2 for February, etc.) to which provided day of year belongs
  - day - int. day of year between 1 and 365 *)
  let
    val days_in_month = [31,28,31,30,31,30,31,31,30,31,30,31]
  in
    1 + number_before_reaching_sum(day, days_in_month)
  end

fun month_range (day1 : int, day2 : int) =
(* int int -> list_of_integers
Produce list of integers representing months [m1,m2,...,mn] here m1 is the month of day1,
m2 is the month of day1+1, ..., and mn is the month of day day2
  -day1, day2 - int. day of year between 1 and 365
Note the result will have length day2 - day1 + 1 or length 0 if day1>day2. *)
  if day1 > day2 then []
  else
    let
      fun makeRange (first : int, last : int) =
        if first > last then []
        else first :: makeRange((first + 1), last)
      fun mapDayToMonth (range : int list) =
        if null range then []
        else what_month(hd range) :: (mapDayToMonth(tl range))
    in
      mapDayToMonth(makeRange(day1, day2))
    end

fun oldest (lod : (int*int*int) list) =
(* list_of_dates -> date option
Produce option that evaluates to NONE if provided list_of_dates is empty or SOME date wchih is the oldest date in the list.
  - lod - (int*int*int) list - list of dates *)
  if null lod then NONE
  else if null (tl lod) then SOME (hd lod)
  else
    let val tl_ans = oldest(tl lod)
    in
      if isSome tl_ans andalso is_older(hd lod, valOf tl_ans)
      then SOME (hd lod)
      else tl_ans
    end


(* Challendge porblems *)

(* Helper fuctnion for challenge problem*)
fun removeDup (loi : int list) =
(* list_of_integers -> list_of_integers
Produce list_of_integers with no duplicate elements
  -loi - int list *)
  if null loi then []
  else
    let
      fun removeOne (i : int, loi : int list) =
        if null loi then []
        else if hd loi <> i
          then hd loi :: removeOne(i, tl loi)
          else removeOne(i, tl loi)
      fun isInList (i : int, loi : int list) =
        if null loi then false
        else if i = hd loi
          then true
          else isInList(i, tl loi)
    in
      if not (isInList(hd loi, tl loi))
      then hd loi :: removeDup(tl loi)
      else hd loi :: removeDup(removeOne(hd loi, tl loi))
    end

fun number_in_months_challenge (lod : (int*int*int) list, lom : int list) =
(* list_of_dates list_of_months -> int
produce number of how many dates in the provided list_of_dates are in any month the
given list_of_month that first cleaned of possible duplicates.
takes a list of dates and a month (i.e., an int) and returns
  -list_of_dates as list of (int*int*int)
  -list_of_moths is an int list
Assume the list of months has no number repeated. *)
  if null lom then 0
  else number_in_months(lod, removeDup(lom))


fun dates_in_months_challenge (lod : (int*int*int) list, lom : int list) =
(* list_of_dates list_of_month -> list_of_dates
Produce list_of dates holding the dates from the argument list of dates that are in any of the months in
the list of months. Assume the list of months has no number repeated.
  -list_of_dates as list of (int*int*int)
  -list_of_moths is an int list*)
  if null lom then []
  else
    dates_in_months(lod, removeDup(lom))


fun reasonable_date (date : int*int*int) =
(* date -> bool
Produce true if provided date is reasonable: year > 0, month in range [1-12], day within range of possible days for appropriate month
(correctry treating leap and non-leap years).
  -date is int*int*int
*)
  if #1 date < 1 then false
  else if #2 date < 1 orelse #2 date > 12 then false
  else
    let
      val days_in_month = [31,28,31,30,31,30,31,31,30,31,30,31]
      val days_in_month_leap = [31,29,31,30,31,30,31,31,30,31,30,31]
      fun dim (year : int) =
      (* determines if year is leap and returns appropriate list of number of days in months*)
        if year mod 400 = 0 orelse (year mod 4 = 0 andalso year mod 100 <> 0)
        then days_in_month_leap
        else days_in_month
      fun get_nth_int (loi : int list, n : int) =
      (* Produce n-th element of a provided list of strings assuming head of the list is 1st. *)
        if n = 1 then (hd loi)
        else
          get_nth_int((tl loi), n - 1)
    in
      if #3 date >= 1 andalso #3 date <= get_nth_int(dim(#1 date), #2 date)
      then true
      else false
    end
