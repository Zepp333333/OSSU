#lang racket



(define longer-strings
  (lambda ()
    (letrec ([f (lambda(s)
                  (cons s (lambda () (f (string-append "A" s)))))])
      (lambda () (f "A")))))

(define nats
  (letrec ([f (lambda (x)
                (cons x (lambda () (f (+ x 1)))))])
    (lambda () (f 1))))


(define (mystery s)
  (lambda ()
    (let ([pr (s)])
      (if (car pr)
          (cons (car pr) (mystery (cdr pr)))
          ((mystery (cdr pr)))))))

(define a (list 1 2 3))

(define (stream-for-n-steps s n)
  (if (= n 0)
      null
      (cons (car (s))
            (stream-for-n-steps (cdr (s)) (- n 1)))))

(define e1 1)
(define e2 2)
(define f (let ([x e1]) (lambda (y) e2)))
(define f2 (lambda (y) (let ([x e1]) e2))) ; call this code B