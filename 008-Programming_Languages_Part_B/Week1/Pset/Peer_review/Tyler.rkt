
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below

;; Problem 1 
(define (sequence low high stride)
  (if (> low high)
       null
      (cons low (sequence (+ low stride) high stride))))


;;Problem 2
(define (string-append-map xs suffix)
  (map (lambda (word) (string-append word suffix)) xs))

;;Problem 3
(define (list-nth-mod xs  n)
  (cond [(< n 0) (error "list-nth-mod: empty list")]
        [(null? xs) (error "list-nth-mod: empty list")]
        [#t (car (list-tail xs (remainder n (length xs))))]))

;;Problem 5
(define funny-number-stream
  (letrec ([f (lambda (x) (if (= (remainder x 5) 0)
                              (cons (- 0 x) (lambda () (f (+ 1 x))))
                              (cons x (lambda () (f (+ 1 x))))))])
    (lambda () (f 1))))

;;Problem 6
(define dan-then-dog
  (letrec ([f (lambda (x) (if (string=? x "dog.jpg")
                              (cons x (lambda () (f "dan.jpg")))
                              (cons x (lambda () (f "dog.jpg")))))])
          (lambda () (f "dan.jpg"))))


;;Problem 4
(define ones (lambda () (cons 1 ones)))

;;Problem 7
(define (stream-add-zero s)
  (letrec ([thunk (lambda (s) (cons (cons 0 (car (s))) (lambda () ((stream-add-zero (cdr (s)))))))])
    (lambda () (thunk s))))

;;Problem 8  check this problem
(define (cycle-lists xs ys)
  (letrec ([thunk (lambda (n) (cons (cons (list-nth-mod xs n) (list-nth-mod ys n))
                            (lambda () (thunk (+ 1 n)))))])
    (lambda () (thunk 0))))


;;Problem 9 
(define (vector-assoc v vec)
  (letrec ([iter (lambda (n) (cond [ (= (vector-length vec) n) #f]
                                   [ (equal? #f (pair? (vector-ref vec n))) (iter (+ n 1))]
                                   [ (equal? (car (vector-ref vec n)) v) (vector-ref vec n)]
                                   [ #t (iter (+ n 1))]))])
    (iter 0)))

;;Problem 10 can't handle list without pairs
(define (cached-assoc xs n)
  (let ([cache (make-vector n #f)]
           [slot 0])
           (lambda (v)
                     (or (vector-assoc v cache)
                         (let ([new-ans (assoc v xs)])
                             (if new-ans
                                 (begin
                                   (vector-set! cache slot new-ans)
                                   (set! slot (if (= slot (- n 1))
                                                  0
                                                  (+ slot 1)))
                                   new-ans)
                                 new-ans))))))    


(define (stream-for-n-steps s n)
  (if (= n 0)
      null
      (cons (car (s)) (stream-for-n-steps (cdr (s)) (- n 1)))))

(define-syntax while-less
  (syntax-rules (do)
    ((while-less e1 do e2)
     (letrec ([x e1]
       [helper (lambda () (let ([y e2]) (if (or (not (number? y)) (<= x y))
                                    #t
                                    (helper))))])
       (helper)))))


                                    
