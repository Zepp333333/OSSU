;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname space-invaders-starter3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; Space Invaders


;; Constants:

(define WIDTH  300)
(define HEIGHT 500)

(define INVADER-X-SPEED 1)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1)
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
(define TANK-WIDTH/2 (/ (image-width TANK) 2))
(define TANK-WIDTH (image-width TANK))

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


;; ListOfInvaders is on of:
;;  - empty
;;  - (cons Invader ListOfInvaders)
;; interp. list of invaders
(define LOI0 empty)
(define LOI1 (cons I1 empty))
(define LOI2 (cons I2 LOI1))


#;
(define (fn-for-loi loi)
  (cond [(empty? loi) (...)]                   ;BASE CASE
        [else (... (first loi)                 ;Invader
                   (fn-for-loi (rest loi)))])) ;NATURAL RECURSION


(define-struct missile (x y))
;; Missile is (make-missile Number Number)
;; interp. the missile's location is x y in screen coordinates

(define M1 (make-missile 150 300))                       ;not hit U1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  ;exactly hit U1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit U1

#;
(define (fn-for-missile m)
  (... (missile-x m) (missile-y m)))


;; ListOfMissiles is on of:
;;  - empty
;;  - (cons missile ListOfMissiles)
;; interp. list of missiles
(define LOM0 empty)
(define LOM1 (cons M1 empty))
(define LOM2 (cons M2 LOM1))

#;
(define (fn-for-lom lom)
  (cond [(empty? lom) (...)]                   ;BASE CASE
        [else (... (first lom)                 ;Missile
                   (fn-for-lom (rest lom)))])) ;NATURAL RECURSION

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
(check-expect (next-game G0) (make-game (next-invaders (game-invaders G0))
                                        (next-missiles (game-missiles G0))
                                        (next-tank (game-tank G0))))


;(define (next-game g) g) ;stub

(define (next-game g)
  (make-game
    (next-invaders (check-hit-i (game-invaders g) (game-missiles g)))
    (next-missiles (check-hit-m (game-missiles g) (game-invaders g)))
    (next-tank (game-tank g))))



;---------------------------------------------------------------------------------------
;; Game -> Game
;; produce Game state cleaned-up of Missiles and Inviders that are in contact (hit)
(check-expect (clean-hit (make-game empty empty T0)) (make-game empty empty T0))
(check-expect (clean-hit (make-game LOI1 empty T0)) (make-game LOI1 empty T0))
(check-expect (clean-hit (make-game empty LOM1 T0)) (make-game empty LOM1 T0))
(check-expect (clean-hit (make-game LOI2 LOM2 T0))
              (make-game
               (list (make-invader 150 500 -10))
               (list (make-missile 150 300))
               T0))

; (define (clean-hit g) g) ; stub

(define (clean-hit g) 
  (make-game
   (check-hit-i (game-invaders g) (game-missiles g))
   (check-hit-m (game-missiles g) (game-invaders g))
   (game-tank g)))

;------------------------------------------------------------------------------------
;; ListOfInviders ListofMissiles  -> ListOfInviders
;; produce ListOfMissiles net those Missiles that hit Invider(s)
(check-expect (check-hit-i empty empty) empty)
(check-expect (check-hit-i empty LOM1) empty)
(check-expect (check-hit-i LOI1 empty) LOI1)
(check-expect (check-hit-i LOI1 LOM1) LOI1)
(check-expect (check-hit-i LOI2 LOM2) (list (make-invader 150 500 -10)))

;(define (check-hit-i loi lom) loi) ;stub

(define (check-hit-i loi lom)
  (cond [(empty? loi) empty]                   
        [else
         (if (not (hit-i? (first loi) lom))
             (cons (first loi) (check-hit-i (rest loi) lom))
             (check-hit-i (rest loi) lom))]))

