(* fun foo f x y z =
	if x >= y   (* x: int, y : int*)
	then (f z)  (* f: t1 -> t2, z : t1 *)
	else foo f y x (tl z)  (* foo: t2, z t1 list*)

  (* ('a list -> 'b) -> int - int - > 'b *)

fun baz f a b c d e = (f (a ^ b))::(c + d)::e

val a1 = baz (fn z => 3)
val a2 = baz (fn z => 10) "foo"
val a3 = baz (fn z => 10) "foo"
val a4 = baz (fn z => 10) "foo" "bar"


fun maybeEven x =
	(print("1") ; if x = 0
	then true
	else
	if x = 50
	then false
	else maybeOdd (x-1))

and maybeOdd y =
	if y = 0
	then false
	else
	if y = 99
	then true
	else maybeEven (y-1)

val res = maybeEven 6
*)

signature DIGIT =
sig
type digit
val make_digit : int -> digit
val increment : digit -> digit
val decrement : digit -> digit
val down_and_up : digit -> digit
val test : digit -> unit
end

structure Digit :> DIGIT =
struct
type digit = int
exception BadDigit
exception FailTest
fun make_digit i = if i < 0 orelse i > 9 then raise BadDigit else i
fun increment d = if d=9 then 0 else d+1
fun decrement d = if d=0 then 9 else d-1
val down_and_up = increment o decrement (* recall o is composition *)
fun test d = if down_and_up d = d then () else raise FailTest
end
