#lang racket

(define (silly-double1 x)
  (let ([x (+ x 3)]
        [y (+ x 2)])
    (+ x y -5)))

; (silly-double1 5)

(define (silly-double2 x)
  (let* ([x (+ x 3)]
        [y (+ x 2)])
    (+ x y -8)))

(define (silly-triple x)
  (letrec ([y (+ x 2)]
           [f (lambda(z) (+ z y w x))]
           [w (+ x 7)])
          (f  -9)))

(define (bad-letrec x)
  (letrec ([y z]
           [z 13])
    (if x y z)))

(define (silly-mod2 x)
  (letrec
      ([even? (lambda(x) (if (zero? x) #t (odd? (- x 1))))]
       [odd?  (lambda(x) (if (zero? x) #f (even? (- x 1))))])
    (if (even? x) 0 1)))

(silly-mod2 4)