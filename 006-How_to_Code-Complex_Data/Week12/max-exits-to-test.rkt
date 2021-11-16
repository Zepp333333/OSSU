;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname max-exits-to-test) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct room (name exits))
;; Room is (make-room String (listof Room))
;; interp. the room's name, and list of rooms that the exits lead to


(define-struct ins (room coi))
;; ins is (make-ins String Integer)
;; interp. the roomname and it's  number of incoming exits leading to the room

;; loi is (listof ins) is one of
;;   empty
;;   (cons ins (loi)) ; interp as list of room names and number of incoming exits to them

(define H1 (make-room "A" (list (make-room "B" empty))))


(define H2 
  (shared ((-0- (make-room "A" (list (make-room "B" (list -0-))))))
    -0-))

(define H3
  (shared ((-A- (make-room "Z" (list -B-)))
           (-B- (make-room "B" (list -C-)))
           (-C- (make-room "C" (list -A-))))
    -A-))
           

(define I1 (list (make-ins "A" 0)))
(define I2 (list (make-ins "A" 0) (make-ins "B" 3))) 

(define (in-ins? r loi)
  (cond [(empty? loi) false]
        [else
         (if (string=? (room-name r) (ins-room (first loi)))
             true
             (in-ins? r (rest loi)))]))

;(in-ins? H1 I1)
;(in-ins? H1 I2)
;(in-ins? H2 I2)
;(in-ins? H3 I2)

(define (increment-r-ins r loi)
  (cond [(empty? loi)
         (list (make-ins (room-name r) 1))]
        [else
         (if (string=? (room-name r) (ins-room (first loi)))
             (cons (make-ins (ins-room (first loi)) (add1 (ins-coi (first loi))))
                   (rest loi))
             (cons (first loi) (increment-r-ins r (rest loi))))]))

(increment-r-ins H3 I2)
(increment-r-ins H2 I2)

(define (get-biggest-ins loi rsf)
  (cond [(empty? loi) rsf]
        [else
         (if (> (ins-coi (first loi)) (ins-coi rsf))
             (get-biggest-ins (rest loi) (first loi))
             (get-biggest-ins (rest loi) rsf))]))
             
;(get-biggest-ins (list (make-ins "A" 0) (make-ins "B" 3) (make-ins "Z" 1)) (make-ins "A" 0))  


(define (save-exits r rsf)
  (cond [(empty? (room-exits r) (rsf))]
        [else
         (...(... (first (room-exits r)) rsf)
             (save-exits (rest (room-exits r) rsf)))]))





