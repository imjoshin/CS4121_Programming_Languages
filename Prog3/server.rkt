#lang racket
(require "compiler.rkt")
(require "cminus.rkt")

(define (launch-server port)
  (printf "Starting server on port ~a...~n" port)
  ; create listener
  (define listener (tcp-listen port 5 #t))
  ; loop for connection
  ;(define (loop)
  (accept-and-handle listener)
    ;(loop);)
  ;(loop)
  )

(define (accept-and-handle listener)
  (define-values (in out) (tcp-accept listener))
  (displayln "Client connected.")
  ; handle input and output
  (handle in out)
  (close-input-port in)
  (close-output-port out))

(define (handle in out)
  ; read input string into compiler and send response back
  (display (make in) out))

; start
(launch-server 2112)
