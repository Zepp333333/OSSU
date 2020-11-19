#lang racket

;1 1 1 1 1

(define ones (lambda () (cons 1 ones)))

; 1 2 3 4 5

(define (f x) (cons x (lambda () f (+ x 1))))
;(define nats (lambda () (f 1)))

#;
(define nats
  (letrec ([f (lambda (x) (cons x (lambda () (f (+ x 1 )))))])
           (lambda () (f 1))))

(define powers-of-two
  (letrec ([f (lambda (x) (cons x (lambda () (f (* x 2)))))])
    (lambda () (f 2))))

(define (stream-maker fn arg)
 (letrec ([f (lambda (x) (cons x (lambda () (f (fn x arg)))))])
   (lambda () (f arg))))

(define nats (stream-maker + 1))



(define (number-until stream tester)
  (letrec ([f (lambda (stream ans)
                (let ([pr (stream)])
                  (if (tester (car pr))
                      ans
                      (f (cdr pr) (+ ans 1)))))])
    (f stream 1)))

;(number-until 