(*
val y = [(4,19), (1,20), (74,75)]

fun test x =
  case x of
    (a,b)::(c,d)::(e,f)::g => true
  | _ => false

val rest = test y



fun mystery f xs =
    let
        fun g xs =
           case xs of
               [] => NONE
             | x::xs' => if f x then SOME x else g xs'
    in
        case xs of
            [] => NONE
          | x::xs' => if f x then g xs' else mystery f xs'
    end



fun noll xs = case xs of [] => true | _ => false
fun noll xs = xs = []
fun null xs = if null xs then true else false
fun null xs = ((fn z => false) (hd xs)) handle List.Empty => true



datatype algebra_exp = Variable of string
                     | Integer of int
                     | Decimal of real
                     | Addition of algebra_exp * algebra_exp
                     | Multiplication of algebra_exp * algebra_exp
                     | Exponent of algebra_exp * int
type equation = algebra_exp * algebra_exp

*)

(*
signature COUNTER =
sig
    type t = int
    val newCounter : int -> t
    val increment : t -> t
    val first_larger : t * t -> bool
end


signature COUNTER =
sig
    type t = int
    val newCounter : int -> t
    val first_larger : t * t -> bool
end


signature COUNTER =
sig
    type t
    val newCounter : int -> int
    val increment : t -> t
    val first_larger : t * t -> bool
end


signature COUNTER =
sig
    type t
    val newCounter : int -> t
    val increment : t -> t
    val first_larger : t * t -> bool
end
*)

signature COUNTER =
sig
    type t = int
    val newCounter : int -> t
    val increment : t -> t
end

structure NoNegativeCounter :> COUNTER =
struct

exception InvariantViolated

type t = int

fun newCounter i = if i <= 0 then 1 else i

fun increment i = i + 1

fun first_larger (i1,i2) =
    if i1 <= 0 orelse i2 <= 0
    then raise InvariantViolated
    else (i1 - i2) > 0
end


val a = NoNegativeCounter.newCounter(1)
val b = NoNegativeCounter.newCounter(2)

val x = NoNegativeCounter.first_larger(a, b)
