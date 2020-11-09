;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname space-invaders-starter2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
Starter:
(require 2htdp/universe)
(require 2htdp/image)
 
;; Space Invaders
 
 
;; Constants:
 
(define WIDTH  300)
(define HEIGHT 500)
 
(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)
 
(define HIT-RANGE 10)
 
(define INVADE-RATE 100)
 
(define BACKGROUND (empty-scene WIDTH HEIGHT))
 
(define INVADER
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer
 
(define TANK
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body
 
(define TANK-HEIGHT/2 (/ (image-height TANK) 2))
 
(define MISSILE (ellipse 5 15 "solid" "red"))
 
 
 
;; Data Definitions:
 
(define-struct game (invaders missiles tank))
;; Game is (make-game  (listof Invader) (listof Missile) Tank)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles and tank position
 
;; Game constants defined below Missile data definition
 
#;
(define (fn-for-game s)
  (... (fn-for-loinvader (game-invaders s))
       (fn-for-lom (game-missiles s))
       (fn-for-tank (game-tank s))))
 
 
 
(define-struct tank (x dir))
;; Tank is (make-tank Number Integer[-1, 1])
;; interp. the tank location is x, HEIGHT - TANK-HEIGHT/2 in screen coordinates
;;         the tank moves TANK-SPEED pixels per clock tick left if dir -1, right if dir 1
 
(define T0 (make-tank (/ WIDTH 2) 1))   ;center going right
(define T1 (make-tank 50 1))            ;going right
(define T2 (make-tank 50 -1))           ;going left
 
#;
(define (fn-for-tank t)
  (... (tank-x t) (tank-dir t)))
 
 
 
(define-struct invader (x y dx))
;; Invader is (make-invader Number Number Number)
;; interp. the invader is at (x, y) in screen coordinates
;;         the invader along x by dx pixels per clock tick
 
(define I1 (make-invader 150 100 12))           ;not landed, moving right
(define I2 (make-invader 150 HEIGHT -10))       ;exactly landed, moving left
(define I3 (make-invader 150 (+ HEIGHT 10) 10)) ;> landed, moving right
 
 
#;
(define (fn-for-invader invader)
  (... (invader-x invader) (invader-y invader) (invader-dx invader)))
 
 
(define-struct missile (x y))
;; Missile is (make-missile Number Number)
;; interp. the missile's location is x y in screen coordinates
 
(define M1 (make-missile 150 300))                       ;not hit U1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  ;exactly hit U1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit U1
 
#;
(define (fn-for-missile m)
  (... (missile-x m) (missile-y m)))
 
 
 
(define G0 (make-game empty empty T0))
(define G1 (make-game empty empty T1))
(define G2 (make-game (list I1) (list M1) T1))
(define G3 (make-game (list I1 I2) (list M1 M2) T1))



;; =====================================================================================
;; =====================================================================================
;; =====================================================================================
;; Functions:

;; Game -> Game
;; start the world with (make-game empty emtpy T0)
;; 
(define (main g)
  (big-bang g                         ; Game
    (on-tick   next-game );INVADE-RATE)     ; Game -> Game
    (to-draw   render-game)        ; Game -> Image
    (stop-when stop? )           ; Game -> Boolean
    (close-on-stop 3)
    ;(on-mouse  ...)           ; Game Integer Integer MouseEvent -> Game
    (on-key handle-key)))         ; Game KeyEvent -> Game




;---------------------------------------------------------------------------------------
;; Game -> Game
;; produce the next ...


;(define (next-game g) g) ;stub

(define (next-game g)
  (















;---------------------------------------------------------------------------------------
;; ; Game -> Boolean
;; produce true if game is lost
(check-expect (stop? G0) false)
(check-expect (stop? (make-game LOI2 LOM0 T1)) true)


;(define (stop? g) false) ; stub

(define (stop? g)
  (if (invader-landed? (game-invaders g)) true false))
    

;---------------------------------------------------------------------------------------
;; ListOfInvaders -> true
;; produce true if any invider has landed (invider-y >= (HEIGHT -(image-height INVADER)))
(check-expect (invader-landed? empty) false)
(check-expect (invader-landed? LOI1) false)
(check-expect (invader-landed? LOI2) true)

; (define (invader-landed? loi) false); stub

(define (invader-landed? loi)
  (cond [(empty? loi) false]                   
        [else (if (>= (invader-y (first loi)) (- HEIGHT 10))
                  true
                  (invader-landed? (rest loi)))]))


 
;---------------------------------------------------------------------------------------
;; Game KeyEvent -> Game
;; produce reaction on keybord:
;; - left key -> chage tank direction to left (-1)
;; - right key -> chage tank direction to right (1)
;; - spacebar key -> calls (new-missile g)
(check-expect (handle-key G1 "b") G1)
(check-expect (handle-key G1 " ")
              (make-game empty
                         (new-missile empty (tank-x (game-tank G1)))
                         T1))
(check-expect (handle-key G1 "left")
              (make-game empty empty (make-tank (tank-x (game-tank G1)) -1)))
(check-expect (handle-key G1 "right")
              (make-game empty empty (make-tank (tank-x (game-tank G1)) 1)))

;(define (handle-key g ke) g) ; stub

(define (handle-key g ke)
  (cond [(key=? ke "left")
         (make-game
          (game-invaders g)
          (game-missiles g)
          (make-tank (tank-x (game-tank g)) -1))]
        [(key=? ke "right")
         (make-game
          (game-invaders g)
          (game-missiles g)
          (make-tank (tank-x (game-tank g)) 1))]
        [(key=? ke " ")
         (make-game
          (game-invaders g)
          (new-missile (game-missiles g) (tank-x (game-tank g)))
          (game-tank g))]
        [else g]))

;---------------------------------------------------------------------------------------
;; Game -> Image
;; render the game based on helper functions (render-tank, render-missiles, render-invaders)
(check-expect (render-game G1) (place-image TANK (tank-x T1) (- HEIGHT TANK-HEIGHT/2)  BACKGROUND))
(check-expect (render-game G2)
              (place-image TANK (tank-x T1) (- HEIGHT TANK-HEIGHT/2)
                           (place-image INVADER (invader-x I1) (invader-y I1)
                                        (place-image MISSILE (missile-x M1) (missile-y M1) BACKGROUND))))

; (define (render-game g) (square 0 "solid" "white")) ; stub

(define (render-game g)
  (render-tank (game-tank g)
               (render-missiles (game-missiles g)
                                (render-invaders (game-invaders g) BACKGROUND))))
       

;---------------------------------------------------------------------------------------
;; ListOfInvaders img -> IMAGE
;; renders image of all invaders in the provided list on the img background
(check-expect (render-invaders empty BACKGROUND) BACKGROUND)
(check-expect (render-invaders LOI1 BACKGROUND)
              (place-image INVADER 150 100 BACKGROUND))
(check-expect (render-invaders LOI2 BACKGROUND)
              (place-image INVADER 150 100 (place-image INVADER 150 HEIGHT BACKGROUND)))

;(define (render-invaders loi img) (square 0 "solid" "white")) ;stub

(define (render-invaders loi img)
  (cond [(empty? loi) BACKGROUND]; (square 10 "outline" "black") ]                  
        [else
         (place-image INVADER (invader-x (first loi)) (invader-y (first loi)) 
                      (render-invaders (rest loi) img))]))


;---------------------------------------------------------------------------------------
;; ListOfMissiles img -> IMAGE
;; renders image of all missiles in the provided list on the img background
(check-expect (render-missiles empty BACKGROUND) BACKGROUND)
(check-expect (render-missiles LOM1 BACKGROUND)
              (place-image MISSILE 150 300 BACKGROUND))
(check-expect (render-missiles LOM2 BACKGROUND)
              (place-image MISSILE 150 300 (place-image MISSILE 150 110 BACKGROUND)))

;(define (render-missiles lom img) (square 0 "solid" "white")) ;stub

(define (render-missiles lom img)
  (cond [(empty? lom) img ]                  
        [else (place-image MISSILE (missile-x (first lom)) (missile-y (first lom))                  
                           (render-missiles (rest lom) img))]))

;---------------------------------------------------------------------------------------
;; TANK img -> IMAGE
;; renders image of tank  on the img background
(check-expect (render-tank T0 BACKGROUND)
              (place-image TANK 150 (- HEIGHT TANK-HEIGHT/2) BACKGROUND))

;(define (render-tank t img) (square 0 "solid" "white")) ;stub

(define (render-tank t img)
  (place-image TANK (tank-x t) (- HEIGHT TANK-HEIGHT/2) img))


;---------------------------------------------------------------------------------------