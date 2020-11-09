fun alternate (loi :int list) : int =
(* int list -> int
Produce int by adding numbers in the provided list with
alternate sign (alternate [1,2,3,4] = 1 - 2 + 3 - 4 = -2)
  - loi - list_of_integers*)
  if (hd loi) mod 2 <> 0
