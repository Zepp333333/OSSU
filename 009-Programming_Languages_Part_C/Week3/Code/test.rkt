#lang racket


(define nats
  (letrec ((f (lambda (x) (cons x (lambda () (f (+ x 1)))))))
    (lambda () (f 1))))

(define (twice-each1 s)
  (lambda ()
    (let ([pr (s)])
      (cons (car pr)
            (lambda ()
              (cons (car pr)
                    (twice-each1 (cdr pr))))))))


(define (twice-each2 s)
  (let ([pr (s)])
    (cons (car pr)
          (lambda ()
            (cons (car pr)
                  (twice-each2 (cdr pr)))))))

(define (twice-each3 s)
  (lambda ()
    (let ([pr (s)])
      (cons (car pr)
            (cons (car pr)
                  (twice-each3 (cdr pr)))))))

(define (twice-each4 s)
  (let ([pr (s)])
    (cons (car pr)
      (lambda ()
        (cons (cdr pr)
              (twice-each4 ((cdr pr))))))))

(define (stream-for-n-steps s n)
  (if (= n 0)
      null
      (cons (car (s))
            (stream-for-n-steps (cdr (s)) (- n 1)))))

(stream-for-n-steps (twice-each1 nats) 10)

(define e #f)

(define (f1) ; call this version A
  (let ([x e])
    (if x x 42)))

(define (f2) ; call this version B
  (if e e 42))
