
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below


(define  (sequence low high stride)
  (cond [(< low high) (cons low (sequence (+ low stride) high stride))]
        [(= low high) (cons low null)]
        [(> low high) null]
        

  ))
(define (string-append-map list xs)
  (map (lambda (element) (string-append element xs)) list))

(define  (list-nth-mod xs n)
   (cond [(< n 0) (error "list-nth-mod: negative number")]
        [(null? xs) (error  "list-nth-mod: empty list")])
   (let ([i (remainder n (length xs) ) ])
     (if (= i 0) (car xs) (list-nth-mod (cdr xs) (- i 1)))))


(define powers-of-two
  (letrec ([f (lambda (x) (cons x (lambda () (f (* x 2)))))])
    (lambda () (f 2))))
  

(define (stream-for-n-steps s n)
  (letrec ([f (lambda (s n)
                (let ([pr (s)])
                  (if (= n 0)
                      null
                      (cons (car pr) (f (cdr pr) (- n 1)) 
                  ))))])
                (f s n)))

(define (helper x) (cons x (lambda () (cond [(= (remainder x 5) 0) (helper (* (- x 1) -1))]
                                                    [(= (remainder (+ x 1) 5) 0 ) (helper (* (+ x 1) -1))]
                                                    [(> 1 0) (helper (+ x 1))]))))
(define funny-number-stream
  (lambda() (helper 1)))

(define dan-then-dog  (letrec([dog (lambda (x y) (if (string=? x "dog") (cons x (lambda ()(dog y x))) (cons x (lambda ()(dog y x)))))])
                        (lambda() (dog "dan.jpg" "dog.jpg"))))

(define (stream-add-zero s) (cons (cons 0 (car (s))) (lambda() (stream-add-zero (cdr (s))))))

(define (triple x)
  (letrec ([y (+ x 2)]
           [f (lambda (z) (+ z y w x))]
           [w (+ x 7)])
    (f -9)))


(define (cycle-lists xs ys)
  (letrec ([helper (lambda (n) (cons (cons (list-nth-mod xs n) (list-nth-mod ys n)) (lambda() (helper (+ n 1)))))])
    (lambda() (helper 0))))

(define(vector-assoc v vec)
  (letrec ([helper (lambda (n) (cond
                                 
                                  [(> n (- (vector-length vec) 1)) #f]
                                  [(not (pair? (vector-ref vec n))) (helper(+ 1 n)) ]
                                  [(not (equal? (car (vector-ref vec n)) v)) (helper (+ n 1))]
                                  [(equal? (car (vector-ref vec n)) v) (vector-ref vec n)]
                                  ))])
    (helper 0)))
(define fibonacci3
  (letrec([memo null] ; list of pairs (arg . result) 
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
;(define assoc-cache
 ; (letrec([memo null] ; list of pairs (arg . result) 
  ;        [f (lambda (xs n)
   ;            (let ([ans (assoc n memo)])
    ;             (if ans 
     ;                (cdr ans)
      ;               (let ([new-ans (assoc n xs)])
       ;                (begin 
        ;                 (set! memo (cons (cons n new-ans) memo))
         ;                new-ans)))))])
    ;(lambda (x) (f x))))

