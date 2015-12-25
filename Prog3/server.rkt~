#lang racket
(define (launch-server port)
  (printf "Starting server on port ~a...~n" port)
  (define listener (tcp-listen port 5 #t))
  (define (loop)
    (accept-and-handle listener)
    (loop))
  (loop))

(define (accept-and-handle listener)
  (define-values (in out) (tcp-accept listener))
  (displayln "connected")
  (handle in out)
  (close-input-port in)
  (close-output-port out))

(define (handle in out)
  ; Discard the request header (up to blank line):
  (regexp-match #rx"(\r\n|^)\r\n" in)
  ;(display (port->string in))
  (display (read in))
  ; Send reply:
  (display "testing" out))

(launch-server 2112)



(define (compile-file source object)
  (with-output-to-file object	
    (lambda () (compile (open-input-file source)))    
    #:exists 'replace)
  )