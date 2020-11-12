#lang racket


(define (fibonacci1 x)
  (if (or (= x 1) (= x 2))
          1
          (+ (fibonacci1 (- x 1))
             (fibonacci1 (- x 2)))))


(define fibonacci3
  (letrec ([memo null]  ; list of paris (arg . result)
           [f (lambda (x)
                (let ([ans (assoc x memo)])
                  (if ans
                      (cdr ans)
                      (let ([new-ans (if (or (= x 1) (= x 2))
                                         1
                                         (+ (f (- x 1))
                                            (f (- x 2))))])
                        (begin
                          (set! memo (cons (cons x new-ans) memo))
                          new-ans)))))])
    f))