#lang racket
(struct var  (string) #:transparent);; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent) ;; a number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent) ;; add two expressions
(struct mlet (var e body) #:transparent) ;; a local binding 
;; (let var = e in body)

(define (envlookup env str)
  (cond [(null? env) (error "unbound variable" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))
        
(define (eval-under-env e env)
  (cond [(var? e) (envlookup env (var-string e))]
        [(int? e) e]
        [(add? e) 
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "RUPL addition applied to non-number")))]
        [(mlet? e) 
         (let ([v (eval-under-env (mlet-e e) env)])
           (eval-under-env (mlet-body e) env))]
        [#t (error "bad RUPL expression")]))

[(mlet? e)          ; mlet (var e body)
 (eval-under-env (mlet-body e) (cons
                                (cons (mlet-var e)
                                      (eval-under-env (mlet-e e) env))
                                env))]


(define (eval-exp e)
  (eval-under-env e null))


(eval-exp (int 1))
(eval-exp (add (int 1) (int 2)))
(eval-under-env (add (var "a") (int 1)(eval-under-env (mlet "a" (int 5)))))