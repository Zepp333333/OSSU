
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below


;; PROBLEM 1
;;
;; sequence takes 3 arguments low, high, and stride, all assumed to be numbers.
;; Further assume stride is positive. sequence produces a list of numbers from low to high (including
;; low and possibly high) separated by stride and in sorted order.
(define (sequence l h s)
  (if (< h l)
      null
      (cons l (sequence (+ l s) h s))))


;; PROBLEM 2
;;
;; string-append-map takes a list of strings xs and a string suffix and returns a
;; list of strings. Each element of the output should be the corresponding element of the input appended
;; with suffix (with no extra space between the element and suffix). You must use Racket-library
;; functions map and string-append. Sample solution: 2 lines

(define (string-append-map xs suffix)
  (map (lambda (x) (string-append x suffix)) xs))


;; PROBLEM 3
;;
;; list-nth-mod takes a list xs and a number n. If the number is negative,
;; terminate the computation with (error "list-nth-mod: negative number"). Else if the list is
;; empty, terminate the computation with (error "list-nth-mod: empty list"). Else return the i'th
;; element of the list where we count from zero and i is the remainder produced when dividing n by the
;; list’s length. Library functions length, remainder, car, and list-tail are all useful – see the Racket
;; documentation. Sample solution is 6 lines.

(define (list-nth-mod xs n)
  (cond [(< n 0) (error "list-nth-mod: negative number")]
        [(empty? xs) (error "list-nth-mod: empty list")]
        [else
         (car (list-tail xs (remainder n (length xs))))]))


;; PROBLEM 4
;;
;; stream-for-n-steps takes a stream s and a number n. It returns a list holding
;; the first n values produced by s in order. Assume n is non-negative. Sample solution: 5 lines. Note:
;; You can test your streams with this function instead of the graphics code.

(define (stream-for-n-steps s n)
  (if (= n 0)
      null
      (cons (car (s))
            (stream-for-n-steps (cdr (s)) (- n 1)))))


;; PROBLEM 5
;;
;; funny-number-stream is like the stream of natural numbers (i.e., 1, 2, 3, ...)
;; except numbers divisble by 5 are negated (i.e., 1, 2, 3, 4, -5, 6, 7, 8, 9, -10, 11, ...). Remember a stream
;; is a thunk that when called produces a pair. Here the car of the pair will be a number and the cdr will
;; be another stream.

(define funny-number-stream
  (letrec
      ([negate_if_needed
        (lambda (n) (if (= (remainder n 5) 0)
                        (- n)
                        n))]
       [f (lambda (x) (cons (negate_if_needed x) (lambda () (f (+ x 1 )))))])
    (lambda () (f 1))))


;; PROBLEM 6
;;
;; stream dan-then-dog, where the elements of the stream alternate between the strings "dan.jpg"
;; and "dog.jpg" (starting with "dan.jpg"). More specifically, dan-then-dog should be a thunk that
;; when called produces a pair of "dan.jpg" and a thunk that when called produces a pair of "dog.jpg"
;; and a thunk that when called... etc. Sample solution: 4 lines.

(define dan-then-dog
  (letrec ([f (lambda (x) (cons (car x) (lambda () (f (cons (cdr x) (car x) )))))])
    (lambda () (f (cons  "dan.jpg" "dog.jpg")))))


;; PROBLEM 7
;;
;; a function stream-add-zero that takes a stream s and returns another stream. If s would
;; produce v for its i'th element, then (stream-add-zero s) would produce the
;; pair (0 . v) for its i'th element.
;; Sample solution: 4 lines. Hint: Use a thunk that when called uses s and recursion.
;; Note: One of the provided tests in the file using graphics uses (stream-add-zero dan-then-dog)
;; with place-repeatedly

(define (stream-add-zero s)
  (letrec ([f (lambda (x) (cons (cons 0 (car x)) (lambda () (f ((cdr x))) )))])
    (lambda () (f (s)))))


;; PROBLEM 8
;;
;; a function cycle-lists takes two lists xs and ys and returns a stream. The lists may or
;; may not be the same length, but assume they are both non-empty. The elements produced by the
;; stream are pairs where the first part is from xs and the second part is from ys. The stream cycles
;; forever through the lists. For example, if xs is ’(1 2 3) and ys is ’("a" "b"), then the stream
;; would produce, (1 . "a"), (2 . "b"), (3 . "a"), (1 . "b"), (2 . "a"), (3 . "b"), (1 . "a"),
;; (2 . "b"), etc.

(define (cycle-lists xs ys)
  (letrec (
           [f (lambda (n) (cons
                           (cons (list-nth-mod xs n) (list-nth-mod ys n))
                           (lambda () (f (+ n 1)))))])
    (lambda () (f 0))))


;; PROBLEM 9
;;
;; vector-assoc  takes a value v and a vector vec. It should behave like Racket’s
;; assoc library function except (1) it processes a vector (Racket’s name for an array) instead of a list,
;; (2) it allows vector elements not to be pairs in which case it skips them, and (3) it always takes exactly
;; two arguments. Process the vector elements in order starting from 0. You must use library functions
;; vector-length, vector-ref, and equal?. Return #f if no vector element is a pair with a car field
;; equal to v, else return the first pair with an equal car field. Sample solution is 9 lines, using one local
;; recursive helper function.

(define (vector-assoc v vec)
  (letrec ([f (lambda (n)
                (cond [(= n (vector-length vec)) #f]
                      [(pair? (vector-ref vec n))
                       (if (equal? v (car (vector-ref vec n)))
                           (vector-ref vec n)
                           (f (+ n 1)))]
                      [else (f (+ n 1))]))])
    (f 0)))
      
;; PROBLEM 10
;;
;; cached-assoc takes a list xs and a number n and returns a function that takes
;; one argument v and returns the same thing that (assoc v xs) would return. However, you should
;; use an n-element cache of recent results to possibly make this function faster than just calling assoc
;; (if xs is long and a few elements are returned often).

(define (cached-assoc xs n)
  (letrec (
           [cache (make-vector n #f)]
           [i 0]
           [update-cache (lambda (v i)
                           (vector-set! cache (remainder i (vector-length cache)) v))]
           [f (lambda (v)
                (if (vector-assoc v cache)
                    (vector-assoc v cache)
                    (if (assoc v xs)
                        (begin
                          (update-cache (assoc v xs) i)
                          (set! i (+ i 1))
                          (vector-assoc v cache))
                        #f)))])
    (lambda (v) (f v)) ))
  