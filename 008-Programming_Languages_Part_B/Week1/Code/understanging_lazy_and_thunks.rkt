#lang racket

(provide (all-defined-out))

(define (factorial-normal x)
  (if (= x 0)
      1
      (* x (factorial-normal (- x 1)))))

; (factorial-normal 10)

(define (my-if-bad e1 e2 e3)
  (if e1 e2 e2))

(define (factorial-bad x)
  (my-if-bad (= x 0)
             1
             (* x (factorial-bad (- x 1)))))


(define (slow-add x y)
  (letrec ([slow-id (lambda (y z )
                      (if (= 0 z)
                          y
                          (slow-id y (- z 1))))])
    (+ (slow-id x 90000000) y)))