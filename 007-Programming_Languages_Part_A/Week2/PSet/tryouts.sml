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

fun makeRange (first : int, last : int) =
  if first > last
  then []
  else first :: makeRange((first + 1), last)

val r = [1, 2, 3, 4, 5]


fun mapDayToMonth (range : int list) =
  if null range then []
  else
    what_month(hd range) :: (mapDayToMonth(tl range))

(*mapDayToMonth(makeRange(1, 5))*)
fun wrapper () =
  mapDayToMonth(makeRange(1, 5))

fun countdown (i : int) =
if i = 0 then []
else i :: countdown (i-1)

fun is_older(date1 : int*int*int, date2: int*int*int) =
(* date date -> bool
Produce true if first argument date is before the second argument date. Otherwise false (incl. the case if both date are equal)
  - date is int*int*int where first part is the year, the second part is the month, and the third part is the day.
Assume dates provided is "reasonable" - a positive year, a month between 1 and 12, and a day no greater than 31
(or less depending on the month) *)
  let
    val d1 = (#1 date1 * 365) + (#2 date1 * 31) + #3 date1
    val d2 = (#1 date2 * 365) + (#2 date2 * 31) + #3 date2
  in
    d1 < d2
  end

fun oldest (lod : (int*int*int) list) =
  if null (tl lod) then (hd lod)
  else
    let val tl_ans = oldest(tl lod)
    in
      if is_older((hd lod), tl_ans)
      then hd lod
      else tl_ans
    end






fun removeDup (loi : int list) =
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