;------------------------------------------------------------------------------------
;; Ivider ListOfMissiles -> Boolean
;; provide true if coordinates of Invider are equal to coodrinats of any of Missiles
;; withing the tolerance of a HIT-RANGE (simply if invider is being hit by a missile
(check-expect (hit-i? I1 empty) false)
(check-expect (hit-i? I1 LOM1) false)
(check-expect (hit-i? I1 (list (make-missile 150 300) (make-missile 150 110))) true)

; (define (hit-i? i lom) false); stub

(define (hit-i? i lom)
  (cond [(empty? lom) false]                   
        [else
         (if (and
              (<= (abs (- (missile-x (first lom)) (invader-x i))) HIT-RANGE)
              (<= (abs (- (missile-y (first lom)) (invader-y i))) HIT-RANGE))
             true
             (hit-i? i (rest lom)))]))

;------------------------------------------------------------------------------------
;; ListofMissiles ListOfInviders -> ListofMissiles
;; produce ListOfMissiles net those Missiles that hit Invider(s)
(check-expect (check-hit-m empty empty) empty)
(check-expect (check-hit-m empty LOI1) empty)
(check-expect (check-hit-m LOM1 empty) LOM1)
(check-expect (check-hit-m LOM1 LOI1) LOM1)
(check-expect (check-hit-m LOM2 LOI2) (list (make-missile 150 300)))


;(define (check-hit-m lom loi) lom) ;stub

(define (check-hit-m lom loi)
  (cond [(empty? lom) empty]                   
        [else
         (if (not (hit-m? (first lom) loi))
             (cons (first lom) (check-hit-m (rest lom) loi))
             (check-hit-m (rest lom) loi))]))

;------------------------------------------------------------------------------------
;; Missile ListOfInviders -> Boolean
;; provide true if coordinates of Missile are equal to coodrinats of any of Invaders
;; withing the tolerance of a HIT-RANGE (simply if missile hits any of the inviders)

(check-expect (hit-m? M1 empty) false)
(check-expect (hit-m? M1 LOI2) false)
(check-expect (hit-m? M2 LOI2) true)

;(define (hit-m? m loi) false) ;stub

(define (hit-m? m loi)
  (cond [(empty? loi) false]                   
        [else
         (if (and
              (<= (abs (- (invader-x (first loi)) (missile-x m))) HIT-RANGE)
              (<= (abs (- (invader-y (first loi)) (missile-y m))) HIT-RANGE))
             true
             (hit-m? m (rest loi)))]))

;------------------------------------------------------------------------------------
;; ListOfInvaders -> ListOfInvaders
;; produce ListOfInvaders on next tick based on their direction and speed and "alive-ness"
(check-expect (next-invaders empty) empty)
(check-expect (next-invaders LOI1) (list (next-invader I1 false)))
(check-expect (next-invaders (list I2 I1)) 
              (list (next-invader I2 false) (next-invader I1 false)))
(check-expect (next-invaders (list (make-invader WIDTH 200 12) I1)) 
              (list (next-invader (make-invader WIDTH 200 12) true) (next-invader I1 false)))
(check-expect (next-invaders (list (make-invader 0 200 12) I1)) 
              (list (next-invader (make-invader 0 200 12) true) (next-invader I1 false)))

                                     

;(define (next-invaders LOI) LOI) ;stub

(define (next-invaders loi)
  (cond [(empty? loi) (if (new-invader? loi) (new-invader loi) empty)]                   
        [else
         (if (or (>= (invader-x (first loi)) WIDTH)
                 (<= (invader-x (first loi)) 0))
             (cons (next-invader (first loi) true) (next-invaders (rest loi)))
             (cons (next-invader (first loi) false) (next-invaders (rest loi))))]))


                
;---------------------------------------------------------------------------------------
;; ListOfInvaders -> boolean
;; provides true if it's time to produce a new invider
;; initially based on random distribution and INVADE-RATE
;; further more logic could be added to account for active invaders
(check-random (new-invader? LOI0) (if (<= (random 1000) INVADE-RATE) true false))

;(define (new-invader? loi) false); stub

(define (new-invader? loi)
  (if (<= (random 1000) INVADE-RATE) true false))




;---------------------------------------------------------------------------------------
;; ListOfInvaders -> ListOfInvaders
;; produce new Invader with random direction (invider-dx) into ListOfInviders
;(check-random (new-invader LOI0) (cons (make-invader

;(define (new-invader LOI0) LOI0) ; stub

(define (new-invader loi)
  (cons (make-invader (random WIDTH) 0 12) loi))
        

;---------------------------------------------------------------------------------------
;; Invider Boolean -> Invider
;; Produce next Invider keeping same direction if false or bouncing if true
(check-expect (next-invader I1 false)
              (make-invader (+ 150 (* INVADER-X-SPEED 12))
                            (+ 100 INVADER-Y-SPEED)
                            12))
(check-expect (next-invader (make-invader 300 200 12) true)
              (make-invader (+ 300 (* -1 INVADER-X-SPEED 12))
                            (+ 200 INVADER-Y-SPEED)
                            -12))

; (define (next-invider i false) i) ; stub

(define (next-invader i turn)
  (if (false? turn)
      (make-invader
       (+ (invader-x i) (* (invader-dx i) INVADER-X-SPEED))
       (+ (invader-y i) INVADER-Y-SPEED)
       (invader-dx i))
      (make-invader
       (+ (invader-x i) (* -1 (invader-dx i) INVADER-X-SPEED))
       (+ (invader-y i) INVADER-Y-SPEED)
       (* -1 (invader-dx i)))))


;---------------------------------------------------------------------------------------
;; ListOfMissiles -> ListOfMissiles
;; produce ListOfMissiled based on their speed and x coord, omits those missiles
;; that are not visible (missile-visible?) anymore
(check-expect (next-missiles LOM0) empty)
(check-expect (next-missiles LOM1) (cons
                                    (make-missile (missile-x M1)
                                                  (- (missile-y M1) MISSILE-SPEED))
                                    empty))
(check-expect (next-missiles (cons (make-missile 200 0) LOM1)) (cons
                                                                (make-missile (missile-x M1)
                                                                              (- (missile-y M1) MISSILE-SPEED))
                                                                empty))
             
;(define (next-missiles lom) lom) ; stub

(define (next-missiles lom)
  (cond [(empty? lom) empty]                   
        [else
         (if (missile-visible? (first lom))
             (cons (make-missile (missile-x (first lom))
                                 (- (missile-y (first lom)) MISSILE-SPEED))                 
                   (next-missiles (rest lom)))
             (next-missiles (rest lom)))]))


;---------------------------------------------------------------------------------------
;; Missile -> Boolean
;; produce true if Missile is visible (still within screen) otherwise - false
(check-expect (missile-visible? M1) true)
(check-expect (missile-visible? (make-missile 120 0)) false)

;(define (missile-visible? m) false) ;stub

(define (missile-visible? m)
  (if (<= (missile-y m) 0) false true))

;---------------------------------------------------------------------------------------
;; ListOfMissiles Integer -> ListOfMissiles
;; produce new missile at x coordinate x into ListOfMissiles
(check-expect (new-missile empty 150) (cons (make-missile 150 (- HEIGHT (image-height TANK))) empty))

; (define (new-missile lom x) lom) ;stub

(define (new-missile lom x) (cons (make-missile x (- HEIGHT (image-height TANK))) lom))                  

;---------------------------------------------------------------------------------------
;; Tank -> Tank
;; Produce next Tank based on direction and speed
(check-expect (next-tank T0) (make-tank (+ (tank-x T0) TANK-SPEED) (tank-dir T0)))
(check-expect (next-tank T2) (make-tank (- (tank-x T2) TANK-SPEED) (tank-dir T2)))
(check-expect (next-tank (make-tank (+ 0 TANK-WIDTH/2 1) -1))
              (make-tank (+ 0 TANK-WIDTH/2 1 TANK-SPEED) 1))
(check-expect (next-tank (make-tank (- WIDTH TANK-WIDTH/2 1) 1))
              (make-tank (- WIDTH TANK-WIDTH/2 1 TANK-SPEED) -1))

; (define (next-tank t) t) ; stub

(define (next-tank t)
  (cond [(<= (tank-x t) (+ 0 TANK-WIDTH/2 1)) 
         (make-tank (+ (tank-x t) TANK-SPEED) 1)]
        [(>= (tank-x t) (- WIDTH TANK-WIDTH/2 1))
         (make-tank (- (tank-x t) TANK-SPEED) -1)]
        [else
         (make-tank (+ (tank-x t) (* (tank-dir t) TANK-SPEED)) (tank-dir t))]))                  


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