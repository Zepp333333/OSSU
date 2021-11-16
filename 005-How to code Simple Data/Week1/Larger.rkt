;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname Larger) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; Image, Image -> Boolean
;; produces true if first provided image area is larger than second image area

(check-expect (larger? (ellipse 60 30 "solid" "red") (triangle 30 "solid" "red")) true)
(check-expect (larger? (ellipse 60 30 "solid" "red") (ellipse 60 30 "solid" "red")) false)
(check-expect (larger? (ellipse 20 20 "solid" "red") (ellipse 60 30 "solid" "red")) false)

;(define (larger? i1 i2) false) ; stub

;(define (larger? i1 i2)         ; template
;  ( ... false))

(define (larger? i1 i2)
  (> (* (image-width i1)
        (image-height i1))
     (* (image-width i2)
        (image-height i2))))